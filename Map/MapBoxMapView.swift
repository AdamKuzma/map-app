import SwiftUI
import MapboxMaps
import CoreLocation


// MARK: - MapBoxMapView (Move to MapBoxMapView.swift)
struct MapBoxMapView: UIViewRepresentable {
    let locationManager: LocationManager
    @Binding var isTestMode: Bool
    @Binding var isLocationTracking: Bool
    @Binding var isExploreMode: Bool
    @Binding var exploredPercentage: Double
    @Binding var currentNeighborhood: String
    
    class Coordinator: NSObject {
        var styleLoadedToken: AnyCancelable?
        var testTimer: Timer?
        var updateUITimer: Timer?
        var cameraChangedToken: AnyCancelable?
        var currentTestLocation: CLLocationCoordinate2D?
        var isTestRunning = false
        
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
        
        // Hide the scale bar and minimize attribution
        mapView.ornaments.options.scaleBar.margins = .init(x: -100, y: -100)  // Move scale bar off screen
        mapView.ornaments.options.attributionButton.margins = .init(x: -100, y: -100)  // Move attribution off screen
        mapView.ornaments.options.logo.position = .bottomLeft
        mapView.ornaments.options.logo.margins = .init(x: 3, y: 3)
        
        // Configure location manager
        mapView.location.options = locationOptions
        mapView.location.override(provider: locationManager.locationProvider)
        
        // Add fog of war overlay
        let fogOverlay = FogOverlay(mapView: mapView, isExploreMode: isExploreMode)
        mapView.addSubview(fogOverlay)
        
        // Update fog overlay when map changes
        context.coordinator.cameraChangedToken = mapView.mapboxMap.onCameraChanged.observe { _ in
            fogOverlay.frame = mapView.bounds
            fogOverlay.setNeedsDisplay()
        }
        
        // Update fog overlay when location changes
        locationManager.onLocationUpdate = { location in
            if fogOverlay.isExploreMode {
                fogOverlay.currentLocation = location
                fogOverlay.addLocation(location)
                
                // Update neighborhood name in explore mode
                let newNeighborhood = Neighborhoods.getNeighborhoodName(for: location)
                if newNeighborhood != self.currentNeighborhood {
                    DispatchQueue.main.async {
                        self.currentNeighborhood = newNeighborhood
                    }
                }
            }
            
            // Center on location if we haven't moved the map yet
            if mapView.mapboxMap.cameraState.center.latitude == 0 && 
               mapView.mapboxMap.cameraState.center.longitude == 0 {
                let camera = CameraOptions(center: location, zoom: 15)
                mapView.mapboxMap.setCamera(to: camera)
            }
        }
        
        // Add Park Slope boundary after style is loaded
        context.coordinator.styleLoadedToken = mapView.mapboxMap.onStyleLoaded.observe { _ in
            addNeighborhoodBoundaries(to: mapView)
        }
        
        // Start UI update timer for percentage only
        context.coordinator.updateUITimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let currentLocation = fogOverlay.currentLocation {
                exploredPercentage = fogOverlay.calculateExploredPercentage()
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MapboxMaps.MapView, context: Context) {
        // Update fog overlay frame and mode
        if let fogOverlay = uiView.subviews.first(where: { $0 is FogOverlay }) as? FogOverlay {
            fogOverlay.frame = uiView.bounds
            
            // Handle mode changes
            if fogOverlay.isExploreMode != isExploreMode {
                fogOverlay.setMode(isExplore: isExploreMode)
                if !isExploreMode {
                    fogOverlay.clearVisitedLocations()
                }
            }
            
            // Start or stop test mode
            if isTestMode && !isExploreMode && !context.coordinator.isTestRunning {
                startTestMode(fogOverlay: fogOverlay, coordinator: context.coordinator)
            } else if !isTestMode {
                context.coordinator.stopTest()
            }
            
            // Only update camera position when location tracking is triggered
            if isLocationTracking, let location = locationManager.currentLocation {
                let camera = CameraOptions(center: location, zoom: 15)
                uiView.mapboxMap.setCamera(to: camera)
                // Reset tracking flag
                DispatchQueue.main.async {
                    isLocationTracking = false
                }
            }
            
            // Update explored percentage
            DispatchQueue.main.async {
                let percentage = fogOverlay.calculateExploredPercentage()
                print("Total area: \(fogOverlay.calculatePolygonArea(Neighborhoods.parkSlope.boundary))")
                print("Number of locations: \(fogOverlay.isExploreMode ? fogOverlay.visitedLocations.count : fogOverlay.testLocations.count)")
                print("Calculated percentage: \(percentage)%")
                self.exploredPercentage = percentage
            }
        }
    }
    
    func dismantleUIView(_ uiView: MapboxMaps.MapView, coordinator: Coordinator) {
        coordinator.stopTest()
        coordinator.stopUpdateTimer()
    }
    
    private func startTestMode(fogOverlay: FogOverlay, coordinator: Coordinator) {
        // Only start if not already running
        guard !coordinator.isTestRunning else { return }
        
        // Clear existing locations
        fogOverlay.currentLocation = nil
        fogOverlay.clearVisitedLocations()
        
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
            let stepSize = 0.0005 // Adjust this value to control speed
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
        lineLayer.lineColor = Value<StyleColor>.constant(StyleColor(color))
        lineLayer.lineWidth = Value<Double>.constant(3.0)
        
        do {
            try mapView.mapboxMap.addSource(source)
            try mapView.mapboxMap.addLayer(lineLayer)
        } catch {
            print("Error adding \(id) boundary: \(error)")
        }
    }
    
    private func addNeighborhoodBoundaries(to mapView: MapboxMaps.MapView) {
        addBoundary(to: mapView, boundary: Neighborhoods.parkSlope.boundary, id: "park-slope", color: .blue)
        addBoundary(to: mapView, boundary: Neighborhoods.prospectPark.boundary, id: "prospect-park", color: .green)
        print("Successfully added Park Slope and Prospect Park boundaries")
    }
    
    private var locationOptions: LocationOptions {
        var options = LocationOptions()
        options.puckType = .puck2D()
        options.puckBearingEnabled = true
        return options
    }
}
