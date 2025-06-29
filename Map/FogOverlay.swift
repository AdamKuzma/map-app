import UIKit
import MapboxMaps
import CoreLocation

class FogOverlay: UIView {
    weak var mapView: MapView?
    weak var locationManager: LocationManager?
    var currentLocation: CLLocationCoordinate2D?
    let baseRadius: CLLocationDistance = 60 // Base radius in meters
    var visitedLocations: [CLLocationCoordinate2D] = []
    var testLocations: [CLLocationCoordinate2D] = []
    var isExploreMode: Bool = true {
        didSet {
            resetPercentageCache()
            setNeedsDisplay()
        }
    }
    
    // Maximum speed for revealing fog (in meters/second)
    // 2.0 m/s = 7.2 km/h (walking/jogging speed)
    let maxWalkingSpeed: Double = 3.0
    
    // Cache for neighborhood percentages
    private var percentageCache: [String: Double] = [:]
    private var lastCalculationLocations: [String: Int] = [:]
    
    // Callback for when locations are added (for native 3D circles)
    var onLocationAdded: (() -> Void)?
    
    // Reset cache when the mode changes or on demand
    func resetPercentageCache() {
        percentageCache = [:]
        lastCalculationLocations = [:]
    }
    
    // Calculate the area of a polygon using the Shoelace formula and convert to square meters
    func calculatePolygonArea(_ coordinates: [CLLocationCoordinate2D]) -> Double {
        var area: Double = 0
        let count = coordinates.count
        
        for i in 0..<count {
            let j = (i + 1) % count
            let xi = coordinates[i].longitude
            let yi = coordinates[i].latitude
            let xj = coordinates[j].longitude
            let yj = coordinates[j].latitude
            
            area += (xi * yj) - (xj * yi)
        }
        
        area = abs(area) / 2.0
        
        // Calculate average latitude of the polygon
        let averageLatitude = coordinates.reduce(0.0) { $0 + $1.latitude } / Double(coordinates.count)
        
        // Convert from square degrees to square meters using proper geographic calculations
        // 1° of latitude is approximately constant at 111,000 meters
        let metersPerDegreeLatitude = 111000.0
        
        // 1° of longitude varies with latitude: 111,000 * cos(latitude)
        let metersPerDegreeLongitude = 111000.0 * cos(averageLatitude * .pi / 180.0)
        
        let areaInSquareMeters = area * metersPerDegreeLongitude * metersPerDegreeLatitude
        
        return areaInSquareMeters
    }
    
    // Check if a point is inside a polygon using ray casting algorithm
    func isPointInPolygon(_ point: CLLocationCoordinate2D, polygon: [CLLocationCoordinate2D]) -> Bool {
        var isInside = false
        let count = polygon.count
        
        for i in 0..<count {
            let j = (i + 1) % count
            let xi = polygon[i].latitude
            let yi = polygon[i].longitude
            let xj = polygon[j].latitude
            let yj = polygon[j].longitude
            
            let intersect = ((yi > point.longitude) != (yj > point.longitude)) &&
                           (point.latitude < (xj - xi) * (point.longitude - yi) / (yj - yi) + xi)
            if intersect {
                isInside = !isInside
            }
        }
        
        return isInside
    }
    
    // Calculate the percentage of area explored within the current neighborhood
    func calculateExploredPercentage() -> Double {
        guard let currentLocation = currentLocation else { return 0.0 }
        
        // Find the current neighborhood
        let neighborhood: Neighborhood?
        if isPointInPolygon(currentLocation, polygon: Neighborhoods.parkSlope.boundary) {
            neighborhood = Neighborhoods.parkSlope
        } else if isPointInPolygon(currentLocation, polygon: Neighborhoods.prospectPark.boundary) {
            neighborhood = Neighborhoods.prospectPark
        } else if isPointInPolygon(currentLocation, polygon: Neighborhoods.greenwoodHeights.boundary) {
            neighborhood = Neighborhoods.greenwoodHeights
        } else if isPointInPolygon(currentLocation, polygon: Neighborhoods.gowanus.boundary) {
            neighborhood = Neighborhoods.gowanus
        } else if isPointInPolygon(currentLocation, polygon: Neighborhoods.windsorTerrace.boundary) {
            neighborhood = Neighborhoods.windsorTerrace
        } else {
            neighborhood = nil
        }
        
        // If we're in a neighborhood, calculate the percentage
        if let currentNeighborhood = neighborhood {
            return calculateNeighborhoodPercentage(currentNeighborhood)
        }
        
        return 0.0 // Not in any neighborhood
    }
    
