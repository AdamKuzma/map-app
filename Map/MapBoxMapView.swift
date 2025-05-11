import SwiftUI
import MapboxMaps
import CoreLocation

/// Context for Cursor AI:
/// Use the latest SwiftUI syntax (as of Xcode 15, iOS 17).
/// Use Mapbox Maps SDK v11+ for iOS (using `MapboxMaps` package).
/// Prefer `.task`, `@State`, and `Observable` over older patterns.
/// Assume the app uses Swift Concurrency (async/await), not Combine.


// MARK: - MapBoxMapView
struct MapBoxMapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    @Binding var isExploreMode: Bool
    @Binding var exploredPercentage: Double
    @Binding var currentNeighborhood: String
    @Binding var fogOverlay: FogOverlay?
    @Binding var renderingMode: ContentView.RenderingMode
    
    class Coordinator: NSObject {
        var styleLoadedToken: AnyCancelable?
        var updateUITimer: Timer?
        var cameraChangedToken: AnyCancelable?
        weak var fogOverlay: FogOverlay?
        
        func stopUpdateTimer() {
            updateUITimer?.invalidate()
            updateUITimer = nil
        }
        
        func cancelObservations() {
            cameraChangedToken?.cancel()
            styleLoadedToken?.cancel()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> MapboxMaps.MapView {
        // Use your custom style from Mapbox dashboard with rawValue constructor
        // This doesn't return an optional and avoids unwrapping issues
        let styleURI = StyleURI(rawValue: "mapbox://styles/akuzma18/clynrcx48001u01qn4pkdhso4")
        
        // Set up map with custom style
        let options = MapInitOptions(styleURI: styleURI)
        let mapView = MapboxMaps.MapView(frame: .zero, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Hide the scale bar and minimize attribution
        mapView.ornaments.options.scaleBar.margins = .init(x: -100, y: -100)  // Move scale bar off screen
        mapView.ornaments.options.attributionButton.margins = .init(x: -100, y: -100)  // Move attribution off screen
        mapView.ornaments.options.logo.position = .bottomLeft
        mapView.ornaments.options.logo.margins = .init(x: 3, y: 3)
        
        // Configure location manager
        mapView.location.options = locationOptions
        mapView.location.override(provider: locationManager.locationProvider)
        
        // Add fog of war overlay
        let fogOverlay = FogOverlay(mapView: mapView, isExploreMode: true, locationManager: locationManager)
        mapView.addSubview(fogOverlay)
        fogOverlay.frame = mapView.bounds
        fogOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        context.coordinator.fogOverlay = fogOverlay
        
        // Update fog overlay when map changes
        context.coordinator.cameraChangedToken = mapView.mapboxMap.onCameraChanged.observe { _ in
            fogOverlay.frame = mapView.bounds
            fogOverlay.setNeedsDisplay()
            
            // Update fog view mode based on camera pitch and rendering mode
            self.updateRenderingMode(mapView, renderingMode: self.renderingMode)
        }
        
        // Update fog overlay when location changes
        locationManager.onLocationUpdate = { location, speed in
            if fogOverlay.isExploreMode {
                fogOverlay.currentLocation = location
                fogOverlay.addLocation(location, speed: speed)
                
                // Update Mapbox layers if that rendering mode is active
                if self.renderingMode == .mapbox {
                    self.updateMapboxFogCircles(mapView, locations: fogOverlay.visitedLocations)
                }
            }
            
            // Center on location if we haven't moved the map yet
            if mapView.mapboxMap.cameraState.center.latitude == 0 && 
               mapView.mapboxMap.cameraState.center.longitude == 0 {
                let camera = CameraOptions(
                    center: location,
                    zoom: 15,
                    bearing: 0,
                    pitch: 45.0  // Set default pitch for 3D view
                )
                mapView.mapboxMap.setCamera(to: camera)
            }
        }
        
        // Add Park Slope boundary after style is loaded
        context.coordinator.styleLoadedToken = mapView.mapboxMap.onStyleLoaded.observe { _ in
            addNeighborhoodBoundaries(to: mapView)

            // Set camera for 3D
            let currentCamera = mapView.mapboxMap.cameraState
            let camera = CameraOptions(
                center: currentCamera.center,
                zoom: max(currentCamera.zoom, 16.0),
                bearing: currentCamera.bearing,
                pitch: 60.0
            )
            mapView.mapboxMap.setCamera(to: camera)
            
            // Simple 3D building setup with minimal error potential
            do {
                // Try to add a 3D building layer
                var layer = FillExtrusionLayer(id: "custom-3d-buildings", source: "composite")
                layer.sourceLayer = "building"
                layer.minZoom = 15
                layer.fillExtrusionColor = .constant(StyleColor(.lightGray))
                layer.fillExtrusionHeight = .expression(Exp(.get) { "height" })
                layer.fillExtrusionBase = .expression(Exp(.get) { "min_height" })
                layer.fillExtrusionOpacity = .constant(0.6)
                
                try? mapView.mapboxMap.style.addLayer(layer)
                print("Attempted to add 3D buildings layer")
            } catch {
                print("Error with 3D buildings: \(error)")
            }
            
            // Initialize Mapbox layers if needed
            if self.renderingMode == .mapbox && fogOverlay.visitedLocations.count > 0 {
                self.updateMapboxFogCircles(mapView, locations: fogOverlay.visitedLocations)
            }
            
            print("Map style loaded, 3D view enabled")
        }
        
        // Start UI update timer for percentage only
        context.coordinator.updateUITimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if let currentLocation = fogOverlay.currentLocation {
                // First update the neighborhood name if needed
                let newNeighborhood = Neighborhoods.getNeighborhoodName(for: currentLocation)
                if newNeighborhood != self.currentNeighborhood {
                    DispatchQueue.main.async {
                        self.currentNeighborhood = newNeighborhood
                    }
                }
                
                // Then calculate percentage for the current neighborhood
                if let neighborhood = Neighborhoods.getNeighborhoodForName(self.currentNeighborhood) {
                    exploredPercentage = fogOverlay.calculateNeighborhoodPercentage(neighborhood)
                } else {
                    exploredPercentage = 0.0
                }
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MapboxMaps.MapView, context: Context) {
        // Update fog overlay reference if needed
        if let overlay = mapView.subviews.first(where: { $0 is FogOverlay }) as? FogOverlay {
            if self.fogOverlay == nil {
                DispatchQueue.main.async {
                    self.fogOverlay = overlay
                    print("FogOverlay updated in updateUIView")
                    
                    // Initialize the Mapbox layers if needed
                    if self.renderingMode == .mapbox && overlay.visitedLocations.count > 0 {
                        self.updateMapboxFogCircles(mapView, locations: overlay.visitedLocations)
                    }
                    
                    // Add observer for location updates with captured mapView
                    let capturedMapView = mapView
                    self.fogOverlay?.onLocationAdded = {
                        if self.renderingMode == .mapbox {
                            self.updateMapboxFogCircles(capturedMapView, locations: overlay.visitedLocations)
                        }
                    }
                }
            }
            
            // Update rendering mode
            updateRenderingMode(mapView, renderingMode: renderingMode)
        }
    }
    
    func dismantleUIView(_ uiView: MapboxMaps.MapView, coordinator: Coordinator) {
        coordinator.stopUpdateTimer()
    }
    
    private func addBoundary(to mapView: MapboxMaps.MapView, boundary: [CLLocationCoordinate2D], id: String, color: UIColor) {
        let coordinates = [boundary]
        let polygon = Polygon(coordinates)
        let feature = Feature(geometry: .polygon(polygon))
        
        var source = GeoJSONSource(id: "\(id)-source")
        source.data = .feature(feature)
        
        var lineLayer = LineLayer(id: "\(id)-line", source: "\(id)-source")
        let transparentColor = color.withAlphaComponent(0.8) // Increased opacity for better visibility
        lineLayer.lineColor = Value<StyleColor>.constant(StyleColor(transparentColor))
        lineLayer.lineWidth = Value<Double>.constant(1.5) // Slightly thicker line
        
        // Remove line dash array for solid lines
        // lineLayer.lineDasharray = Value<[Double]>.constant([2, 2])
        
        // Make sure lines are visible on top of other layers
        lineLayer.slot = .top
        
        do {
            try mapView.mapboxMap.addSource(source)
            try mapView.mapboxMap.addLayer(lineLayer)
        } catch {
            print("Error adding \(id) boundary: \(error)")
        }
    }
    
    private func addNeighborhoodBoundaries(to mapView: MapboxMaps.MapView) {
        // Use white for all boundaries 
        addBoundary(to: mapView, boundary: Neighborhoods.parkSlope.boundary, id: "park-slope", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.prospectPark.boundary, id: "prospect-park", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.greenwoodHeights.boundary, id: "greenwood-heights", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.gowanus.boundary, id: "gowanus", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.windsorTerrace.boundary, id: "windsor-terrace", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.carrollGardens.boundary, id: "carroll-gardens", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.cobbleHill.boundary, id: "cobble-hill", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.boeumHill.boundary, id: "boerum-hill", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.prospectHeights.boundary, id: "prospect-heights", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.crownHeights.boundary, id: "crown-heights", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.fortGreene.boundary, id: "fort-greene", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.columbiaWaterfront.boundary, id: "columbia-waterfront", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.brooklynHeights.boundary, id: "brooklyn-heights", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.dumbo.boundary, id: "dumbo", color: .white)
        addBoundary(to: mapView, boundary: Neighborhoods.downtownBrooklyn.boundary, id: "downtown-brooklyn", color: .white)
        print("Successfully added neighborhood boundaries with white lines")
    }
    
    private var locationOptions: LocationOptions {
        var options = LocationOptions()
        options.puckType = .puck2D()
        options.puckBearingEnabled = true
        return options
    }
    
    // MARK: - Rendering Mode Handling
    
    // Method to update the rendering mode
    private func updateRenderingMode(_ mapView: MapboxMaps.MapView, renderingMode: ContentView.RenderingMode) {
        if let fogOverlay = self.fogOverlay {
            switch renderingMode {
            case .overlay:
                // For overlay mode, show/hide based on pitch
                let pitch = mapView.mapboxMap.cameraState.pitch
                fogOverlay.isHidden = pitch > 0 // Hide overlay in 3D mode
                
                // Clean up any Mapbox layers
                cleanupMapboxLayers(mapView)
                
            case .mapbox:
                // For Mapbox mode, always hide the overlay
                fogOverlay.isHidden = true
                
                // Update or create Mapbox layers
                updateMapboxFogCircles(mapView, locations: fogOverlay.visitedLocations)
            }
        }
    }
    
    // MARK: - Mapbox Native Circles
    
    // Update Mapbox layers to show visited locations as cleared areas in a fog
    private func updateMapboxFogCircles(_ mapView: MapboxMaps.MapView, locations: [CLLocationCoordinate2D]) {
        do {
            // First clean up any existing layers
            cleanupMapboxLayers(mapView)
            
            // Skip if no locations
            if locations.isEmpty {
                return
            }
            
            // First approach: Create a background fog layer
            var fogBackgroundLayer = BackgroundLayer(id: "mapbox-fog-background")
            fogBackgroundLayer.backgroundColor = .constant(StyleColor(UIColor(white: 0.0, alpha: 0.7))) // Dark fog
            fogBackgroundLayer.backgroundOpacity = .constant(0.7)
            fogBackgroundLayer.slot = .middle
            
            try mapView.mapboxMap.style.addLayer(fogBackgroundLayer)
            
            // Create features for each location
            var features: [Feature] = []
            for location in locations {
                let point = Point(location)
                let feature = Feature(geometry: .point(point))
                features.append(feature)
            }
            
            // Create source with all points
            var circleSource = GeoJSONSource(id: "mapbox-circles-source")
            circleSource.data = .featureCollection(FeatureCollection(features: features))
            
            try mapView.mapboxMap.style.addSource(circleSource)
            
            // Create a negative heatmap layer that clears fog around explored areas
            var heatmapLayer = HeatmapLayer(id: "mapbox-fog-clearance-layer", source: "mapbox-circles-source")
            
            // Configure the heatmap to create clear spots at visited locations
            // Smaller radius for more defined edges at low zoom, increasingly larger at high zoom
            heatmapLayer.heatmapRadius = .expression(
                Exp(.interpolate) {
                    Exp(.exponential) { 2.5 } // More aggressive scaling with zoom
                    Exp(.zoom)
                    10; 30   // Sharper edges at low zoom
                    14; 40   // Grows faster with zoom
                    16; 80   // Much larger at high zoom for less specificity
                    18; 90  // Very large at highest zoom levels
                }
            )
            
            // Create an opacity gradient that's more diffuse at high zoom
            heatmapLayer.heatmapColor = .expression(
                Exp(.interpolate) {
                    Exp(.linear)
                    Exp(.heatmapDensity)
                    0.0; UIColor(white: 0.0, alpha: 0.7)  // Full fog
                    0.4; UIColor(white: 0.0, alpha: 0.7)  // Still full fog (creates sharper edge)
                    0.5; UIColor(white: 0.0, alpha: 0.5)  // Start transition
                    0.6; UIColor(white: 0.0, alpha: 0.3)  // Mid transition
                    0.7; UIColor(white: 0.0, alpha: 0.0)  // Clear
                }
            )
            
            // Scale intensity with zoom to be more diffuse at higher zooms
            heatmapLayer.heatmapIntensity = .expression(
                Exp(.interpolate) {
                    Exp(.linear)
                    Exp(.zoom)
                    10; 1.8  // More intense at low zoom for better visibility
                    14; 1.5  // Slightly less intense at mid zoom
                    16; 1.2  // Less intense at high zoom for more diffuse effect
                    18; 1.0  // Minimum intensity at maximum zoom
                }
            )
            
            heatmapLayer.heatmapOpacity = .constant(1.0)
            heatmapLayer.slot = .top
            
            try mapView.mapboxMap.style.addLayer(heatmapLayer)
            
            // Add current location as a separate point with a completely clear spot
            if let currentLocation = self.fogOverlay?.currentLocation {
                let currentPoint = Point(currentLocation)
                let currentFeature = Feature(geometry: .point(currentPoint))
                
                var currentSource = GeoJSONSource(id: "current-location-source")
                currentSource.data = .feature(currentFeature)
                
                try mapView.mapboxMap.style.addSource(currentSource)
                
                // Create a circle layer for the current location that clears fog completely
                var currentLayer = CircleLayer(id: "current-location-layer", source: "current-location-source")
                
                // Make the circle larger at higher zoom levels
                currentLayer.circleRadius = .expression(
                    Exp(.interpolate) {
                        Exp(.exponential) { 2 }
                        Exp(.zoom)
                        10; 20
                        14; 40
                        16; 60
                        18; 80
                    }
                )
                
                // Make a transparent circle that will "cut through" the fog
                currentLayer.circleColor = .constant(StyleColor(UIColor(white: 0.0, alpha: 0.0)))
                currentLayer.circleOpacity = .constant(1.0)
                currentLayer.circleBlur = .constant(1.0) // Add blur for a soft transition
                currentLayer.circlePitchAlignment = .constant(.map) // Follow terrain
                
                // Add a subtle white border to indicate current position
                currentLayer.circleStrokeColor = .constant(StyleColor(UIColor(white: 1.0, alpha: 0.6)))
                currentLayer.circleStrokeWidth = .constant(2.0)
                currentLayer.slot = .middle
                
                try mapView.mapboxMap.style.addLayer(currentLayer)
            }
            
            print("Updated Mapbox fog of war with \(locations.count) explored locations")
            
        } catch {
            print("Error creating Mapbox fog of war: \(error)")
        }
    }
    
    // Clean up Mapbox layers
    private func cleanupMapboxLayers(_ mapView: MapboxMaps.MapView) {
        do {
            let layerIds = ["mapbox-fog-background", "mapbox-fog-clearance-layer", "current-location-layer"]
            for id in layerIds {
                if mapView.mapboxMap.style.layerExists(withId: id) {
                    try mapView.mapboxMap.style.removeLayer(withId: id)
                }
            }
            
            let sourceIds = ["mapbox-circles-source", "current-location-source"]
            for id in sourceIds {
                if mapView.mapboxMap.style.sourceExists(withId: id) {
                    try mapView.mapboxMap.style.removeSource(withId: id)
                }
            }
        } catch {
            print("Error cleaning up Mapbox layers: \(error)")
        }
    }
}
