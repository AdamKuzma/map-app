import SwiftUI
import MapboxMaps
import CoreLocation
import CoreMotion


// MARK: - LocationManager (Move to LocationManager.swift)
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let motionActivityManager = CMMotionActivityManager()
    let locationProvider = AppleLocationProvider()
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var currentSpeed: CLLocationSpeed = 0.0
    @Published var isWalking: Bool = false
    var onLocationUpdate: ((CLLocationCoordinate2D, CLLocationSpeed) -> Void)?
    
    // Background task identifier
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        // Configure for accurate tracking
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20 // Update every 30 meters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.activityType = .fitness
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Start motion activity updates
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: .main) { [weak self] activity in
                guard let activity = activity else { return }
                self?.isWalking = activity.walking || activity.running
            }
        }
        
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
        motionActivityManager.stopActivityUpdates()
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background - ensuring location tracking continues")
        startBackgroundTask()
    }
    
    @objc func appMovedToForeground() {
        print("App moved to foreground")
        endBackgroundTask()
    }
    
    private func startBackgroundTask() {
        endBackgroundTask()
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("Got location update: \(location.coordinate), in background: \(UIApplication.shared.applicationState == .background)")
        
        if UIApplication.shared.applicationState == .background {
            startBackgroundTask()
        }
        
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
            self.currentSpeed = location.speed >= 0 ? location.speed : 0.0
            self.onLocationUpdate?(location.coordinate, location.speed)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        
        if (error as NSError).domain == kCLErrorDomain &&
           (error as NSError).code == CLError.locationUnknown.rawValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                manager.requestLocation()
            }
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

