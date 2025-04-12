import CoreLocation

struct Neighborhood {
    let name: String
    let boundary: [CLLocationCoordinate2D]
    
    func contains(_ location: CLLocationCoordinate2D) -> Bool {
        var isInside = false
        let count = boundary.count
        
        for i in 0..<count {
            let j = (i + 1) % count
            let xi = boundary[i].latitude
            let yi = boundary[i].longitude
            let xj = boundary[j].latitude
            let yj = boundary[j].longitude
            
            let intersect = ((yi > location.longitude) != (yj > location.longitude)) &&
                           (location.latitude < (xj - xi) * (location.longitude - yi) / (yj - yi) + xi)
            if intersect {
                isInside = !isInside
            }
        }
        
        return isInside
    }
}

enum Neighborhoods {
    static let parkSlope = Neighborhood(
        name: "Park Slope",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.665352137686654, longitude: -73.99293758984828),
            CLLocationCoordinate2D(latitude: 40.664681723104664, longitude: -73.99182464037524),
            CLLocationCoordinate2D(latitude: 40.66407583176554, longitude: -73.99077123075608),
            CLLocationCoordinate2D(latitude: 40.66339963630088, longitude: -73.98975284961405),
            CLLocationCoordinate2D(latitude: 40.6628537001768, longitude: -73.98912343411467),
            CLLocationCoordinate2D(latitude: 40.66221376398056, longitude: -73.98856161172151),
            CLLocationCoordinate2D(latitude: 40.660376606583014, longitude: -73.98724771100224),
            CLLocationCoordinate2D(latitude: 40.65892728357622, longitude: -73.98519059157326),
            CLLocationCoordinate2D(latitude: 40.65744911191075, longitude: -73.98308863701915),
            CLLocationCoordinate2D(latitude: 40.6588079595415, longitude: -73.98174179932336),
            CLLocationCoordinate2D(latitude: 40.66074316838301, longitude: -73.98006287505797),
            CLLocationCoordinate2D(latitude: 40.66428892982634, longitude: -73.97714826525824),
            CLLocationCoordinate2D(latitude: 40.6723311048942, longitude: -73.970417284102),
            CLLocationCoordinate2D(latitude: 40.67361174340354, longitude: -73.97043209561427),
            CLLocationCoordinate2D(latitude: 40.674431788477364, longitude: -73.970417284102),
            CLLocationCoordinate2D(latitude: 40.67882906350982, longitude: -73.97374663914721),
            CLLocationCoordinate2D(latitude: 40.68483802681391, longitude: -73.978051972181),
            CLLocationCoordinate2D(latitude: 40.6760421401315, longitude: -73.98398550331385),
            CLLocationCoordinate2D(latitude: 40.665352137686654, longitude: -73.99293758984828)
        ]
    )
    
    static let prospectPark = Neighborhood(
        name: "Prospect Park",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.66123712174945, longitude: -73.97965432625394),
            CLLocationCoordinate2D(latitude: 40.66114946238568, longitude: -73.97954094877771),
            CLLocationCoordinate2D(latitude: 40.661068418720674, longitude: -73.97949952239219),
            CLLocationCoordinate2D(latitude: 40.66093279440793, longitude: -73.9795126044088),
            CLLocationCoordinate2D(latitude: 40.66086994402315, longitude: -73.97952568642543),
            CLLocationCoordinate2D(latitude: 40.65845389544387, longitude: -73.97453892004903),
            CLLocationCoordinate2D(latitude: 40.65817790660347, longitude: -73.97428425354516),
            CLLocationCoordinate2D(latitude: 40.657764980498285, longitude: -73.974128346278),
            CLLocationCoordinate2D(latitude: 40.65178124601144, longitude: -73.97238273490059),
            CLLocationCoordinate2D(latitude: 40.64831466744039, longitude: -73.97134761692637),
            CLLocationCoordinate2D(latitude: 40.65091930049104, longitude: -73.96471828171202),
            CLLocationCoordinate2D(latitude: 40.65317549895363, longitude: -73.96626038635797),
            CLLocationCoordinate2D(latitude: 40.654875887835374, longitude: -73.96191647496745),
            CLLocationCoordinate2D(latitude: 40.662124028231176, longitude: -73.96308905954727),
            CLLocationCoordinate2D(latitude: 40.662574385444174, longitude: -73.96295365533184),
            CLLocationCoordinate2D(latitude: 40.6631037495074, longitude: -73.96241724319535),
            CLLocationCoordinate2D(latitude: 40.66328676357776, longitude: -73.96197107924107),
            CLLocationCoordinate2D(latitude: 40.66478613613603, longitude: -73.9612470134436),
            CLLocationCoordinate2D(latitude: 40.67164847489843, longitude: -73.96261022332511),
            CLLocationCoordinate2D(latitude: 40.67216519552136, longitude: -73.96485330639217),
            CLLocationCoordinate2D(latitude: 40.67261311166757, longitude: -73.96631631507319),
            CLLocationCoordinate2D(latitude: 40.672964604097416, longitude: -73.96827853510257),
            CLLocationCoordinate2D(latitude: 40.672260743605506, longitude: -73.97035460615606),
            CLLocationCoordinate2D(latitude: 40.66123712174945, longitude: -73.97965432625394)
        ]
    )
    
    static func getNeighborhoodName(for location: CLLocationCoordinate2D) -> String {
        if parkSlope.contains(location) {
            return parkSlope.name
        }
        if prospectPark.contains(location) {
            return prospectPark.name
        }
        return "New York"
    }
} 