    func calculateNeighborhoodPercentage(_ neighborhood: Neighborhood) -> Double {
        // Get all visited locations (either from explore mode or test mode)
        let allLocations = isExploreMode ? visitedLocations : testLocations
        let locationCount = allLocations.count
        
        // Cache key based on neighborhood and mode
        let cacheKey = "\(neighborhood.name)_\(isExploreMode ? "explore" : "test")"
        
        // Check if we've already calculated this percentage with the same number of locations
        if let cachedCount = lastCalculationLocations[cacheKey], 
           let cachedPercentage = percentageCache[cacheKey], 
           cachedCount == locationCount {
            print("Using cached percentage for \(neighborhood.name): \(cachedPercentage)%")
            return cachedPercentage
        }
        
        print("Calculating percentage for \(neighborhood.name)")
        print("Total locations: \(locationCount)")
        
        if allLocations.isEmpty {
            print("No locations found")
            percentageCache[cacheKey] = 0.0
            lastCalculationLocations[cacheKey] = 0
            return 0.0
        }
        
        // Filter locations that are within this specific neighborhood
        let neighborhoodLocations = allLocations.filter { location in
            isPointInPolygon(location, polygon: neighborhood.boundary)
        }
        
        print("Locations in \(neighborhood.name): \(neighborhoodLocations.count)")
        
        if neighborhoodLocations.isEmpty {
            print("No locations in this neighborhood")
            percentageCache[cacheKey] = 0.0
            lastCalculationLocations[cacheKey] = locationCount
            return 0.0
        }
        
        // Create a grid to track explored points - use the same radius as the fog circles
        let gridSize = 0.0003 // Grid cell size
        
        // Convert baseRadius from meters to approximate degrees
        // 1 degree ≈ 111,000 meters at the equator
        let visibilityRadius = baseRadius / 111000.0
        
        // Find the bounds of the neighborhood
        let minLat = neighborhood.boundary.map { $0.latitude }.min() ?? 0
        let maxLat = neighborhood.boundary.map { $0.latitude }.max() ?? 0
        let minLon = neighborhood.boundary.map { $0.longitude }.min() ?? 0
        let maxLon = neighborhood.boundary.map { $0.longitude }.max() ?? 0
        
        // Create grid with spatial index for faster lookup
        var grid: [String: Bool] = [:]
        var totalPoints = 0
        var exploredPoints = 0
        
        // Spatial index to reduce point checks
        // Divide area into larger cells to quickly check which locations might affect grid points
        let indexCellSize = visibilityRadius * 2 // Make cells at least as large as the visibility diameter
        var spatialIndex: [String: [CLLocationCoordinate2D]] = [:]
        
        // Build spatial index for locations
        for location in neighborhoodLocations {
            let indexX = Int(location.longitude / indexCellSize)
            let indexY = Int(location.latitude / indexCellSize)
            let indexKey = "\(indexX),\(indexY)"
            
            if spatialIndex[indexKey] == nil {
                spatialIndex[indexKey] = []
            }
            spatialIndex[indexKey]?.append(location)
        }
        
        // For each point in the grid, check if it's explored
        var lat = minLat
        while lat <= maxLat {
            var lon = minLon
            while lon <= maxLon {
                let point = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                // Only process points inside the neighborhood
                if isPointInPolygon(point, polygon: neighborhood.boundary) {
                    totalPoints += 1
                    let key = "\(Int(lat * 100000)),\(Int(lon * 100000))"
                    
                    // Check if this grid cell is already marked as explored
                    if grid[key] != true {
                        // Get relevant locations from spatial index
                        let indexX = Int(point.longitude / indexCellSize)
                        let indexY = Int(point.latitude / indexCellSize)
                        
                        // Check the cell and adjacent cells
                        var isExplored = false
                        for dx in -1...1 {
                            for dy in -1...1 {
                                let neighborKey = "\(indexX + dx),\(indexY + dy)"
                                if let cellLocations = spatialIndex[neighborKey] {
                                    // Check if any location in this cell is within range
                                    for location in cellLocations {
                                        let distance = sqrt(pow(location.latitude - point.latitude, 2) + 
                                                        pow(location.longitude - point.longitude, 2))
                                        if distance <= visibilityRadius {
                                            isExplored = true
                                            break
                                        }
                                    }
                                }
                                if isExplored { break }
                            }
                            if isExplored { break }
                        }
                        
                        if isExplored {
                            grid[key] = true
                            exploredPoints += 1
                        }
                    }
                }
                
                lon += gridSize
            }
            lat += gridSize
        }
        
        // Calculate percentage
        let percentage = totalPoints > 0 ? (Double(exploredPoints) / Double(totalPoints)) * 100.0 : 0.0
        
        // Store in cache
        percentageCache[cacheKey] = percentage
        lastCalculationLocations[cacheKey] = locationCount
        
        print("Neighborhood: \(neighborhood.name), Total grid points: \(totalPoints), Explored: \(exploredPoints), Percentage: \(percentage)%")
        
        return percentage
    }
    
