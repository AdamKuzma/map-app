import SwiftUI
import MapboxMaps
import CoreLocation


// MARK: - MapBoxMapView (Move to MapBoxMapView.swift)
struct MapBoxMapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    @Binding var isTestMode: Bool
    @Binding var isLocationTracking: Bool
    @Binding var isExploreMode: Bool
    @Binding var exploredPercentage: Double
    @Binding var currentNeighborhood: String
    @Binding var fogOverlay: FogOverlay?
    
    class Coordinator: NSObject {
        var styleLoadedToken: AnyCancelable?
        var testTimer: Timer?
        var updateUITimer: Timer?
        var cameraChangedToken: AnyCancelable?
        var currentTestLocation: CLLocationCoordinate2D?
        var isTestRunning = false
        weak var fogOverlay: FogOverlay?
        
        func stopTest() {
            testTimer?.invalidate()
            testTimer = nil
            isTestRunning = false
            currentTestLocation = nil
        }
        
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
        // Start with default options, we'll set the camera position when we get the location
        let options = MapInitOptions(styleURI: .dark)
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
        }
        
        // Update fog overlay when location changes
        locationManager.onLocationUpdate = { location, speed in
            if fogOverlay.isExploreMode {
                fogOverlay.currentLocation = location
                fogOverlay.addLocation(location, speed: speed)
                
                // The neighborhood update is now handled in the updateUITimer
                // to keep everything consistent in one place
            }
            
            // Center on location if we haven't moved the map yet
            if mapView.mapboxMap.cameraState.center.latitude == 0 && 
               mapView.mapboxMap.cameraState.center.longitude == 0 {
                let camera = CameraOptions(
                    center: location,
                    zoom: 15,
                    bearing: 0,
                    pitch: 45 // Add 45-degree pitch for 3D view
                )
                mapView.mapboxMap.setCamera(to: camera)
            }
        }
        
        // Add Park Slope boundary after style is loaded
        context.coordinator.styleLoadedToken = mapView.mapboxMap.onStyleLoaded.observe { _ in
            addNeighborhoodBoundaries(to: mapView)
            
            // Enable 3D buildings with enhanced visibility
            do {
                // Make sure building layer is visible
                try mapView.mapboxMap.setLayerProperty(for: "building", property: "visibility", value: "visible")
                
                // Increase extrusion height for more dramatic effect
                try mapView.mapboxMap.setLayerProperty(for: "building", property: "extrusion-height", value: 2.0)
                
                // Add some color to make buildings more visible
                try mapView.mapboxMap.setLayerProperty(for: "building", property: "fill-color", value: "#4a90e2")
                try mapView.mapboxMap.setLayerProperty(for: "building", property: "fill-opacity", value: 0.8)
                
                // Enable shadows for better depth perception
                try mapView.mapboxMap.setLayerProperty(for: "building", property: "fill-extrusion-ambient-occlusion", value: true)
                try mapView.mapboxMap.setLayerProperty(for: "building", property: "fill-extrusion-ambient-occlusion-intensity", value: 0.3)
                
                print("Successfully enabled 3D buildings")
            } catch {
                print("Error enabling 3D buildings: \(error)")
            }
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
                }
            }
            
            // Update mode
            overlay.setMode(isExplore: isExploreMode)
        }
        
        if isLocationTracking {
            isLocationTracking = false
            if let currentLocation = locationManager.currentLocation {
                let camera = CameraOptions(center: currentLocation, zoom: 15)
                mapView.mapboxMap.setCamera(to: camera)
            }
        }
        
        if isTestMode {
            if let overlay = mapView.subviews.first(where: { $0 is FogOverlay }) as? FogOverlay {
                startTestMode(fogOverlay: overlay, coordinator: context.coordinator)
            }
        }
    }
    
    func dismantleUIView(_ uiView: MapboxMaps.MapView, coordinator: Coordinator) {
        coordinator.stopTest()
        coordinator.stopUpdateTimer()
    }
    
    private func startTestMode(fogOverlay: FogOverlay, coordinator: Coordinator) {
        // Stop any existing test
        coordinator.stopTest()
        
        // Clear existing locations and reset state
        fogOverlay.currentLocation = nil
        fogOverlay.clearVisitedLocations()
        coordinator.isTestRunning = false
        coordinator.currentTestLocation = nil
        
        // Get current user location or use a default if not available
        let startLocation = locationManager.currentLocation ?? CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855)
        coordinator.currentTestLocation = startLocation
        
        // Set initial neighborhood name
        let initialNeighborhood = Neighborhoods.getNeighborhoodName(for: startLocation)
        currentNeighborhood = initialNeighborhood
        
        // Center map on test location
        if let mapView = fogOverlay.mapView {
            let camera = CameraOptions(center: startLocation, zoom: 15)
            mapView.mapboxMap.setCamera(to: camera)
        }
        
        // Prospect Park coordinates
        let prospectPark = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9690)
        
        // Start a timer to simulate movement
        coordinator.isTestRunning = true
        coordinator.testTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak coordinator] timer in
            guard let coordinator = coordinator,
                  isTestMode && !isExploreMode else {
                timer.invalidate()
                return
            }
            
            guard var currentLocation = coordinator.currentTestLocation else {
                timer.invalidate()
                return
            }
            
            // Calculate direction to Prospect Park
            let latDiff = prospectPark.latitude - currentLocation.latitude
            let lonDiff = prospectPark.longitude - currentLocation.longitude
            
            // Move in the direction of Prospect Park
            // 40 meters ≈ 0.00036 degrees (at this latitude)
            let stepSize = 0.00036 // 40 meters per step
            
            if abs(latDiff) > 0.0001 || abs(lonDiff) > 0.0001 {
                // Move proportionally in both latitude and longitude
                let totalDiff = abs(latDiff) + abs(lonDiff)
                currentLocation.latitude += (latDiff / totalDiff) * stepSize
                currentLocation.longitude += (lonDiff / totalDiff) * stepSize
                
                // Update location
                coordinator.currentTestLocation = currentLocation
                fogOverlay.currentLocation = currentLocation
                fogOverlay.addLocation(currentLocation)
                
                // Update neighborhood name
                let newNeighborhood = Neighborhoods.getNeighborhoodName(for: currentLocation)
                if newNeighborhood != self.currentNeighborhood {
                    DispatchQueue.main.async {
                        self.currentNeighborhood = newNeighborhood
                    }
                }
                
                // Force UI update
                if let mapView = fogOverlay.mapView {
                    mapView.setNeedsDisplay()
                }
            } else {
                // We've reached Prospect Park, stop the timer
                timer.invalidate()
                coordinator.isTestRunning = false
            }
        }
    }
    
    private func addBoundary(to mapView: MapboxMaps.MapView, boundary: [CLLocationCoordinate2D], id: String, color: UIColor) {
        let coordinates = [boundary]
        let polygon = Polygon(coordinates)
        let feature = Feature(geometry: .polygon(polygon))
        
        var source = GeoJSONSource(id: "\(id)-source")
        source.data = .feature(feature)
        
        var lineLayer = LineLayer(id: "\(id)-line", source: "\(id)-source")
        let transparentColor = color.withAlphaComponent(0.5)
        lineLayer.lineColor = Value<StyleColor>.constant(StyleColor(transparentColor))
        lineLayer.lineWidth = Value<Double>.constant(1.2)
        
        // Add dashed line pattern
        lineLayer.lineDasharray = Value<[Double]>.constant([3, 3])
        
        do {
            try mapView.mapboxMap.addSource(source)
            try mapView.mapboxMap.addLayer(lineLayer)
        } catch {
            print("Error adding \(id) boundary: \(error)")
        }
    }
    
    private func addNeighborhoodBoundaries(to mapView: MapboxMaps.MapView) {
        // Use lighter colors for each boundary
        addBoundary(to: mapView, boundary: Neighborhoods.parkSlope.boundary, id: "park-slope", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.prospectPark.boundary, id: "prospect-park", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.greenwoodHeights.boundary, id: "greenwood-heights", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.gowanus.boundary, id: "gowanus", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.windsorTerrace.boundary, id: "windsor-terrace", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.carrollGardens.boundary, id: "carroll-gardens", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.cobbleHill.boundary, id: "cobble-hill", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.boeumHill.boundary, id: "boerum-hill", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.prospectHeights.boundary, id: "prospect-heights", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.crownHeights.boundary, id: "crown-heights", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.fortGreene.boundary, id: "fort-greene", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.columbiaWaterfront.boundary, id: "columbia-waterfront", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.brooklynHeights.boundary, id: "brooklyn-heights", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.dumbo.boundary, id: "dumbo", color: .gray)
        addBoundary(to: mapView, boundary: Neighborhoods.downtownBrooklyn.boundary, id: "downtown-brooklyn", color: .gray)
        print("Successfully added neighborhood boundaries with thinner, lighter lines")
    }
    
    private var locationOptions: LocationOptions {
        var options = LocationOptions()
        options.puckType = .puck2D()
        options.puckBearingEnabled = true
        return options
    }
    
    // Add method to toggle 3D view
    func toggle3DView(_ mapView: MapboxMaps.MapView) {
        let currentCamera = mapView.mapboxMap.cameraState
        let newPitch = currentCamera.pitch == 0 ? 45.0 : 0.0
        let camera = CameraOptions(
            center: currentCamera.center,
            zoom: currentCamera.zoom,
            bearing: currentCamera.bearing,
            pitch: newPitch
        )
        mapView.mapboxMap.setCamera(to: camera)
    }
}
