import UIKit
import MapboxMaps
import CoreLocation

class FogOverlay: UIView {
    weak var mapView: MapView?
    var currentLocation: CLLocationCoordinate2D?
    let baseRadius: CLLocationDistance = 60 // Base radius in meters
    var visitedLocations: [CLLocationCoordinate2D] = []
    var testLocations: [CLLocationCoordinate2D] = []
    var isExploreMode: Bool = true {
        didSet {
            setNeedsDisplay()
        }
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
    
    // Calculate the percentage of area explored for a specific neighborhood
    private func calculateNeighborhoodPercentage(_ boundary: [CLLocationCoordinate2D], locations: [CLLocationCoordinate2D]) -> Double {
        let totalArea = calculatePolygonArea(boundary)
        
        // Create a grid to track explored points
        let gridSize = 10 // meters
        let gridWidth = Int(ceil(totalArea.squareRoot() / Double(gridSize)))
        var exploredGrid = Array(repeating: Array(repeating: false, count: gridWidth), count: gridWidth)
        
        // Get bounds of neighborhood
        let minLat = boundary.map { $0.latitude }.min() ?? 0
        let maxLat = boundary.map { $0.latitude }.max() ?? 0
        let minLon = boundary.map { $0.longitude }.min() ?? 0
        let maxLon = boundary.map { $0.longitude }.max() ?? 0
        
        var pointsInside = 0
        for location in locations {
            if isPointInPolygon(location, polygon: boundary) {
                pointsInside += 1
                
                // Convert location to grid coordinates
                let latRatio = (location.latitude - minLat) / (maxLat - minLat)
                let lonRatio = (location.longitude - minLon) / (maxLon - minLon)
                let gridX = Int(lonRatio * Double(gridWidth))
                let gridY = Int(latRatio * Double(gridWidth))
                
                // Mark points in the grid that are within the circle
                let radiusInGrid = Int(ceil(baseRadius / Double(gridSize)))
                for y in max(0, gridY - radiusInGrid)...min(gridWidth - 1, gridY + radiusInGrid) {
                    for x in max(0, gridX - radiusInGrid)...min(gridWidth - 1, gridX + radiusInGrid) {
                        let dx = Double(x - gridX) * Double(gridSize)
                        let dy = Double(y - gridY) * Double(gridSize)
                        if sqrt(dx*dx + dy*dy) <= baseRadius {
                            exploredGrid[y][x] = true
                        }
                    }
                }
            }
        }
        
        // Count explored grid points
        var exploredPoints = 0
        for y in 0..<gridWidth {
            for x in 0..<gridWidth {
                if exploredGrid[y][x] {
                    exploredPoints += 1
                }
            }
        }
        
        // Calculate percentage based on grid points
        let percentage = Double(exploredPoints) / Double(gridWidth * gridWidth) * 100
        
        print("Points inside boundary: \(pointsInside)")
        print("Explored grid points: \(exploredPoints) out of \(gridWidth * gridWidth)")
        print("Final percentage: \(percentage)%")
        return percentage
    }
    
    // Calculate the percentage of area explored within the current neighborhood
    func calculateExploredPercentage() -> Double {
        guard let currentLocation = currentLocation else { return 0.0 }
        
        let locations = isExploreMode ? visitedLocations : testLocations
        
        if isPointInPolygon(currentLocation, polygon: Neighborhoods.parkSlope.boundary) {
            return calculateNeighborhoodPercentage(Neighborhoods.parkSlope.boundary, locations: locations)
        } else if isPointInPolygon(currentLocation, polygon: Neighborhoods.prospectPark.boundary) {
            return calculateNeighborhoodPercentage(Neighborhoods.prospectPark.boundary, locations: locations)
        }
        
        return 0.0 // Not in any neighborhood
    }
    
    init(mapView: MapView, isExploreMode: Bool) {
        self.mapView = mapView
        self.isExploreMode = isExploreMode
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
        loadVisitedLocations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMode(isExplore: Bool) {
        isExploreMode = isExplore
    }
    
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
    
    func addLocation(_ location: CLLocationCoordinate2D) {
        let locations = isExploreMode ? visitedLocations : testLocations
        
        // Only add new location if it's significantly different from the last one
        if let lastLocation = locations.last {
            let distance = sqrt(pow(location.latitude - lastLocation.latitude, 2) + 
                             pow(location.longitude - lastLocation.longitude, 2))
            if distance > 0.0001 { // Arbitrary threshold, adjust as needed
                if isExploreMode {
                    visitedLocations.append(location)
                    saveVisitedLocations()
                } else {
                    testLocations.append(location)
                }
                setNeedsDisplay()
            }
        } else {
            if isExploreMode {
                visitedLocations.append(location)
                saveVisitedLocations()
            } else {
                testLocations.append(location)
            }
            setNeedsDisplay()
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
        context.setFillColor(UIColor.black.withAlphaComponent(0.7).cgColor)
        context.fill(rect)
        
        // Calculate zoom-dependent radius
        let zoomLevel = mapView.mapboxMap.cameraState.zoom
        let metersPerPixel = 78271.5170 / pow(2.0, zoomLevel)
        let radiusInPoints = baseRadius / metersPerPixel
        
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
                let circlePath = UIBezierPath(arcCenter: point,
                                            radius: radiusInPoints,
                                            startAngle: 0,
                                            endAngle: 2 * .pi,
                                            clockwise: true)
                context.addPath(circlePath.cgPath)
                context.fillPath()
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