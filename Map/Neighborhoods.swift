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
    
    static let greenwoodHeights = Neighborhood(
        name: "Greenwood Heights",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.65744861238801, longitude: -73.9830853815771),
            CLLocationCoordinate2D(latitude: 40.658914393929535, longitude: -73.98518184408125),
            CLLocationCoordinate2D(latitude: 40.66036873188298, longitude: -73.98725512688027),
            CLLocationCoordinate2D(latitude: 40.66122633728625, longitude: -73.98786238836223),
            CLLocationCoordinate2D(latitude: 40.662218616516185, longitude: -73.98857505279092),
            CLLocationCoordinate2D(latitude: 40.66284311360204, longitude: -73.98912805462754),
            CLLocationCoordinate2D(latitude: 40.6633974294694, longitude: -73.98973777016094),
            CLLocationCoordinate2D(latitude: 40.66668818191641, longitude: -73.99515411305404),
            CLLocationCoordinate2D(latitude: 40.668026236564714, longitude: -73.99623731186375),
            CLLocationCoordinate2D(latitude: 40.67158026050953, longitude: -73.99843011677356),
            CLLocationCoordinate2D(latitude: 40.66971738479006, longitude: -73.9988896916896),
            CLLocationCoordinate2D(latitude: 40.66937393169118, longitude: -73.9982345520454),
            CLLocationCoordinate2D(latitude: 40.668811832667274, longitude: -73.99861914719874),
            CLLocationCoordinate2D(latitude: 40.66733053191703, longitude: -74.00001658467099),
            CLLocationCoordinate2D(latitude: 40.66743809910247, longitude: -74.00031572475609),
            CLLocationCoordinate2D(latitude: 40.66646461861296, longitude: -74.0022138220156),
            CLLocationCoordinate2D(latitude: 40.663991314788234, longitude: -73.99791857871652),
            CLLocationCoordinate2D(latitude: 40.65964096395882, longitude: -74.00246605909746),
            CLLocationCoordinate2D(latitude: 40.660940454222754, longitude: -74.00463850851956),
            CLLocationCoordinate2D(latitude: 40.660797422391425, longitude: -74.00486792708153),
            CLLocationCoordinate2D(latitude: 40.65538477450718, longitude: -74.01050862756867),
            CLLocationCoordinate2D(latitude: 40.657619446515554, longitude: -74.01422515719713),
            CLLocationCoordinate2D(latitude: 40.657538027156335, longitude: -74.01436314783241),
            CLLocationCoordinate2D(latitude: 40.64594437920192, longitude: -73.99510902620813),
            CLLocationCoordinate2D(latitude: 40.64706406259819, longitude: -73.9939152013399),
            CLLocationCoordinate2D(latitude: 40.64971887655267, longitude: -73.99823475979247),
            CLLocationCoordinate2D(latitude: 40.65027308526649, longitude: -73.99764125418243),
            CLLocationCoordinate2D(latitude: 40.652929139683664, longitude: -74.0020563863486),
            CLLocationCoordinate2D(latitude: 40.65960466814445, longitude: -73.99513931677762),
            CLLocationCoordinate2D(latitude: 40.65823253404537, longitude: -73.99294152126518),
            CLLocationCoordinate2D(latitude: 40.65880160776288, longitude: -73.99235177528173),
            CLLocationCoordinate2D(latitude: 40.65748437847864, longitude: -73.99014832534078),
            CLLocationCoordinate2D(latitude: 40.659134339555436, longitude: -73.9884067138731),
            CLLocationCoordinate2D(latitude: 40.65652876775874, longitude: -73.98402425718265),
            CLLocationCoordinate2D(latitude: 40.65744861238801, longitude: -73.9830853815771)
        ]
    )
    
    static let gowanus = Neighborhood(
        name: "Gowanus",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.6653569411105, longitude: -73.99293851638643),
            CLLocationCoordinate2D(latitude: 40.67213529070412, longitude: -73.98727704168701),
            CLLocationCoordinate2D(latitude: 40.67604203581902, longitude: -73.98398610704209),
            CLLocationCoordinate2D(latitude: 40.68059492639762, longitude: -73.98091428119814),
            CLLocationCoordinate2D(latitude: 40.683957415943155, longitude: -73.98955220385513),
            CLLocationCoordinate2D(latitude: 40.676588217736395, longitude: -73.99454917164114),
            CLLocationCoordinate2D(latitude: 40.677462396534736, longitude: -73.99647028558535),
            CLLocationCoordinate2D(latitude: 40.67248089051043, longitude: -73.99898788483294),
            CLLocationCoordinate2D(latitude: 40.668046057157255, longitude: -73.99624073849165),
            CLLocationCoordinate2D(latitude: 40.66669623243328, longitude: -73.99515903058881),
            CLLocationCoordinate2D(latitude: 40.6653569411105, longitude: -73.99293851638643)
        ]
    )
    
    static let windsorTerrace = Neighborhood(
        name: "Windsor Terrace",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.65650583262851, longitude: -73.98400525972909),
            CLLocationCoordinate2D(latitude: 40.65521013642041, longitude: -73.98184933671097),
            CLLocationCoordinate2D(latitude: 40.647229960989705, longitude: -73.98032011485746),
            CLLocationCoordinate2D(latitude: 40.64781009831785, longitude: -73.97527408612888),
            CLLocationCoordinate2D(latitude: 40.64757371469611, longitude: -73.97319980519161),
            CLLocationCoordinate2D(latitude: 40.64829308653282, longitude: -73.9713372242964),
            CLLocationCoordinate2D(latitude: 40.65814422791007, longitude: -73.97428296647155),
            CLLocationCoordinate2D(latitude: 40.65842810334337, longitude: -73.97452809635676),
            CLLocationCoordinate2D(latitude: 40.66098508215825, longitude: -73.97982867158898),
            CLLocationCoordinate2D(latitude: 40.65875270642394, longitude: -73.98177521865567),
            CLLocationCoordinate2D(latitude: 40.65650583262851, longitude: -73.98400525972909)
        ]
    )
    
    static let carrollGardens = Neighborhood(
        name: "Carroll Gardens",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.67248270254464, longitude: -73.99899006858472),
            CLLocationCoordinate2D(latitude: 40.67746248646688, longitude: -73.9964703072213),
            CLLocationCoordinate2D(latitude: 40.676590820287515, longitude: -73.99454622240718),
            CLLocationCoordinate2D(latitude: 40.68395779678448, longitude: -73.98955273232578),
            CLLocationCoordinate2D(latitude: 40.68576929170683, longitude: -73.99424262290727),
            CLLocationCoordinate2D(latitude: 40.68374274263536, longitude: -73.99523791909336),
            CLLocationCoordinate2D(latitude: 40.68528773116799, longitude: -74.00081040181551),
            CLLocationCoordinate2D(latitude: 40.67942800381712, longitude: -74.00362137007423),
            CLLocationCoordinate2D(latitude: 40.67780321289274, longitude: -74.0022597941877),
            CLLocationCoordinate2D(latitude: 40.67248270254464, longitude: -73.99899006858472)
        ]
    )
    
    static let cobbleHill = Neighborhood(
        name: "Cobble Hill",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.68528940691078, longitude: -74.00081170835507),
            CLLocationCoordinate2D(latitude: 40.683744146574384, longitude: -73.995235197227),
            CLLocationCoordinate2D(latitude: 40.68645437376472, longitude: -73.9939177881938),
            CLLocationCoordinate2D(latitude: 40.68968605812205, longitude: -73.99237678993711),
            CLLocationCoordinate2D(latitude: 40.691612033815744, longitude: -73.99923307254224),
            CLLocationCoordinate2D(latitude: 40.691033710884255, longitude: -73.99897498646958),
            CLLocationCoordinate2D(latitude: 40.69022682908593, longitude: -73.99872941349155),
            CLLocationCoordinate2D(latitude: 40.689590626933125, longitude: -73.99876011011405),
            CLLocationCoordinate2D(latitude: 40.6892355015587, longitude: -73.99892873490143),
            CLLocationCoordinate2D(latitude: 40.68528940691078, longitude: -74.00081170835507)
        ]
    )
    
    static let boeumHill = Neighborhood(
        name: "Boerum Hill",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.686449186382674, longitude: -73.99392213511814),
            CLLocationCoordinate2D(latitude: 40.685777551727455, longitude: -73.9942492171543),
            CLLocationCoordinate2D(latitude: 40.683957722093226, longitude: -73.98955247379152),
            CLLocationCoordinate2D(latitude: 40.68059711481246, longitude: -73.98091502884722),
            CLLocationCoordinate2D(latitude: 40.68483811306817, longitude: -73.97807248168806),
            CLLocationCoordinate2D(latitude: 40.68634159346894, longitude: -73.97909923863352),
            CLLocationCoordinate2D(latitude: 40.687058956284375, longitude: -73.9811360435942),
            CLLocationCoordinate2D(latitude: 40.68733593880552, longitude: -73.9818124831383),
            CLLocationCoordinate2D(latitude: 40.68816174881809, longitude: -73.9839770873669),
            CLLocationCoordinate2D(latitude: 40.68901319584663, longitude: -73.98616198709371),
            CLLocationCoordinate2D(latitude: 40.689867271977135, longitude: -73.98828136192438),
            CLLocationCoordinate2D(latitude: 40.69032852820686, longitude: -73.98962651848598),
            CLLocationCoordinate2D(latitude: 40.69099530562224, longitude: -73.99174275531227),
            CLLocationCoordinate2D(latitude: 40.6896895044506, longitude: -73.99237371522902),
            CLLocationCoordinate2D(latitude: 40.686449186382674, longitude: -73.99392213511814)
        ]
    )
    
    static let prospectHeights = Neighborhood(
        name: "Prospect Heights",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.68404841359842, longitude: -73.97748449701628),
            CLLocationCoordinate2D(latitude: 40.6732602197701, longitude: -73.96954530302868),
            CLLocationCoordinate2D(latitude: 40.67261759267598, longitude: -73.96631905044075),
            CLLocationCoordinate2D(latitude: 40.67216445446283, longitude: -73.96485257199222),
            CLLocationCoordinate2D(latitude: 40.671647994089994, longitude: -73.96260706551277),
            CLLocationCoordinate2D(latitude: 40.6811006832838, longitude: -73.96433310221126),
            CLLocationCoordinate2D(latitude: 40.68361450394815, longitude: -73.97637194810305),
            CLLocationCoordinate2D(latitude: 40.68404841359842, longitude: -73.97748449701628)
        ]
    )
    
    static let crownHeights = Neighborhood(
        name: "Crown Heights",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.6811008982142, longitude: -73.96433342303972),
            CLLocationCoordinate2D(latitude: 40.672197561763255, longitude: -73.96270835730932),
            CLLocationCoordinate2D(latitude: 40.6633020180127, longitude: -73.96095229170794),
            CLLocationCoordinate2D(latitude: 40.66423243966116, longitude: -73.9454483987711),
            CLLocationCoordinate2D(latitude: 40.663733827279884, longitude: -73.93700417243836),
            CLLocationCoordinate2D(latitude: 40.663514828123965, longitude: -73.93259386815208),
            CLLocationCoordinate2D(latitude: 40.66357360615552, longitude: -73.93156715949875),
            CLLocationCoordinate2D(latitude: 40.66366912034664, longitude: -73.93061793829071),
            CLLocationCoordinate2D(latitude: 40.66829755763854, longitude: -73.92004784604772),
            CLLocationCoordinate2D(latitude: 40.676804258990785, longitude: -73.91924198766155),
            CLLocationCoordinate2D(latitude: 40.67860579760875, longitude: -73.9523081140137),
            CLLocationCoordinate2D(latitude: 40.6811008982142, longitude: -73.96433342303972)
        ]
    )
    
    static let fortGreene = Neighborhood(
        name: "Fort Greene",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.69826989999862, longitude: -73.98053675496406),
            CLLocationCoordinate2D(latitude: 40.69455242751826, longitude: -73.98008312896656),
            CLLocationCoordinate2D(latitude: 40.693909743154535, longitude: -73.97939245533522),
            CLLocationCoordinate2D(latitude: 40.69344954560407, longitude: -73.97915176603958),
            CLLocationCoordinate2D(latitude: 40.68983295411232, longitude: -73.9786217427488),
            CLLocationCoordinate2D(latitude: 40.689925307369805, longitude: -73.98145557570577),
            CLLocationCoordinate2D(latitude: 40.684050504055506, longitude: -73.97748171593013),
            CLLocationCoordinate2D(latitude: 40.683614508856834, longitude: -73.97637146743793),
            CLLocationCoordinate2D(latitude: 40.6820058568444, longitude: -73.96866451952373),
            CLLocationCoordinate2D(latitude: 40.69790012137935, longitude: -73.97179947191577),
            CLLocationCoordinate2D(latitude: 40.69826989999862, longitude: -73.98053675496406)
        ]
    )
    
    static let columbiaWaterfront = Neighborhood(
        name: "Columbia Waterfront",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.679419880486506, longitude: -74.00362345633253),
            CLLocationCoordinate2D(latitude: 40.68959271840083, longitude: -73.99876562064696),
            CLLocationCoordinate2D(latitude: 40.69022972839568, longitude: -73.998733533248),
            CLLocationCoordinate2D(latitude: 40.69103261773631, longitude: -73.99897856429408),
            CLLocationCoordinate2D(latitude: 40.691611646787265, longitude: -73.99923229365994),
            CLLocationCoordinate2D(latitude: 40.69171787870985, longitude: -73.99961370841422),
            CLLocationCoordinate2D(latitude: 40.68972567737012, longitude: -74.00056583184559),
            CLLocationCoordinate2D(latitude: 40.68589622002091, longitude: -74.00250678525103),
            CLLocationCoordinate2D(latitude: 40.68637223378718, longitude: -74.00438446371189),
            CLLocationCoordinate2D(latitude: 40.6863422193922, longitude: -74.00456423300287),
            CLLocationCoordinate2D(latitude: 40.68502438405437, longitude: -74.00514267840076),
            CLLocationCoordinate2D(latitude: 40.68345620134966, longitude: -74.00591048951941),
            CLLocationCoordinate2D(latitude: 40.68309322683385, longitude: -74.0062519103026),
            CLLocationCoordinate2D(latitude: 40.68127884023295, longitude: -74.00526187471417),
            CLLocationCoordinate2D(latitude: 40.679419880486506, longitude: -74.00362345633253)
        ]
    )
    
    static let brooklynHeights = Neighborhood(
        name: "Brooklyn Heights",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.69171896961595, longitude: -73.99961560098426),
            CLLocationCoordinate2D(latitude: 40.68968840555695, longitude: -73.99237745718274),
            CLLocationCoordinate2D(latitude: 40.69280393019707, longitude: -73.99086230271966),
            CLLocationCoordinate2D(latitude: 40.69290708270202, longitude: -73.99077904018007),
            CLLocationCoordinate2D(latitude: 40.69369104004349, longitude: -73.99041353332076),
            CLLocationCoordinate2D(latitude: 40.69381645280697, longitude: -73.99043898060775),
            CLLocationCoordinate2D(latitude: 40.69610345953197, longitude: -73.99109869119735),
            CLLocationCoordinate2D(latitude: 40.696890322947866, longitude: -73.9913468702961),
            CLLocationCoordinate2D(latitude: 40.697985073978884, longitude: -73.99142583637312),
            CLLocationCoordinate2D(latitude: 40.698968624702246, longitude: -73.99138071388205),
            CLLocationCoordinate2D(latitude: 40.70037977982551, longitude: -73.99079410873986),
            CLLocationCoordinate2D(latitude: 40.70097034612516, longitude: -73.99041532585927),
            CLLocationCoordinate2D(latitude: 40.70125257105977, longitude: -73.99073119016657),
            CLLocationCoordinate2D(latitude: 40.70425658878358, longitude: -73.99455100568919),
            CLLocationCoordinate2D(latitude: 40.7040883339256, longitude: -73.99477898231363),
            CLLocationCoordinate2D(latitude: 40.70388290132149, longitude: -73.99457838120824),
            CLLocationCoordinate2D(latitude: 40.70358942507352, longitude: -73.99484584934876),
            CLLocationCoordinate2D(latitude: 40.70344535444838, longitude: -73.99460301644312),
            CLLocationCoordinate2D(latitude: 40.70313320033273, longitude: -73.99501477661013),
            CLLocationCoordinate2D(latitude: 40.70295711275713, longitude: -73.99512035613935),
            CLLocationCoordinate2D(latitude: 40.70335579220469, longitude: -73.99618028093995),
            CLLocationCoordinate2D(latitude: 40.70152229228074, longitude: -73.99813265057877),
            CLLocationCoordinate2D(latitude: 40.7009999671271, longitude: -73.99679788801977),
            CLLocationCoordinate2D(latitude: 40.7007006130431, longitude: -73.99696241355913),
            CLLocationCoordinate2D(latitude: 40.70046778115869, longitude: -73.99703919214437),
            CLLocationCoordinate2D(latitude: 40.7002372333983, longitude: -73.99714887854957),
            CLLocationCoordinate2D(latitude: 40.69997529564944, longitude: -73.99718178365693),
            CLLocationCoordinate2D(latitude: 40.699602397145384, longitude: -73.99736333710875),
            CLLocationCoordinate2D(latitude: 40.700325326454845, longitude: -73.99948331218448),
            CLLocationCoordinate2D(latitude: 40.69946039225184, longitude: -74.00003671933277),
            CLLocationCoordinate2D(latitude: 40.69888591482061, longitude: -73.99836798393211),
            CLLocationCoordinate2D(latitude: 40.698627721103264, longitude: -73.99799336986229),
            CLLocationCoordinate2D(latitude: 40.69803696301591, longitude: -73.99837711368161),
            CLLocationCoordinate2D(latitude: 40.69875953411275, longitude: -74.00044966790925),
            CLLocationCoordinate2D(latitude: 40.69789457957887, longitude: -74.00102010296975),
            CLLocationCoordinate2D(latitude: 40.69713934889896, longitude: -73.99883201624519),
            CLLocationCoordinate2D(latitude: 40.696820350098136, longitude: -73.99877697364879),
            CLLocationCoordinate2D(latitude: 40.696742889685964, longitude: -73.9991686156308),
            CLLocationCoordinate2D(latitude: 40.69681389506701, longitude: -73.99941552035813),
            CLLocationCoordinate2D(latitude: 40.69654278320482, longitude: -73.99961134134944),
            CLLocationCoordinate2D(latitude: 40.6964072268602, longitude: -73.99942403431453),
            CLLocationCoordinate2D(latitude: 40.69621357446076, longitude: -73.99938997849011),
            CLLocationCoordinate2D(latitude: 40.6959101845699, longitude: -73.99941552035813),
            CLLocationCoordinate2D(latitude: 40.69598119083847, longitude: -73.99960282739302),
            CLLocationCoordinate2D(latitude: 40.69496773043306, longitude: -74.00028394503207),
            CLLocationCoordinate2D(latitude: 40.69569070994382, longitude: -74.00239540613747),
            CLLocationCoordinate2D(latitude: 40.694762527558595, longitude: -74.00300325429683),
            CLLocationCoordinate2D(latitude: 40.69405729976111, longitude: -74.0009658491034),
            CLLocationCoordinate2D(latitude: 40.693302025580664, longitude: -74.0013234352604),
            CLLocationCoordinate2D(latitude: 40.69403418784077, longitude: -74.00345185571331),
            CLLocationCoordinate2D(latitude: 40.6932014488672, longitude: -74.00399674889842),
            CLLocationCoordinate2D(latitude: 40.692446164985, longitude: -74.0017064947),
            CLLocationCoordinate2D(latitude: 40.69216584318724, longitude: -74.00185214772887),
            CLLocationCoordinate2D(latitude: 40.69157393336533, longitude: -73.99969065958746),
            CLLocationCoordinate2D(latitude: 40.69171896961595, longitude: -73.99961560098426)
        ]
    )
    
    static let dumbo = Neighborhood(
        name: "DUMBO",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.70425697951438, longitude: -73.99454715618705),
            CLLocationCoordinate2D(latitude: 40.7016809151896, longitude: -73.99127341021756),
            CLLocationCoordinate2D(latitude: 40.70144168741703, longitude: -73.98475645929187),
            CLLocationCoordinate2D(latitude: 40.704391387735456, longitude: -73.98448013910047),
            CLLocationCoordinate2D(latitude: 40.70446525354734, longitude: -73.98651133643953),
            CLLocationCoordinate2D(latitude: 40.705033641198696, longitude: -73.98665491323784),
            CLLocationCoordinate2D(latitude: 40.70517116599521, longitude: -73.9869190173884),
            CLLocationCoordinate2D(latitude: 40.70507009785766, longitude: -73.98815527489828),
            CLLocationCoordinate2D(latitude: 40.70456908187006, longitude: -73.98823276051634),
            CLLocationCoordinate2D(latitude: 40.70459468779174, longitude: -73.98891506070926),
            CLLocationCoordinate2D(latitude: 40.70482514064557, longitude: -73.9894825182955),
            CLLocationCoordinate2D(latitude: 40.704886594605824, longitude: -73.98975949164118),
            CLLocationCoordinate2D(latitude: 40.704950741570144, longitude: -73.99016010048734),
            CLLocationCoordinate2D(latitude: 40.70472541032427, longitude: -73.99035600846376),
            CLLocationCoordinate2D(latitude: 40.704510320696926, longitude: -73.99042356293816),
            CLLocationCoordinate2D(latitude: 40.70429523037413, longitude: -73.99082213433817),
            CLLocationCoordinate2D(latitude: 40.703998199740056, longitude: -73.99096399873463),
            CLLocationCoordinate2D(latitude: 40.70403736257089, longitude: -73.99152118200767),
            CLLocationCoordinate2D(latitude: 40.704172382183344, longitude: -73.99186891189271),
            CLLocationCoordinate2D(latitude: 40.70443833260788, longitude: -73.99214341116907),
            CLLocationCoordinate2D(latitude: 40.70467836584004, longitude: -73.99214058409737),
            CLLocationCoordinate2D(latitude: 40.704688728158345, longitude: -73.99249539650911),
            CLLocationCoordinate2D(latitude: 40.70463300626119, longitude: -73.99255193795696),
            CLLocationCoordinate2D(latitude: 40.70463300626119, longitude: -73.99334069111092),
            CLLocationCoordinate2D(latitude: 40.70459671726019, longitude: -73.9936197391993),
            CLLocationCoordinate2D(latitude: 40.704517781961044, longitude: -73.99357346144369),
            CLLocationCoordinate2D(latitude: 40.7044292481969, longitude: -73.99373459410681),
            CLLocationCoordinate2D(latitude: 40.70454931398464, longitude: -73.99383099977756),
            CLLocationCoordinate2D(latitude: 40.70443446845283, longitude: -73.9943199142493),
            CLLocationCoordinate2D(latitude: 40.70425697951438, longitude: -73.99454715618705)
        ]
    )
    
    static let downtownBrooklyn = Neighborhood(
        name: "Downtown Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.70168154494084, longitude: -73.99126316541282),
            CLLocationCoordinate2D(latitude: 40.70096878002241, longitude: -73.99040683034484),
            CLLocationCoordinate2D(latitude: 40.70038295997378, longitude: -73.99080118517354),
            CLLocationCoordinate2D(latitude: 40.69897790512084, longitude: -73.99138527929912),
            CLLocationCoordinate2D(latitude: 40.69798846534192, longitude: -73.9914354573282),
            CLLocationCoordinate2D(latitude: 40.69689037340268, longitude: -73.99133507609865),
            CLLocationCoordinate2D(latitude: 40.693693928172365, longitude: -73.99041588800516),
            CLLocationCoordinate2D(latitude: 40.690998968693094, longitude: -73.9917388466981),
            CLLocationCoordinate2D(latitude: 40.68986941141887, longitude: -73.98828106922925),
            CLLocationCoordinate2D(latitude: 40.68765111677129, longitude: -73.98263870896356),
            CLLocationCoordinate2D(latitude: 40.68703748461303, longitude: -73.98106551553313),
            CLLocationCoordinate2D(latitude: 40.68633669922943, longitude: -73.97907637047479),
            CLLocationCoordinate2D(latitude: 40.689925525734196, longitude: -73.98145861131934),
            CLLocationCoordinate2D(latitude: 40.68983092815927, longitude: -73.97862883767664),
            CLLocationCoordinate2D(latitude: 40.69345845770644, longitude: -73.97915626697076),
            CLLocationCoordinate2D(latitude: 40.6938739864199, longitude: -73.97938813075541),
            CLLocationCoordinate2D(latitude: 40.69454157587165, longitude: -73.98009498796388),
            CLLocationCoordinate2D(latitude: 40.69616211183265, longitude: -73.98033479470416),
            CLLocationCoordinate2D(latitude: 40.69828127306616, longitude: -73.98053444579432),
            CLLocationCoordinate2D(latitude: 40.70029337950203, longitude: -73.98043206812912),
            CLLocationCoordinate2D(latitude: 40.70097470691948, longitude: -73.98050339337652),
            CLLocationCoordinate2D(latitude: 40.70128833148391, longitude: -73.98104546525849),
            CLLocationCoordinate2D(latitude: 40.70168154494084, longitude: -73.99126316541282)
        ]
    )
    
    static func getNeighborhoodName(for location: CLLocationCoordinate2D) -> String {
        if parkSlope.contains(location) {
            return parkSlope.name
        }
        if prospectPark.contains(location) {
            return prospectPark.name
        }
        if greenwoodHeights.contains(location) {
            return greenwoodHeights.name
        }
        if gowanus.contains(location) {
            return gowanus.name
        }
        if windsorTerrace.contains(location) {
            return windsorTerrace.name
        }
        if carrollGardens.contains(location) {
            return carrollGardens.name
        }
        if cobbleHill.contains(location) {
            return cobbleHill.name
        }
        if boeumHill.contains(location) {
            return boeumHill.name
        }
        if prospectHeights.contains(location) {
            return prospectHeights.name
        }
        if crownHeights.contains(location) {
            return crownHeights.name
        }
        if fortGreene.contains(location) {
            return fortGreene.name
        }
        if columbiaWaterfront.contains(location) {
            return columbiaWaterfront.name
        }
        if brooklynHeights.contains(location) {
            return brooklynHeights.name
        }
        if dumbo.contains(location) {
            return dumbo.name
        }
        if downtownBrooklyn.contains(location) {
            return downtownBrooklyn.name
        }
        return "New York"
    }
    
    // Get neighborhood object from name
    static func getNeighborhoodForName(_ name: String) -> Neighborhood? {
        switch name {
        case "Park Slope":
            return parkSlope
        case "Prospect Park":
            return prospectPark
        case "Greenwood Heights":
            return greenwoodHeights
        case "Gowanus":
            return gowanus
        case "Windsor Terrace":
            return windsorTerrace
        case "Carroll Gardens":
            return carrollGardens
        case "Cobble Hill":
            return cobbleHill
        case "Boerum Hill":
            return boeumHill
        case "Prospect Heights":
            return prospectHeights
        case "Crown Heights":
            return crownHeights
        case "Fort Greene":
            return fortGreene
        case "Columbia Waterfront":
            return columbiaWaterfront
        case "Brooklyn Heights":
            return brooklynHeights
        case "DUMBO":
            return dumbo
        case "Downtown Brooklyn":
            return downtownBrooklyn
        default:
            return nil
        }
    }
} 