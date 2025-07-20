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
    @Binding var currentZoomLevel: Double
    
    class Coordinator: NSObject {
        var styleLoadedToken: AnyCancelable?
        var updateUITimer: Timer?
        var cameraChangedToken: AnyCancelable?
        weak var fogOverlay: FogOverlay?
        // Track last state to prevent unnecessary layer updates
        var lastFogShouldBeHidden: Bool? = nil
        // Track if we've already centered on the user
        var hasCenteredOnUser = false
        
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
        // let styleURI = StyleURI(rawValue: "mapbox://styles/akuzma18/clynrcx48001u01qn4pkdhso4")
        let styleURI = StyleURI(rawValue: "mapbox://styles/akuzma18/clau9tehp001v15qxqpn3bj00")


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
            
            // Always redraw the overlay when camera changes to update the perspective
            if let fogOverlay = self.fogOverlay {
                fogOverlay.setNeedsDisplay()
            }
            
            // Update the current zoom level
            self.currentZoomLevel = mapView.mapboxMap.cameraState.zoom

            // --- BEGIN: Custom zoom logic ---
            let zoom = self.currentZoomLevel
            // let fogShouldBeHidden = zoom <= 12
            let coordinator = context.coordinator
            // if coordinator.lastFogShouldBeHidden == nil || coordinator.lastFogShouldBeHidden != fogShouldBeHidden {
            //     coordinator.lastFogShouldBeHidden = fogShouldBeHidden
            //     // DispatchQueue.main.async {
            //     //     fogOverlay.isHidden = fogShouldBeHidden
            //     // }
            //     // Remove any existing green fill layers and sources
            //     let fillLayerPrefix = "neighborhood-fill-"
            //     let sourcePrefix = "neighborhood-fill-source-"
            //     let allNeighborhoods: [(String, Neighborhood)] = [
            //         ("park-slope", Neighborhoods.parkSlope),
            //         ("prospect-park", Neighborhoods.prospectPark),
            //         ("greenwood-heights", Neighborhoods.greenwoodHeights),
            //         ("gowanus", Neighborhoods.gowanus),
            //         ("windsor-terrace", Neighborhoods.windsorTerrace),
            //         ("carroll-gardens", Neighborhoods.carrollGardens),
            //         ("cobble-hill", Neighborhoods.cobbleHill),
            //         ("boerum-hill", Neighborhoods.boeumHill),
            //         ("prospect-heights", Neighborhoods.prospectHeights),
            //         ("crown-heights", Neighborhoods.crownHeights),
            //         ("fort-greene", Neighborhoods.fortGreene),
            //         ("columbia-waterfront", Neighborhoods.columbiaWaterfront),
            //         ("brooklyn-heights", Neighborhoods.brooklynHeights),
            //         ("dumbo", Neighborhoods.dumbo),
            //         ("downtown-brooklyn", Neighborhoods.downtownBrooklyn)
            //     ]
            //     for (id, _) in allNeighborhoods {
            //         let fillLayerId = fillLayerPrefix + id
            //         let sourceId = sourcePrefix + id
            //         if mapView.mapboxMap.style.layerExists(withId: fillLayerId) {
            //             try? mapView.mapboxMap.style.removeLayer(withId: fillLayerId)
            //         }
            //         if mapView.mapboxMap.style.sourceExists(withId: sourceId) {
            //             try? mapView.mapboxMap.style.removeSource(withId: sourceId)
            //         }
            //     }
            //     // if fogShouldBeHidden {
            //     //     // Add green fills and boundaries
            //     //     for (id, neighborhood) in allNeighborhoods {
            //     //         let coordinates = [neighborhood.boundary]
            //     //         let polygon = Polygon(coordinates)
            //     //         let feature = Feature(geometry: .polygon(polygon))
            //     //         var source = GeoJSONSource(id: sourcePrefix + id)
            //     //         source.data = .feature(feature)
            //     //         try? mapView.mapboxMap.style.addSource(source)
            //     //         var fillLayer = FillLayer(id: fillLayerPrefix + id, source: sourcePrefix + id)
            //     //         // Determine fill color based on explored percentage
            //     //         var percent: Double = 0.0
            //     //         if let fogOverlay = self.fogOverlay {
            //     //             percent = fogOverlay.calculateNeighborhoodPercentage(neighborhood)
            //     //         }
            //     //         let fillColor: UIColor
            //     //         if percent == 0.0 {
            //     //             fillColor = UIColor.gray
            //     //         } else if percent <= 30.0 {
            //     //             fillColor = UIColor(red: 0.7, green: 1.0, blue: 0.7, alpha: 1.0) // light green
            //     //         } else if percent <= 70.0 {
            //     //             fillColor = UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0) // medium green
            //     //         } else if percent < 100.0 {
            //     //             fillColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) // dark green
            //     //         } else {
            //     //             fillColor = UIColor(red: 0.0, green: 0.8, blue: 0.7, alpha: 1.0) // blueish green
            //     //         }
            //     //         fillLayer.fillColor = .constant(StyleColor(fillColor.withAlphaComponent(0.5)))
            //     //         fillLayer.fillOpacity = .constant(0.5)
            //     //         fillLayer.fillOutlineColor = .constant(StyleColor(.clear))
            //     //         try? mapView.mapboxMap.style.addLayer(fillLayer)
            //     //     }
            //     //     // After all fills, re-add all boundary lines above the fills
            //     //     for (id, neighborhood) in allNeighborhoods {
            //     //         addBoundary(to: mapView, boundary: neighborhood.boundary, id: id, color: .white)
            //     //     }
            //     // } else {
            //     //     // Only add boundaries (no fill)
            //     //     for (id, neighborhood) in allNeighborhoods {
            //     //         addBoundary(to: mapView, boundary: neighborhood.boundary, id: id, color: .white)
            //     //     }
            //     // }
            // } else {
            //     // Only update fog overlay visibility on pan/zoom if not crossing threshold
            //     // DispatchQueue.main.async {
            //     //     fogOverlay.isHidden = fogShouldBeHidden
            //     // }
            // }
            // --- END: Custom zoom logic ---
        }
        
        // Update fog overlay when location changes
        locationManager.onLocationUpdate = { location, speed in
            if fogOverlay.isExploreMode {
                fogOverlay.currentLocation = location
                fogOverlay.addLocation(location, speed: speed)
                // Update Mapbox layers if that rendering mode is active
                // if self.renderingMode == .mapbox {
                //     self.updateMapboxFogCircles(mapView, locations: fogOverlay.visitedLocations)
                // }
            }
            
            // Center on user location the first time we get a valid location
            if !context.coordinator.hasCenteredOnUser {
                let camera = CameraOptions(
                    center: location,
                    zoom: 14
                    // bearing: 0
                    // pitch: 45.0  // Set default pitch for 3D view (commented out)
                )
                mapView.mapboxMap.setCamera(to: camera)
                context.coordinator.hasCenteredOnUser = true
            }
        }
        
        // Add Park Slope boundary after style is loaded
        context.coordinator.styleLoadedToken = mapView.mapboxMap.onStyleLoaded.observe { _ in
            addNeighborhoodBoundaries(to: mapView)

            // Set camera for 3D
            let currentCamera = mapView.mapboxMap.cameraState
            let camera = CameraOptions(
                center: currentCamera.center,
                zoom: max(currentCamera.zoom, 14)
                // bearing: currentCamera.bearing
                // pitch: 60.0 // Commented out 3D pitch
            )
            mapView.mapboxMap.setCamera(to: camera)
            
            // Simple 3D building setup with minimal error potential
            // do {
            //     // Try to add a 3D building layer
            //     var layer = FillExtrusionLayer(id: "custom-3d-buildings", source: "composite")
            //     layer.sourceLayer = "building"
            //     layer.minZoom = 15
            //     layer.fillExtrusionColor = .constant(StyleColor(.lightGray))
            //     layer.fillExtrusionHeight = .expression(Exp(.get) { "height" })
            //     layer.fillExtrusionBase = .expression(Exp(.get) { "min_height" })
            //     layer.fillExtrusionOpacity = .constant(0.3)
            //     
            //     try? mapView.mapboxMap.style.addLayer(layer)
            //     print("Attempted to add 3D buildings layer")
            // } catch {
            //     print("Error with 3D buildings: \(error)")
            // }
            
            // Initialize Mapbox layers if needed
            // if self.renderingMode == .mapbox && fogOverlay.visitedLocations.count > 0 {
            //     self.updateMapboxFogCircles(mapView, locations: fogOverlay.visitedLocations)
            // }
            
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
                    // if self.renderingMode == .mapbox && overlay.visitedLocations.count > 0 {
                    //     self.updateMapboxFogCircles(mapView, locations: overlay.visitedLocations)
                    // }
                    
                    // Add observer for location updates with captured mapView
                    let capturedMapView = mapView
                    // self.fogOverlay?.onLocationAdded = {
                    //     if self.renderingMode == .mapbox {
                    //         self.updateMapboxFogCircles(capturedMapView, locations: overlay.visitedLocations)
                    //     }
                    // }
                }
            }
            
            // Update rendering mode
            // updateRenderingMode(mapView, renderingMode: renderingMode)
        }
    }
    
    func dismantleUIView(_ uiView: MapboxMaps.MapView, coordinator: Coordinator) {
        coordinator.stopUpdateTimer()
    }
    
    private func addBoundary(to mapView: MapboxMaps.MapView, boundary: [CLLocationCoordinate2D], id: String) {
        let coordinates = [boundary]
        let polygon = Polygon(coordinates)
        let feature = Feature(geometry: .polygon(polygon))
        
        let sourceId = "\(id)-source"
        let lineLayerId = "\(id)-line"
        let fillLayerId = "neighborhood-fill-\(id)"
        // Remove existing line layer if present
        if mapView.mapboxMap.style.layerExists(withId: lineLayerId) {
            try? mapView.mapboxMap.style.removeLayer(withId: lineLayerId)
        }
        // Add or update the geojson source
        var source = GeoJSONSource(id: sourceId)
        source.data = .feature(feature)
        if mapView.mapboxMap.style.sourceExists(withId: sourceId) {
            try? mapView.mapboxMap.style.removeSource(withId: sourceId)
        }
        try? mapView.mapboxMap.style.addSource(source)
        // Add the line layer above the fill layer if it exists
        var lineLayer = LineLayer(id: lineLayerId, source: sourceId)
        // Use a solid light gray color (no opacity)
        let lightGray = UIColor(red: 0.8, green: 0.8, blue: 0.85, alpha: 0.7)
        lineLayer.lineColor = Value<StyleColor>.constant(StyleColor(lightGray))
        lineLayer.lineWidth = Value<Double>.constant(1.5)
        // Dashed line: gaps will be transparent, not white (Mapbox limitation)
        lineLayer.lineDasharray = Value<[Double]>.constant([6, 4])
        if mapView.mapboxMap.style.layerExists(withId: fillLayerId) {
            try? mapView.mapboxMap.style.addLayer(lineLayer, layerPosition: .above(fillLayerId))
        } else {
            try? mapView.mapboxMap.style.addLayer(lineLayer)
        }
        
        // Update the fill layer to ensure the outline is clear
        var fillLayer = FillLayer(id: fillLayerId, source: sourceId)
        fillLayer.fillColor = .constant(StyleColor(UIColor.clear))
        fillLayer.fillOpacity = .constant(0)
        fillLayer.fillOutlineColor = .constant(StyleColor(.clear))
        try? mapView.mapboxMap.style.addLayer(fillLayer)
    }
    
    private func addNeighborhoodBoundaries(to mapView: MapboxMaps.MapView) {
        // Add all neighborhood boundaries using a for loop
        for neighborhood in Neighborhoods.getAllNeighborhoods() {
            let id = neighborhood.name.lowercased().replacingOccurrences(of: " ", with: "-")
            addBoundary(to: mapView, boundary: neighborhood.boundary, id: id)
        }
        print("Successfully added neighborhood boundaries with thinner, lighter lines")
    }
    
    private var locationOptions: LocationOptions {
        var options = LocationOptions()
        options.puckType = .puck2D()
        options.puckBearingEnabled = true
        return options
    }
}
