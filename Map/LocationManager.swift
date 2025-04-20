import SwiftUI
import MapboxMaps
import CoreLocation


// MARK: - LocationManager (Move to LocationManager.swift)
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    let locationProvider = AppleLocationProvider()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var currentSpeed: CLLocationSpeed = 0.0
    var onLocationUpdate: ((CLLocationCoordinate2D, CLLocationSpeed) -> Void)?
    
    // Background task identifier
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // Location update strategy
    enum UpdateStrategy {
        case highAccuracy    // Frequent updates, high battery usage
        case balanced        // Medium frequency, balanced battery usage
        case lowPower        // Infrequent updates, low battery usage
        case lightTracking   // Very infrequent updates but still tracks while walking
        case significantOnly // Only significant location changes, very low battery usage
    }
    
    private var currentStrategy: UpdateStrategy = .balanced
    
    override init() {
        super.init()
        locationManager.delegate = self
        setupBalancedMode() // Default to balanced mode
        
        // Configure for proper background updates
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false // Changed to false to prevent iOS from pausing updates
        locationManager.showsBackgroundLocationIndicator = true // Show indicator that app is using location
        locationManager.activityType = .fitness // Optimize for walking activities
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Register for app lifecycle notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appMovedToBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appMovedToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background - ensuring location tracking continues")
        
        // Start background task to extend runtime
        startBackgroundTask()
        
        // Ensure location updates are running with the appropriate strategy
        switch currentStrategy {
        case .highAccuracy, .balanced, .lowPower, .lightTracking:
            // Make sure updates are actively running
            if locationManager.location != nil {
                print("Continuing location updates in background")
                locationManager.requestLocation() // Request an immediate update
            }
        case .significantOnly:
            // Already using significant changes mode
            break
        }
    }
    
    @objc func appMovedToForeground() {
        print("App moved to foreground")
        
        // End background task if it's running
        endBackgroundTask()
        
        // Ensure location updates are running with current strategy
        resumeLocationUpdates()
    }
    
    private func startBackgroundTask() {
        // End any existing task
        endBackgroundTask()
        
        // Start a new background task
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    // Setup different location update strategies
    func setupHighAccuracyMode() {
        currentStrategy = .highAccuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5 // Update every 5 meters
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func setupBalancedMode() {
        currentStrategy = .balanced
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 20 // Update every 20 meters
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func setupLowPowerMode() {
        currentStrategy = .lowPower
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 50 // Update every 50 meters
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func setupLightTrackingMode() {
        currentStrategy = .lightTracking
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers // Very low accuracy is fine
        locationManager.distanceFilter = 100 // Only update every 100 meters
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func setupSignificantChangesOnlyMode() {
        currentStrategy = .significantOnly
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    // Switch between modes based on app needs
    func setUpdateStrategy(_ strategy: UpdateStrategy) {
        switch strategy {
        case .highAccuracy:
            setupHighAccuracyMode()
        case .balanced:
            setupBalancedMode()
        case .lowPower:
            setupLowPowerMode()
        case .lightTracking:
            setupLightTrackingMode()
        case .significantOnly:
            setupSignificantChangesOnlyMode()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Apply the current strategy
            switch currentStrategy {
            case .highAccuracy, .balanced, .lowPower, .lightTracking:
                manager.startUpdatingLocation()
            case .significantOnly:
                manager.startMonitoringSignificantLocationChanges()
            }
        default:
            manager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("Got location update: \(location.coordinate), in background: \(UIApplication.shared.applicationState == .background)")
        
        // If app is in background, extend background execution time
        if UIApplication.shared.applicationState == .background {
            startBackgroundTask()
        }
        
        // Throttle updates to main thread to reduce CPU usage
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
            self.currentSpeed = location.speed >= 0 ? location.speed : 0.0
            self.onLocationUpdate?(location.coordinate, location.speed)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        
        // If getting a location timed out, try requesting again
        if (error as NSError).domain == kCLErrorDomain &&
           (error as NSError).code == CLError.locationUnknown.rawValue {
            // Wait a bit and try again
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                manager.requestLocation()
            }
        }
    }
    
    // Added method to handle one-time location requests
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if let error = error {
            print("Deferred location updates failed: \(error.localizedDescription)")
        }
    }
    
    // Conserve battery by properly handling app lifecycle
    func pauseLocationUpdates() {
        if currentStrategy != .significantOnly {
            // Don't actually stop updates - just reduce frequency if needed
            if currentStrategy != .lightTracking && currentStrategy != .lowPower {
                // Temporarily switch to a lower-power mode when paused
                locationManager.distanceFilter = 100
            }
        }
    }
    
    func resumeLocationUpdates() {
        switch currentStrategy {
        case .highAccuracy, .balanced, .lowPower, .lightTracking:
            // Resume with the appropriate distance filter for the current mode
            locationManager.startUpdatingLocation()
            setUpdateStrategy(currentStrategy) // Reset proper distance filter
        case .significantOnly:
            // Already using significant changes, no need to restart
            break
        }
    }
}


// MARK: - StoredLocation (Move to LocationManager.swift)
struct StoredLocation: Codable {
    let latitude: Double
    let longitude: Double
    
    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