    private func calculateCoveredArea(_ locations: [CLLocationCoordinate2D], in boundary: [CLLocationCoordinate2D]) -> Double {
        // Create a grid of points within the boundary
        let gridSize = 0.0003 // Use consistent grid size
        
        // Convert baseRadius from meters to approximate degrees
        let visibilityRadius = baseRadius / 111000.0
        
        var coveredPoints = 0
        var totalPoints = 0
        
        // Find the bounds of the neighborhood
        let minLat = boundary.map { $0.latitude }.min() ?? 0
        let maxLat = boundary.map { $0.latitude }.max() ?? 0
        let minLon = boundary.map { $0.longitude }.min() ?? 0
        let maxLon = boundary.map { $0.longitude }.max() ?? 0
        
        // Check each point in the grid
        var lat = minLat
        while lat <= maxLat {
            var lon = minLon
            while lon <= maxLon {
                let point = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                // Check if point is inside the neighborhood
                if isPointInPolygon(point, polygon: boundary) {
                    totalPoints += 1
                    
                    // Check if point is covered by any visited location
                    for location in locations {
                        let distance = sqrt(pow(location.latitude - point.latitude, 2) + 
                                         pow(location.longitude - point.longitude, 2))
                        if distance <= visibilityRadius {
                            coveredPoints += 1
                            break
                        }
                    }
                }
                
                lon += gridSize
            }
            lat += gridSize
        }
        
        // Calculate the ratio of covered points to total points
        return totalPoints > 0 ? Double(coveredPoints) / Double(totalPoints) * calculatePolygonArea(boundary) : 0
    }
    
    init(mapView: MapView, isExploreMode: Bool, locationManager: LocationManager) {
        self.mapView = mapView
        self.locationManager = locationManager
        self.isExploreMode = isExploreMode
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
        loadVisitedLocations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // func setMode(isExplore: Bool) {
    //     isExploreMode = isExplore
    // }
    
    private func saveVisitedLocations() {
        let storedLocations = visitedLocations.map { StoredLocation(from: $0) }
        if let encoded = try? JSONEncoder().encode(storedLocations) {
            UserDefaults.standard.set(encoded, forKey: "visitedLocations")
        }
    }
    
    private func loadVisitedLocations() {
        if let data = UserDefaults.standard.data(forKey: "visitedLocations"),
           let storedLocations = try? JSONDecoder().decode([StoredLocation].self, from: data) {
            visitedLocations = storedLocations.map { $0.coordinate }
        }
    }
    
    func addLocation(_ location: CLLocationCoordinate2D, speed: CLLocationSpeed = -1) {
        let locations = isExploreMode ? visitedLocations : testLocations
        
        // Check if the user is walking/running
        let isWalking = !isExploreMode || (locationManager?.isWalking ?? false)
        
        // Only proceed if we're in test mode OR the user is walking/running
        if !isExploreMode || isWalking {
            let isInBackground = UIApplication.shared.applicationState == .background
            
            // Determine if we should add this point based on distance
            var shouldAddLocation = false
            if let lastLocation = locations.last {
                let distance = sqrt(pow(location.latitude - lastLocation.latitude, 2) + 
                                 pow(location.longitude - lastLocation.longitude, 2))
                
                // Use a different distance threshold for background operation
                let distanceThreshold = isInBackground ? 0.0002 : 0.0001 // Roughly double in background
                
                shouldAddLocation = distance > distanceThreshold
            } else {
                shouldAddLocation = true // Always add first location
            }
            
            if shouldAddLocation {
                print("Adding location to fog overlay (background: \(isInBackground))")
                
                if isExploreMode {
                    visitedLocations.append(location)
                    // Save immediately in background mode to ensure locations aren't lost
                    if isInBackground {
                        saveVisitedLocations()
                    } else {
                        // In foreground, use a debounced save to reduce writes
                        debouncedSaveVisitedLocations()
                    }
                } else {
                    testLocations.append(location)
                }
                
                // Force a redraw
                DispatchQueue.main.async {
                    self.setNeedsDisplay()
                    
                    // Notify for native 3D circle updates
                    self.onLocationAdded?()
                }
            }
        } else {
            // Still update current location but don't add to visited locations
            // This allows the app to keep tracking the user without revealing fog
            print("Not walking/running - not revealing fog")
        }
    }
    
    // Debounced save to reduce frequent writes in foreground
    private var saveTimer: Timer?
    private func debouncedSaveVisitedLocations() {
        // Cancel any existing timer
        saveTimer?.invalidate()
        
        // Set new timer
        saveTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.saveVisitedLocations()
        }
    }
    
    func clearVisitedLocations() {
        if isExploreMode {
            visitedLocations = []
            UserDefaults.standard.removeObject(forKey: "visitedLocations")
        } else {
            testLocations = []
        }
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
              let mapView = mapView else { return }
        
        // Draw black background
        context.setFillColor(UIColor.black.withAlphaComponent(0.26).cgColor) // Fog Opacity Value
        context.fill(rect)
        
        // Get camera state to handle pitch
        let cameraState = mapView.mapboxMap.cameraState
        let pitch = cameraState.pitch
        let zoomLevel = cameraState.zoom
        let metersPerPixel = 78271.5170 / pow(2.0, zoomLevel)
        
        // Use constant radius regardless of zoom level
        let visualRadius = baseRadius
        let radiusInPoints = visualRadius / metersPerPixel
        
        // Calculate extended bounds to include points just outside visible area
        let extendedBounds = rect.insetBy(dx: -radiusInPoints * 2, dy: -radiusInPoints * 2)
        
        // Clear circles for each visited location
        context.setBlendMode(.clear)
        context.setFillColor(UIColor.white.cgColor)
        
        // Get the current array based on mode
        let locations = isExploreMode ? visitedLocations : testLocations
        
        // Draw trail with same radius for all locations
        for location in locations {
            let point = mapView.mapboxMap.point(for: location)
            
            // Validate point is within reasonable bounds and is valid
            if point.x.isFinite && point.y.isFinite &&
               point.x >= extendedBounds.minX && point.x <= extendedBounds.maxX &&
               point.y >= extendedBounds.minY && point.y <= extendedBounds.maxY &&
               !(point.x < 0 && point.y < 0) { // Prevent top-left corner issue
                
                if pitch > 0 {
                    // When map is pitched, adjust the circle to appear as an ellipse
                    // The ellipse should be more elongated as the pitch increases
                    let pitchFactor = cos(pitch * .pi / 180.0)
                    let horizontalRadius = radiusInPoints
                    let verticalRadius = radiusInPoints * pitchFactor
                    
                    // Create an elliptical path that mimics the pitched circle on the ground
                    let ellipsePath = UIBezierPath(ovalIn: CGRect(
                        x: point.x - horizontalRadius,
                        y: point.y - verticalRadius,
                        width: horizontalRadius * 2,
                        height: verticalRadius * 2))
                    
                    // Apply rotation based on map bearing to properly orient the ellipse
                    let bearing = cameraState.bearing
                    let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(bearing * .pi / 180.0))
                    context.saveGState()
                    context.translateBy(x: point.x, y: point.y)
                    context.concatenate(rotationTransform)
                    context.translateBy(x: -point.x, y: -point.y)
                    
                    context.addPath(ellipsePath.cgPath)
                    context.fillPath()
                    context.restoreGState()
                } else {
                    // Standard circle for non-pitched view
                    let circlePath = UIBezierPath(arcCenter: point,
                                                radius: radiusInPoints,
                                                startAngle: 0,
                                                endAngle: 2 * .pi,
                                                clockwise: true)
                    context.addPath(circlePath.cgPath)
                    context.fillPath()
                }
            }
        }
        
        // Draw current location with full radius
        if let currentLocation = currentLocation {
            let point = mapView.mapboxMap.point(for: currentLocation)
            
            // Validate point is within reasonable bounds and is valid
            if point.x.isFinite && point.y.isFinite &&
               point.x >= extendedBounds.minX && point.x <= extendedBounds.maxX &&
               point.y >= extendedBounds.minY && point.y <= extendedBounds.maxY &&
               !(point.x < 0 && point.y < 0) { // Prevent top-left corner issue
                
                if pitch > 0 {
                    // When map is pitched, adjust the circle to appear as an ellipse
                    let pitchFactor = cos(pitch * .pi / 180.0)
                    let horizontalRadius = radiusInPoints
                    let verticalRadius = radiusInPoints * pitchFactor
                    
                    // Create an elliptical path that mimics the pitched circle on the ground
                    let ellipsePath = UIBezierPath(ovalIn: CGRect(
                        x: point.x - horizontalRadius,
                        y: point.y - verticalRadius,
                        width: horizontalRadius * 2,
                        height: verticalRadius * 2))
                    
                    // Apply rotation based on map bearing to properly orient the ellipse
                    let bearing = cameraState.bearing
                    let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(bearing * .pi / 180.0))
                    context.saveGState()
                    context.translateBy(x: point.x, y: point.y)
                    context.concatenate(rotationTransform)
                    context.translateBy(x: -point.x, y: -point.y)
                    
                    context.addPath(ellipsePath.cgPath)
                    context.fillPath()
                    context.restoreGState()
                } else {
                    // Standard circle for non-pitched view
                    let circlePath = UIBezierPath(arcCenter: point,
                                                radius: radiusInPoints,
                                                startAngle: 0,
                                                endAngle: 2 * .pi,
                                                clockwise: true)
                    context.addPath(circlePath.cgPath)
                    context.fillPath()
                }
            }
        }
    }
} 
