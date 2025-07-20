import CoreLocation

struct Neighborhood {
    let name: String
    let borough: String
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
        borough: "Brooklyn",
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
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.66101474948019, longitude: -73.97987422126666),
            CLLocationCoordinate2D(latitude: 40.65845783699416, longitude: -73.9746308502394),
            CLLocationCoordinate2D(latitude: 40.658073747843275, longitude: -73.9742676299612),
            CLLocationCoordinate2D(latitude: 40.65108573746676, longitude: -73.97223859761547),
            CLLocationCoordinate2D(latitude: 40.65118525128025, longitude: -73.9713860232871),
            CLLocationCoordinate2D(latitude: 40.65489167371652, longitude: -73.96190728533031),
            CLLocationCoordinate2D(latitude: 40.66219661551085, longitude: -73.9630784063572),
            CLLocationCoordinate2D(latitude: 40.66258264597397, longitude: -73.96293458748241),
            CLLocationCoordinate2D(latitude: 40.663182091210786, longitude: -73.96227573531961),
            CLLocationCoordinate2D(latitude: 40.66326229153492, longitude: -73.96187669394877),
            CLLocationCoordinate2D(latitude: 40.66475318359545, longitude: -73.96124280867177),
            CLLocationCoordinate2D(latitude: 40.67163808736515, longitude: -73.96255859188285),
            CLLocationCoordinate2D(latitude: 40.67204521153499, longitude: -73.96430625132012),
            CLLocationCoordinate2D(latitude: 40.67241446153915, longitude: -73.96549216308104),
            CLLocationCoordinate2D(latitude: 40.672906791698125, longitude: -73.96776412034986),
            CLLocationCoordinate2D(latitude: 40.67296257643875, longitude: -73.96882553620108),
            CLLocationCoordinate2D(latitude: 40.673411018452384, longitude: -73.96993128674912),
            CLLocationCoordinate2D(latitude: 40.67127361191169, longitude: -73.97129811728759),
            CLLocationCoordinate2D(latitude: 40.66101474948019, longitude: -73.97987422126666)
        ]
    )
    
    static let gowanus = Neighborhood(
        name: "Gowanus",
        borough: "Brooklyn",
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
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.65923606861469, longitude: -73.98842735437232),
            CLLocationCoordinate2D(latitude: 40.65527704975918, longitude: -73.9818227682947),
            CLLocationCoordinate2D(latitude: 40.647729958103696, longitude: -73.98039305533077),
            CLLocationCoordinate2D(latitude: 40.6497843166575, longitude: -73.97550835903007),
            CLLocationCoordinate2D(latitude: 40.65110043300396, longitude: -73.97225502965743),
            CLLocationCoordinate2D(latitude: 40.658092448408894, longitude: -73.97428342832738),
            CLLocationCoordinate2D(latitude: 40.6584738115678, longitude: -73.97465657661571),
            CLLocationCoordinate2D(latitude: 40.661019368865624, longitude: -73.97987495861881),
            CLLocationCoordinate2D(latitude: 40.65742408334032, longitude: -73.9831158569434),
            CLLocationCoordinate2D(latitude: 40.65966265337357, longitude: -73.9866063759512),
            CLLocationCoordinate2D(latitude: 40.66045109410386, longitude: -73.98723507066802),
            CLLocationCoordinate2D(latitude: 40.65923606861469, longitude: -73.98842735437232)
        ]
    )
    
    static let carrollGardens = Neighborhood(
        name: "Carroll Gardens",
        borough: "Brooklyn",
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
        borough: "Brooklyn",
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
    
    static let boerumHill = Neighborhood(
        name: "Boerum Hill",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.691007857720365, longitude: -73.99173603224808),
            CLLocationCoordinate2D(latitude: 40.689701511010696, longitude: -73.99236761757282),
            CLLocationCoordinate2D(latitude: 40.689166286313025, longitude: -73.99257194665911),
            CLLocationCoordinate2D(latitude: 40.68857471717183, longitude: -73.9911044923133),
            CLLocationCoordinate2D(latitude: 40.68797799133182, longitude: -73.99148839675252),
            CLLocationCoordinate2D(latitude: 40.68737232634729, longitude: -73.99003332598726),
            CLLocationCoordinate2D(latitude: 40.68546887346059, longitude: -73.99131811355711),
            CLLocationCoordinate2D(latitude: 40.68461767853367, longitude: -73.98913993393649),
            CLLocationCoordinate2D(latitude: 40.68524594250667, longitude: -73.9887256789164),
            CLLocationCoordinate2D(latitude: 40.68187886074486, longitude: -73.98007613565636),
            CLLocationCoordinate2D(latitude: 40.68487114958654, longitude: -73.97808235854554),
            CLLocationCoordinate2D(latitude: 40.68737402746743, longitude: -73.97985964621131),
            CLLocationCoordinate2D(latitude: 40.68916185551083, longitude: -73.98455283071995),
            CLLocationCoordinate2D(latitude: 40.68963549721835, longitude: -73.98573657896907),
            CLLocationCoordinate2D(latitude: 40.689011354617264, longitude: -73.98616126814109),
            CLLocationCoordinate2D(latitude: 40.69030991974546, longitude: -73.9895864226549),
            CLLocationCoordinate2D(latitude: 40.691007857720365, longitude: -73.99173603224808)
        ]
    )
    
    static let prospectHeights = Neighborhood(
        name: "Prospect Heights",
        borough: "Brooklyn",
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
        borough: "Brooklyn",
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
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.687374081234026, longitude: -73.97984321093655),
            CLLocationCoordinate2D(latitude: 40.684054020462696, longitude: -73.97743427228468),
            CLLocationCoordinate2D(latitude: 40.6835952612841, longitude: -73.97620654093615),
            CLLocationCoordinate2D(latitude: 40.68180312250763, longitude: -73.96759120891595),
            CLLocationCoordinate2D(latitude: 40.697855660300945, longitude: -73.97077515069084),
            CLLocationCoordinate2D(latitude: 40.69830694372601, longitude: -73.98054130717715),
            CLLocationCoordinate2D(latitude: 40.69661796297541, longitude: -73.98040081988205),
            CLLocationCoordinate2D(latitude: 40.69607017623875, longitude: -73.98236764201583),
            CLLocationCoordinate2D(latitude: 40.6922133398013, longitude: -73.98255260877406),
            CLLocationCoordinate2D(latitude: 40.687374081234026, longitude: -73.97984321093655)
        ]
    )
    
    static let columbiaWaterfront = Neighborhood(
        name: "Columbia Waterfront",
        borough: "Brooklyn",
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
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.69164897676177, longitude: -73.99956902094064),
            CLLocationCoordinate2D(latitude: 40.689696530770476, longitude: -73.99236558033483),
            CLLocationCoordinate2D(latitude: 40.6925281678522, longitude: -73.99099452636781),
            CLLocationCoordinate2D(latitude: 40.69381199873976, longitude: -73.99043011484044),
            CLLocationCoordinate2D(latitude: 40.69704158980991, longitude: -73.99138432542118),
            CLLocationCoordinate2D(latitude: 40.69855026514912, longitude: -73.99142623723067),
            CLLocationCoordinate2D(latitude: 40.69918643906428, longitude: -73.991333002053),
            CLLocationCoordinate2D(latitude: 40.700176030856284, longitude: -73.99081088505632),
            CLLocationCoordinate2D(latitude: 40.70064254760251, longitude: -73.99086682616331),
            CLLocationCoordinate2D(latitude: 40.70232773784167, longitude: -73.99301375459909),
            CLLocationCoordinate2D(latitude: 40.70298013912611, longitude: -73.99474592584883),
            CLLocationCoordinate2D(latitude: 40.7029586314988, longitude: -73.99511474125275),
            CLLocationCoordinate2D(latitude: 40.70338161356392, longitude: -73.99622118746521),
            CLLocationCoordinate2D(latitude: 40.701510435272326, longitude: -73.99814091892767),
            CLLocationCoordinate2D(latitude: 40.70100857774864, longitude: -73.9968358798055),
            CLLocationCoordinate2D(latitude: 40.699638445418714, longitude: -73.99740354279652),
            CLLocationCoordinate2D(latitude: 40.700353780951076, longitude: -73.9994855000899),
            CLLocationCoordinate2D(latitude: 40.69945183497728, longitude: -74.00007008908787),
            CLLocationCoordinate2D(latitude: 40.69889200024272, longitude: -73.9984804172627),
            CLLocationCoordinate2D(latitude: 40.69865873438158, longitude: -73.99802915558296),
            CLLocationCoordinate2D(latitude: 40.69807556615481, longitude: -73.99836760184274),
            CLLocationCoordinate2D(latitude: 40.698790918469655, longitude: -74.00044955913616),
            CLLocationCoordinate2D(latitude: 40.697898309899244, longitude: -74.00103366963576),
            CLLocationCoordinate2D(latitude: 40.697120742252764, longitude: -73.99880812908017),
            CLLocationCoordinate2D(latitude: 40.69499793637033, longitude: -74.00033626522233),
            CLLocationCoordinate2D(latitude: 40.69575220115246, longitude: -74.00242847846265),
            CLLocationCoordinate2D(latitude: 40.69479056415125, longitude: -74.00302733896955),
            CLLocationCoordinate2D(latitude: 40.69403628848215, longitude: -74.00094538167615),
            CLLocationCoordinate2D(latitude: 40.69333643744065, longitude: -74.0013043398298),
            CLLocationCoordinate2D(latitude: 40.694082944957046, longitude: -74.0034580887539),
            CLLocationCoordinate2D(latitude: 40.69318091398861, longitude: -74.00397088611744),
            CLLocationCoordinate2D(latitude: 40.69164897676177, longitude: -73.99956902094064)
        ]
    )
    
    static let dumbo = Neighborhood(
        name: "Dumbo",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.702333792404545, longitude: -73.99299455466902),
            CLLocationCoordinate2D(latitude: 40.70066172000375, longitude: -73.99086996113037),
            CLLocationCoordinate2D(latitude: 40.700633157191874, longitude: -73.98689142835721),
            CLLocationCoordinate2D(latitude: 40.7015472854238, longitude: -73.98676440141621),
            CLLocationCoordinate2D(latitude: 40.701463961319405, longitude: -73.98474606763952),
            CLLocationCoordinate2D(latitude: 40.70438781754086, longitude: -73.98457620786665),
            CLLocationCoordinate2D(latitude: 40.70448629144215, longitude: -73.98666048370998),
            CLLocationCoordinate2D(latitude: 40.705029723893546, longitude: -73.98663240919947),
            CLLocationCoordinate2D(latitude: 40.7051473821289, longitude: -73.98676310924034),
            CLLocationCoordinate2D(latitude: 40.705165959725775, longitude: -73.98708985934284),
            CLLocationCoordinate2D(latitude: 40.70508545676768, longitude: -73.98815996592792),
            CLLocationCoordinate2D(latitude: 40.70461482214296, longitude: -73.98823348470096),
            CLLocationCoordinate2D(latitude: 40.70455289628663, longitude: -73.98932809754353),
            CLLocationCoordinate2D(latitude: 40.704837754748326, longitude: -73.98952414760517),
            CLLocationCoordinate2D(latitude: 40.70496779842338, longitude: -73.99019398531533),
            CLLocationCoordinate2D(latitude: 40.704484777778276, longitude: -73.9904390478919),
            CLLocationCoordinate2D(latitude: 40.7040307519226, longitude: -73.9909247077066),
            CLLocationCoordinate2D(latitude: 40.70404549037656, longitude: -73.99156628064158),
            CLLocationCoordinate2D(latitude: 40.70415357227341, longitude: -73.9918579047029),
            CLLocationCoordinate2D(latitude: 40.70441395066794, longitude: -73.99208472341705),
            CLLocationCoordinate2D(latitude: 40.70463993863805, longitude: -73.9921171260904),
            CLLocationCoordinate2D(latitude: 40.70462404085154, longitude: -73.99345063383208),
            CLLocationCoordinate2D(latitude: 40.70454052362709, longitude: -73.99385890751796),
            CLLocationCoordinate2D(latitude: 40.704452093511094, longitude: -73.9942801422733),
            CLLocationCoordinate2D(latitude: 40.70420154089234, longitude: -73.99466897437398),
            CLLocationCoordinate2D(latitude: 40.703661130044026, longitude: -73.99499948164365),
            CLLocationCoordinate2D(latitude: 40.70349409307616, longitude: -73.99468841597836),
            CLLocationCoordinate2D(latitude: 40.70331722994797, longitude: -73.9948180266719),
            CLLocationCoordinate2D(latitude: 40.7035589614828, longitude: -73.99527817551227),
            CLLocationCoordinate2D(latitude: 40.70312171621339, longitude: -73.9955373972041),
            CLLocationCoordinate2D(latitude: 40.702964503688236, longitude: -73.99511616244878),
            CLLocationCoordinate2D(latitude: 40.70297924237815, longitude: -73.99474029143629),
            CLLocationCoordinate2D(latitude: 40.702333792404545, longitude: -73.99299455466902)
        ]
    )
    
    static let downtownBrooklyn = Neighborhood(
        name: "Downtown Brooklyn",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.7006586486024, longitude: -73.99086692221015),
            CLLocationCoordinate2D(latitude: 40.70017032348747, longitude: -73.99080978268886),
            CLLocationCoordinate2D(latitude: 40.69919760069487, longitude: -73.99132923288167),
            CLLocationCoordinate2D(latitude: 40.69854988896907, longitude: -73.99142800890668),
            CLLocationCoordinate2D(latitude: 40.69702634327348, longitude: -73.99135677064207),
            CLLocationCoordinate2D(latitude: 40.69379270537837, longitude: -73.99039580427964),
            CLLocationCoordinate2D(latitude: 40.69101595345714, longitude: -73.99171668486028),
            CLLocationCoordinate2D(latitude: 40.69032811375965, longitude: -73.98959988030458),
            CLLocationCoordinate2D(latitude: 40.689009985792836, longitude: -73.986144720269),
            CLLocationCoordinate2D(latitude: 40.68966495947032, longitude: -73.98573442001464),
            CLLocationCoordinate2D(latitude: 40.687380711853535, longitude: -73.97984985095002),
            CLLocationCoordinate2D(latitude: 40.69222117749686, longitude: -73.9825815825889),
            CLLocationCoordinate2D(latitude: 40.69608549607307, longitude: -73.98235390924125),
            CLLocationCoordinate2D(latitude: 40.69661760774454, longitude: -73.98038878653367),
            CLLocationCoordinate2D(latitude: 40.69827940113788, longitude: -73.98053994978507),
            CLLocationCoordinate2D(latitude: 40.69851980955664, longitude: -73.98575006141226),
            CLLocationCoordinate2D(latitude: 40.70063065930091, longitude: -73.98689137984618),
            CLLocationCoordinate2D(latitude: 40.7006586486024, longitude: -73.99086692221015)
        ]
    )
    
    static let vinegarHill = Neighborhood(
        name: "Vinegar Hill",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.69851408855928, longitude: -73.98574230173044),
            CLLocationCoordinate2D(latitude: 40.69828022584667, longitude: -73.98053866814531),
            CLLocationCoordinate2D(latitude: 40.700430486309756, longitude: -73.98019202469122),
            CLLocationCoordinate2D(latitude: 40.7011981291179, longitude: -73.98060094085662),
            CLLocationCoordinate2D(latitude: 40.70520435259411, longitude: -73.97911198371146),
            CLLocationCoordinate2D(latitude: 40.70535805329277, longitude: -73.98243534551096),
            CLLocationCoordinate2D(latitude: 40.70429550643263, longitude: -73.98262046646045),
            CLLocationCoordinate2D(latitude: 40.70438229324111, longitude: -73.98457962381647),
            CLLocationCoordinate2D(latitude: 40.701458364808474, longitude: -73.98475080037802),
            CLLocationCoordinate2D(latitude: 40.70154891775195, longitude: -73.98675935928043),
            CLLocationCoordinate2D(latitude: 40.70063406498164, longitude: -73.98688543614426),
            CLLocationCoordinate2D(latitude: 40.69851408855928, longitude: -73.98574230173044)
        ]
    )
    
    static let clintonHill = Neighborhood(
        name: "Clinton Hill",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.69787167082063, longitude: -73.97073321745923),
            CLLocationCoordinate2D(latitude: 40.68181469931625, longitude: -73.96759954610245),
            CLLocationCoordinate2D(latitude: 40.67982773651545, longitude: -73.95815498425573),
            CLLocationCoordinate2D(latitude: 40.698171948143994, longitude: -73.96189798218299),
            CLLocationCoordinate2D(latitude: 40.697617588950806, longitude: -73.96534067730784),
            CLLocationCoordinate2D(latitude: 40.69787167082063, longitude: -73.97073321745923)
        ]
    )
    
    static let greenwoodCemetery = Neighborhood(
        name: "Greenwood Cemetery",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.652973152598435, longitude: -74.00213169799322),
            CLLocationCoordinate2D(latitude: 40.650314148022346, longitude: -73.99775860944499),
            CLLocationCoordinate2D(latitude: 40.64975709200709, longitude: -73.99830285772236),
            CLLocationCoordinate2D(latitude: 40.64413620413143, longitude: -73.98907388146303),
            CLLocationCoordinate2D(latitude: 40.644587265118844, longitude: -73.98828486351869),
            CLLocationCoordinate2D(latitude: 40.64773223193208, longitude: -73.98041189107794),
            CLLocationCoordinate2D(latitude: 40.655278236970986, longitude: -73.98183348471188),
            CLLocationCoordinate2D(latitude: 40.659234794388624, longitude: -73.98843245938548),
            CLLocationCoordinate2D(latitude: 40.65755176716016, longitude: -73.99011069298132),
            CLLocationCoordinate2D(latitude: 40.6588936104915, longitude: -73.99232982630214),
            CLLocationCoordinate2D(latitude: 40.65834821685988, longitude: -73.99289965500724),
            CLLocationCoordinate2D(latitude: 40.65965529405727, longitude: -73.99519323584691),
            CLLocationCoordinate2D(latitude: 40.652973152598435, longitude: -74.00213169799322)
        ]
    )
    
    static let sunsetPark = Neighborhood(
        name: "Sunset Park",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.66708246958103, longitude: -73.99593636982465),
            CLLocationCoordinate2D(latitude: 40.66556368273274, longitude: -73.99624180688107),
            CLLocationCoordinate2D(latitude: 40.65970925990362, longitude: -74.00223506348127),
            CLLocationCoordinate2D(latitude: 40.66108530377795, longitude: -74.00462486787607),
            CLLocationCoordinate2D(latitude: 40.655382122996656, longitude: -74.01041605223453),
            CLLocationCoordinate2D(latitude: 40.65686551584935, longitude: -74.01305748795335),
            CLLocationCoordinate2D(latitude: 40.64591560926124, longitude: -74.02393278460212),
            CLLocationCoordinate2D(latitude: 40.644508699342, longitude: -74.02176560417749),
            CLLocationCoordinate2D(latitude: 40.640295063608505, longitude: -74.02619390692567),
            CLLocationCoordinate2D(latitude: 40.632641121124635, longitude: -74.01249141185843),
            CLLocationCoordinate2D(latitude: 40.648409060927634, longitude: -73.99612453185831),
            CLLocationCoordinate2D(latitude: 40.64975514803274, longitude: -73.9983140950397),
            CLLocationCoordinate2D(latitude: 40.65030940158621, longitude: -73.99775739495598),
            CLLocationCoordinate2D(latitude: 40.652965941635074, longitude: -74.00215640332027),
            CLLocationCoordinate2D(latitude: 40.6596558647137, longitude: -73.99519327497423),
            CLLocationCoordinate2D(latitude: 40.6583485561149, longitude: -73.992902278775),
            CLLocationCoordinate2D(latitude: 40.65890224288441, longitude: -73.99233459830087),
            CLLocationCoordinate2D(latitude: 40.65754877822374, longitude: -73.99012469931324),
            CLLocationCoordinate2D(latitude: 40.66044024279026, longitude: -73.98722547691138),
            CLLocationCoordinate2D(latitude: 40.663100889869725, longitude: -73.98937455299156),
            CLLocationCoordinate2D(latitude: 40.66542235265692, longitude: -73.99288885920934),
            CLLocationCoordinate2D(latitude: 40.66708246958103, longitude: -73.99593636982465)
        ]
    )
    
    static let redHook = Neighborhood(
        name: "Red Hook",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.68327582595961, longitude: -74.00609139695918),
            CLLocationCoordinate2D(latitude: 40.68404054252869, longitude: -74.00717190068217),
            CLLocationCoordinate2D(latitude: 40.67936885513731, longitude: -74.01287401020292),
            CLLocationCoordinate2D(latitude: 40.68132645707732, longitude: -74.01590928347713),
            CLLocationCoordinate2D(latitude: 40.67959439839754, longitude: -74.01897369630176),
            CLLocationCoordinate2D(latitude: 40.67877548494255, longitude: -74.01806037823394),
            CLLocationCoordinate2D(latitude: 40.67664333750986, longitude: -74.01780364160646),
            CLLocationCoordinate2D(latitude: 40.675994361959994, longitude: -74.01783533465945),
            CLLocationCoordinate2D(latitude: 40.675537671674874, longitude: -74.01812057213495),
            CLLocationCoordinate2D(latitude: 40.675191287635926, longitude: -74.01768434016786),
            CLLocationCoordinate2D(latitude: 40.674964545621464, longitude: -74.01801780348927),
            CLLocationCoordinate2D(latitude: 40.67439768721067, longitude: -74.01814428957678),
            CLLocationCoordinate2D(latitude: 40.673499424782506, longitude: -74.0172128920241),
            CLLocationCoordinate2D(latitude: 40.673159302840645, longitude: -74.0166839502044),
            CLLocationCoordinate2D(latitude: 40.674624431153006, longitude: -74.01491314498026),
            CLLocationCoordinate2D(latitude: 40.6744238500124, longitude: -74.01459118039449),
            CLLocationCoordinate2D(latitude: 40.67298488065882, longitude: -74.0162354995303),
            CLLocationCoordinate2D(latitude: 40.672182532745694, longitude: -74.01507412727398),
            CLLocationCoordinate2D(latitude: 40.6736040772883, longitude: -74.01337231427965),
            CLLocationCoordinate2D(latitude: 40.673315390692665, longitude: -74.01290766222581),
            CLLocationCoordinate2D(latitude: 40.672129313635, longitude: -74.0141955205705),
            CLLocationCoordinate2D(latitude: 40.67185908948707, longitude: -74.01381588908903),
            CLLocationCoordinate2D(latitude: 40.671588729639325, longitude: -74.01372389920773),
            CLLocationCoordinate2D(latitude: 40.671091613508764, longitude: -74.01293048647739),
            CLLocationCoordinate2D(latitude: 40.67120499119818, longitude: -74.0127120105086),
            CLLocationCoordinate2D(latitude: 40.670943350086134, longitude: -74.01179211169072),
            CLLocationCoordinate2D(latitude: 40.6703502930977, longitude: -74.01141265342824),
            CLLocationCoordinate2D(latitude: 40.669830030356565, longitude: -74.01137031915194),
            CLLocationCoordinate2D(latitude: 40.66977611151847, longitude: -74.01082530953269),
            CLLocationCoordinate2D(latitude: 40.66925489383755, longitude: -74.01076606935685),
            CLLocationCoordinate2D(latitude: 40.66922793419178, longitude: -74.01028029991349),
            CLLocationCoordinate2D(latitude: 40.66866251159979, longitude: -74.01030305585084),
            CLLocationCoordinate2D(latitude: 40.668560836841806, longitude: -74.00966937131426),
            CLLocationCoordinate2D(latitude: 40.66862553889845, longitude: -74.00664718410412),
            CLLocationCoordinate2D(latitude: 40.670982502506064, longitude: -74.00542855999514),
            CLLocationCoordinate2D(latitude: 40.67058505958042, longitude: -74.0039418385824),
            CLLocationCoordinate2D(latitude: 40.669180126065925, longitude: -74.00461208184196),
            CLLocationCoordinate2D(latitude: 40.66836998410659, longitude: -74.00140632934875),
            CLLocationCoordinate2D(latitude: 40.66902891260992, longitude: -74.00112015725881),
            CLLocationCoordinate2D(latitude: 40.66875758989718, longitude: -74.00020031839715),
            CLLocationCoordinate2D(latitude: 40.67191261722553, longitude: -73.9986876944912),
            CLLocationCoordinate2D(latitude: 40.67902250758934, longitude: -74.00336161186642),
            CLLocationCoordinate2D(latitude: 40.68327582595961, longitude: -74.00609139695918)
        ]
    )
    
    static let prospectLeffertsGardens = Neighborhood(
        name: "Prospect Lefferts Gardens",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.66325818194639, longitude: -73.96182399078316),
            CLLocationCoordinate2D(latitude: 40.66318900312467, longitude: -73.96227998295055),
            CLLocationCoordinate2D(latitude: 40.66260592163235, longitude: -73.96290534363749),
            CLLocationCoordinate2D(latitude: 40.66215131218755, longitude: -73.96307471215655),
            CLLocationCoordinate2D(latitude: 40.65405535620104, longitude: -73.96179048876547),
            CLLocationCoordinate2D(latitude: 40.65486666730325, longitude: -73.95966787024206),
            CLLocationCoordinate2D(latitude: 40.65606463965398, longitude: -73.9395449987786),
            CLLocationCoordinate2D(latitude: 40.65735204350244, longitude: -73.93968047557297),
            CLLocationCoordinate2D(latitude: 40.65828692754138, longitude: -73.93956051155017),
            CLLocationCoordinate2D(latitude: 40.66303669288513, longitude: -73.94003885004264),
            CLLocationCoordinate2D(latitude: 40.66392409219662, longitude: -73.93991698932138),
            CLLocationCoordinate2D(latitude: 40.664268795354644, longitude: -73.9455057961237),
            CLLocationCoordinate2D(latitude: 40.66325818194639, longitude: -73.96182399078316)
        ]
    )
    
    static let flatbush = Neighborhood(
        name: "Flatbush",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.65109994121477, longitude: -73.97225545558602),
            CLLocationCoordinate2D(latitude: 40.631944949411974, longitude: -73.9666880406854),
            CLLocationCoordinate2D(latitude: 40.62864322285904, longitude: -73.96591191088665),
            CLLocationCoordinate2D(latitude: 40.630741193027916, longitude: -73.94545758061889),
            CLLocationCoordinate2D(latitude: 40.636005083921134, longitude: -73.95101237147722),
            CLLocationCoordinate2D(latitude: 40.655279664678375, longitude: -73.95296410478105),
            CLLocationCoordinate2D(latitude: 40.654866173960784, longitude: -73.95964093449665),
            CLLocationCoordinate2D(latitude: 40.65406649271631, longitude: -73.96179629480254),
            CLLocationCoordinate2D(latitude: 40.654878109429205, longitude: -73.96192215525828),
            CLLocationCoordinate2D(latitude: 40.65117027580686, longitude: -73.97136019840052),
            CLLocationCoordinate2D(latitude: 40.65109994121477, longitude: -73.97225545558602)
        ]
    )
    
    static let kensington = Neighborhood(
        name: "Kensington",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.644137747277426, longitude: -73.98907395078791),
            CLLocationCoordinate2D(latitude: 40.638492825752394, longitude: -73.97969356985809),
            CLLocationCoordinate2D(latitude: 40.6378441478125, longitude: -73.97956464534765),
            CLLocationCoordinate2D(latitude: 40.63794198838252, longitude: -73.97850843672286),
            CLLocationCoordinate2D(latitude: 40.6276019614603, longitude: -73.97656276208038),
            CLLocationCoordinate2D(latitude: 40.63229705145113, longitude: -73.96679181604328),
            CLLocationCoordinate2D(latitude: 40.65105747982204, longitude: -73.97228195503547),
            CLLocationCoordinate2D(latitude: 40.64458536143019, longitude: -73.9882628675629),
            CLLocationCoordinate2D(latitude: 40.644137747277426, longitude: -73.98907395078791)
        ]
    )
    
    static let boroughPark = Neighborhood(
        name: "Borough Park",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.632613438243624, longitude: -74.01249313708263),
            CLLocationCoordinate2D(latitude: 40.60882530528667, longitude: -73.97299408057377),
            CLLocationCoordinate2D(latitude: 40.62761668385045, longitude: -73.97654744354446),
            CLLocationCoordinate2D(latitude: 40.637934164402964, longitude: -73.97852101141292),
            CLLocationCoordinate2D(latitude: 40.63786554697546, longitude: -73.97963624106141),
            CLLocationCoordinate2D(latitude: 40.63852884556425, longitude: -73.97972666552425),
            CLLocationCoordinate2D(latitude: 40.64838478686815, longitude: -73.99609056131112),
            CLLocationCoordinate2D(latitude: 40.632613438243624, longitude: -74.01249313708263)
        ]
    )
    
    static let bedfordStuyvensant = Neighborhood(
        name: "Bedford Stuyvensant",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.698175485621675, longitude: -73.96183016886765),
            CLLocationCoordinate2D(latitude: 40.67985254489648, longitude: -73.95814525719429),
            CLLocationCoordinate2D(latitude: 40.67870277208013, longitude: -73.9529698472414),
            CLLocationCoordinate2D(latitude: 40.67625079599699, longitude: -73.90807647213178),
            CLLocationCoordinate2D(latitude: 40.678110344108774, longitude: -73.90785170950033),
            CLLocationCoordinate2D(latitude: 40.68004731840489, longitude: -73.90546105293976),
            CLLocationCoordinate2D(latitude: 40.70069982531922, longitude: -73.94186330452594),
            CLLocationCoordinate2D(latitude: 40.69900021139307, longitude: -73.95686527935825),
            CLLocationCoordinate2D(latitude: 40.698175485621675, longitude: -73.96183016886765)
        ]
    )
    
    static let dykerHeights = Neighborhood(
        name: "Dyker Heights",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.60389447748557, longitude: -74.01945326649053),
            CLLocationCoordinate2D(latitude: 40.604800888526626, longitude: -74.01777863513847),
            CLLocationCoordinate2D(latitude: 40.60690430702056, longitude: -74.01555155198196),
            CLLocationCoordinate2D(latitude: 40.60768787540596, longitude: -74.01696383510512),
            CLLocationCoordinate2D(latitude: 40.61278067375869, longitude: -74.01172219167779),
            CLLocationCoordinate2D(latitude: 40.62466747660014, longitude: -73.99930743263948),
            CLLocationCoordinate2D(latitude: 40.63393083947199, longitude: -74.01480230212492),
            CLLocationCoordinate2D(latitude: 40.60971733272325, longitude: -74.02479649668884),
            CLLocationCoordinate2D(latitude: 40.60801056841757, longitude: -74.02180718560523),
            CLLocationCoordinate2D(latitude: 40.60670065746663, longitude: -74.02254170671081),
            CLLocationCoordinate2D(latitude: 40.60568192626343, longitude: -74.02072146518879),
            CLLocationCoordinate2D(latitude: 40.604455894880715, longitude: -74.0212952190078),
            CLLocationCoordinate2D(latitude: 40.60389447748557, longitude: -74.01945326649053)
        ]
    )
    
    static let bensonhurst = Neighborhood(
        name: "Bensonhurst",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.61275872978496, longitude: -74.01174530257865),
            CLLocationCoordinate2D(latitude: 40.60191546619649, longitude: -73.99381111381567),
            CLLocationCoordinate2D(latitude: 40.60646256415811, longitude: -73.98911046726533),
            CLLocationCoordinate2D(latitude: 40.60714341423946, longitude: -73.98838383951791),
            CLLocationCoordinate2D(latitude: 40.6088257118727, longitude: -73.97299508564144),
            CLLocationCoordinate2D(latitude: 40.62467042601483, longitude: -73.99930284975129),
            CLLocationCoordinate2D(latitude: 40.61275872978496, longitude: -74.01174530257865)
        ]
    )
    
    static let bathBeach = Neighborhood(
        name: "Bath Beach",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.60311991455927, longitude: -74.01996440825371),
            CLLocationCoordinate2D(latitude: 40.603284490060304, longitude: -74.01771791555633),
            CLLocationCoordinate2D(latitude: 40.601823540609274, longitude: -74.0123872813105),
            CLLocationCoordinate2D(latitude: 40.600373623838834, longitude: -74.00915649709594),
            CLLocationCoordinate2D(latitude: 40.59983966563918, longitude: -74.00843087441642),
            CLLocationCoordinate2D(latitude: 40.599543259908984, longitude: -74.00805707820533),
            CLLocationCoordinate2D(latitude: 40.59905682707887, longitude: -74.00724762009172),
            CLLocationCoordinate2D(latitude: 40.59848423500958, longitude: -74.00632144793258),
            CLLocationCoordinate2D(latitude: 40.59741524163232, longitude: -74.0052773906837),
            CLLocationCoordinate2D(latitude: 40.59560242396344, longitude: -74.00315038189702),
            CLLocationCoordinate2D(latitude: 40.594094960389185, longitude: -74.00200340769761),
            CLLocationCoordinate2D(latitude: 40.60191678918406, longitude: -73.99381093540897),
            CLLocationCoordinate2D(latitude: 40.61275824781933, longitude: -74.01174373611481),
            CLLocationCoordinate2D(latitude: 40.60768783189394, longitude: -74.01696408972872),
            CLLocationCoordinate2D(latitude: 40.60691018574951, longitude: -74.01555396895394),
            CLLocationCoordinate2D(latitude: 40.60480102080899, longitude: -74.0177677288687),
            CLLocationCoordinate2D(latitude: 40.603895601329725, longitude: -74.01945264026051),
            CLLocationCoordinate2D(latitude: 40.60311991455927, longitude: -74.01996440825371)
        ]
    )
    
    static let bayRidge = Neighborhood(
        name: "Bay Ridge",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.61849290503653, longitude: -74.02117658262983),
            CLLocationCoordinate2D(latitude: 40.63393141818682, longitude: -74.01480472491446),
            CLLocationCoordinate2D(latitude: 40.64029921326099, longitude: -74.02619916645821),
            CLLocationCoordinate2D(latitude: 40.641315392688085, longitude: -74.0286051743495),
            CLLocationCoordinate2D(latitude: 40.64183301425473, longitude: -74.03062490027821),
            CLLocationCoordinate2D(latitude: 40.64190212999469, longitude: -74.0325907241192),
            CLLocationCoordinate2D(latitude: 40.641429663906536, longitude: -74.03437833445881),
            CLLocationCoordinate2D(latitude: 40.640804159271795, longitude: -74.0354127127346),
            CLLocationCoordinate2D(latitude: 40.63975618942291, longitude: -74.03629424268459),
            CLLocationCoordinate2D(latitude: 40.63698602773434, longitude: -74.03771033996736),
            CLLocationCoordinate2D(latitude: 40.63307437859095, longitude: -74.03964954045537),
            CLLocationCoordinate2D(latitude: 40.630194421430616, longitude: -74.04098247720677),
            CLLocationCoordinate2D(latitude: 40.62771991257543, longitude: -74.04146227885437),
            CLLocationCoordinate2D(latitude: 40.62594720673232, longitude: -74.04156289518261),
            CLLocationCoordinate2D(latitude: 40.62410145054815, longitude: -74.0337232271936),
            CLLocationCoordinate2D(latitude: 40.62277200551597, longitude: -74.02837366765318),
            CLLocationCoordinate2D(latitude: 40.61849290503653, longitude: -74.02117658262983)
        ]
    )
    
    static let fortHamilton = Neighborhood(
        name: "Fort Hamilton",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.62594762295734, longitude: -74.04156745258581),
            CLLocationCoordinate2D(latitude: 40.62272695945197, longitude: -74.04157336744724),
            CLLocationCoordinate2D(latitude: 40.62031007467854, longitude: -74.04134808523902),
            CLLocationCoordinate2D(latitude: 40.616519079532, longitude: -74.04052882803722),
            CLLocationCoordinate2D(latitude: 40.61402438428027, longitude: -74.03942062508729),
            CLLocationCoordinate2D(latitude: 40.61211317793723, longitude: -74.037554195265),
            CLLocationCoordinate2D(latitude: 40.60980688641379, longitude: -74.03539511020652),
            CLLocationCoordinate2D(latitude: 40.60687676593105, longitude: -74.03346530886365),
            CLLocationCoordinate2D(latitude: 40.60468634435898, longitude: -74.02993052358245),
            CLLocationCoordinate2D(latitude: 40.60423664125696, longitude: -74.02677787494297),
            CLLocationCoordinate2D(latitude: 40.60355589142378, longitude: -74.0213916986554),
            CLLocationCoordinate2D(latitude: 40.60311890605416, longitude: -74.0199687831943),
            CLLocationCoordinate2D(latitude: 40.603895766959, longitude: -74.01945717314116),
            CLLocationCoordinate2D(latitude: 40.60445413015697, longitude: -74.02129577177008),
            CLLocationCoordinate2D(latitude: 40.605680085162106, longitude: -74.02072021046045),
            CLLocationCoordinate2D(latitude: 40.606699674177094, longitude: -74.02254282127525),
            CLLocationCoordinate2D(latitude: 40.60801055148312, longitude: -74.0218073818238),
            CLLocationCoordinate2D(latitude: 40.60971766505452, longitude: -74.02479673178357),
            CLLocationCoordinate2D(latitude: 40.618487350433156, longitude: -74.0211702763817),
            CLLocationCoordinate2D(latitude: 40.62277173919409, longitude: -74.02836843994992),
            CLLocationCoordinate2D(latitude: 40.62594762295734, longitude: -74.04156745258581)
        ]
    )
    
    static let williamsburg = Neighborhood(
        name: "Williamsburg",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.69817189933357, longitude: -73.96189756266841),
            CLLocationCoordinate2D(latitude: 40.700708825627174, longitude: -73.94185362920655),
            CLLocationCoordinate2D(latitude: 40.70261121436545, longitude: -73.93396656606123),
            CLLocationCoordinate2D(latitude: 40.70572293587989, longitude: -73.92607562862304),
            CLLocationCoordinate2D(latitude: 40.71141867464843, longitude: -73.91980793828023),
            CLLocationCoordinate2D(latitude: 40.71236746535246, longitude: -73.92147613387863),
            CLLocationCoordinate2D(latitude: 40.71291323393905, longitude: -73.9239777148221),
            CLLocationCoordinate2D(latitude: 40.71514367428557, longitude: -73.92508989063641),
            CLLocationCoordinate2D(latitude: 40.716519187910706, longitude: -73.92345601212314),
            CLLocationCoordinate2D(latitude: 40.71781184301713, longitude: -73.92497200068908),
            CLLocationCoordinate2D(latitude: 40.719761037383165, longitude: -73.92482310895485),
            CLLocationCoordinate2D(latitude: 40.717230858757745, longitude: -73.9346899876492),
            CLLocationCoordinate2D(latitude: 40.720584254976615, longitude: -73.93621037756135),
            CLLocationCoordinate2D(latitude: 40.71944623982935, longitude: -73.94062171865227),
            CLLocationCoordinate2D(latitude: 40.72046402391865, longitude: -73.94078884289763),
            CLLocationCoordinate2D(latitude: 40.72029505845987, longitude: -73.94267726142634),
            CLLocationCoordinate2D(latitude: 40.71960498590235, longitude: -73.94391279612228),
            CLLocationCoordinate2D(latitude: 40.72080762553347, longitude: -73.94488323342193),
            CLLocationCoordinate2D(latitude: 40.71930680740883, longitude: -73.94745358102531),
            CLLocationCoordinate2D(latitude: 40.71917759632086, longitude: -73.94851581644765),
            CLLocationCoordinate2D(latitude: 40.71879785136758, longitude: -73.95237791605791),
            CLLocationCoordinate2D(latitude: 40.7192028270905, longitude: -73.95249241460084),
            CLLocationCoordinate2D(latitude: 40.723115092818574, longitude: -73.95882096545844),
            CLLocationCoordinate2D(latitude: 40.72417708487569, longitude: -73.95779832461545),
            CLLocationCoordinate2D(latitude: 40.72528764634731, longitude: -73.96125888790135),
            CLLocationCoordinate2D(latitude: 40.724838228998266, longitude: -73.96165423256757),
            CLLocationCoordinate2D(latitude: 40.72005641456721, longitude: -73.96444983274283),
            CLLocationCoordinate2D(latitude: 40.72039240453057, longitude: -73.9650554569457),
            CLLocationCoordinate2D(latitude: 40.719614490558286, longitude: -73.96538114098013),
            CLLocationCoordinate2D(latitude: 40.71924797019983, longitude: -73.96512454142534),
            CLLocationCoordinate2D(latitude: 40.71758419475418, longitude: -73.96677988476152),
            CLLocationCoordinate2D(latitude: 40.71321761743394, longitude: -73.9688184054591),
            CLLocationCoordinate2D(latitude: 40.713102383703784, longitude: -73.96846631787446),
            CLLocationCoordinate2D(latitude: 40.70947650525403, longitude: -73.96996472511958),
            CLLocationCoordinate2D(latitude: 40.708551010526406, longitude: -73.96989343062715),
            CLLocationCoordinate2D(latitude: 40.70853749955924, longitude: -73.96862795339445),
            CLLocationCoordinate2D(latitude: 40.70675402967507, longitude: -73.96852101210331),
            CLLocationCoordinate2D(latitude: 40.70413840127139, longitude: -73.96734606298307),
            CLLocationCoordinate2D(latitude: 40.699993570072934, longitude: -73.96198141110051),
            CLLocationCoordinate2D(latitude: 40.69817189933357, longitude: -73.96189756266841)
        ]
    )
    
    static let greenpoint = Neighborhood(
        name: "Greenpoint",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.72417854839742, longitude: -73.95779936812609),
            CLLocationCoordinate2D(latitude: 40.723115054680676, longitude: -73.9588192665053),
            CLLocationCoordinate2D(latitude: 40.719203143395845, longitude: -73.95249224249046),
            CLLocationCoordinate2D(latitude: 40.718798657845014, longitude: -73.95237687135288),
            CLLocationCoordinate2D(latitude: 40.7193069145608, longitude: -73.94745347274922),
            CLLocationCoordinate2D(latitude: 40.72080769483412, longitude: -73.94488460489879),
            CLLocationCoordinate2D(latitude: 40.719605569060775, longitude: -73.94391274491477),
            CLLocationCoordinate2D(latitude: 40.720295463347355, longitude: -73.94267770313348),
            CLLocationCoordinate2D(latitude: 40.72046422721516, longitude: -73.94078907562806),
            CLLocationCoordinate2D(latitude: 40.719446681888996, longitude: -73.94062132647824),
            CLLocationCoordinate2D(latitude: 40.7205845032658, longitude: -73.93621042380778),
            CLLocationCoordinate2D(latitude: 40.71723148311693, longitude: -73.93468545533665),
            CLLocationCoordinate2D(latitude: 40.719570014853446, longitude: -73.92558623726062),
            CLLocationCoordinate2D(latitude: 40.72550827178594, longitude: -73.92791649472916),
            CLLocationCoordinate2D(latitude: 40.727413532951886, longitude: -73.92978507567952),
            CLLocationCoordinate2D(latitude: 40.72805718993828, longitude: -73.93365813437686),
            CLLocationCoordinate2D(latitude: 40.72924561525457, longitude: -73.93741554974262),
            CLLocationCoordinate2D(latitude: 40.73098535301139, longitude: -73.93997003154892),
            CLLocationCoordinate2D(latitude: 40.733572914964384, longitude: -73.94109816363292),
            CLLocationCoordinate2D(latitude: 40.73105215254955, longitude: -73.94780810192604),
            CLLocationCoordinate2D(latitude: 40.730864444458916, longitude: -73.94909617979509),
            CLLocationCoordinate2D(latitude: 40.736764051616916, longitude: -73.95001570633124),
            CLLocationCoordinate2D(latitude: 40.73788375774018, longitude: -73.94948002143782),
            CLLocationCoordinate2D(latitude: 40.738597560592495, longitude: -73.95165970478368),
            CLLocationCoordinate2D(latitude: 40.73906403980297, longitude: -73.9542823734354),
            CLLocationCoordinate2D(latitude: 40.73882610804989, longitude: -73.95690538222388),
            CLLocationCoordinate2D(latitude: 40.736866637724034, longitude: -73.95997171644161),
            CLLocationCoordinate2D(latitude: 40.735665308359415, longitude: -73.96028365010068),
            CLLocationCoordinate2D(latitude: 40.73262796044625, longitude: -73.96172445774539),
            CLLocationCoordinate2D(latitude: 40.73120021905095, longitude: -73.96128113231615),
            CLLocationCoordinate2D(latitude: 40.730480234834175, longitude: -73.9611715602451),
            CLLocationCoordinate2D(latitude: 40.72878603461757, longitude: -73.96089337647483),
            CLLocationCoordinate2D(latitude: 40.72749053150861, longitude: -73.96115638055193),
            CLLocationCoordinate2D(latitude: 40.72604400975263, longitude: -73.96129134588348),
            CLLocationCoordinate2D(latitude: 40.72608451888888, longitude: -73.96003490278233),
            CLLocationCoordinate2D(latitude: 40.7255737739801, longitude: -73.95993627625363),
            CLLocationCoordinate2D(latitude: 40.725710803486805, longitude: -73.95833359515798),
            CLLocationCoordinate2D(latitude: 40.725368229191076, longitude: -73.95765964721014),
            CLLocationCoordinate2D(latitude: 40.72417854839742, longitude: -73.95779936812609)
        ]
    )
    
    static let bushwick = Neighborhood(
        name: "Bushwick",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.70944371850317, longitude: -73.92195570963415),
            CLLocationCoordinate2D(latitude: 40.70571965683928, longitude: -73.9260754749528),
            CLLocationCoordinate2D(latitude: 40.702610026922, longitude: -73.93395776339774),
            CLLocationCoordinate2D(latitude: 40.70070407350113, longitude: -73.94185764840135),
            CLLocationCoordinate2D(latitude: 40.680046697262924, longitude: -73.90545423414197),
            CLLocationCoordinate2D(latitude: 40.68144743692062, longitude: -73.904115980017),
            CLLocationCoordinate2D(latitude: 40.68080762874814, longitude: -73.90292199457508),
            CLLocationCoordinate2D(latitude: 40.6823247257002, longitude: -73.90285730989781),
            CLLocationCoordinate2D(latitude: 40.684016983683506, longitude: -73.90590785503709),
            CLLocationCoordinate2D(latitude: 40.68621199090373, longitude: -73.90456191403902),
            CLLocationCoordinate2D(latitude: 40.68680680129384, longitude: -73.90538179447589),
            CLLocationCoordinate2D(latitude: 40.68781419860716, longitude: -73.90493138768836),
            CLLocationCoordinate2D(latitude: 40.691836388621, longitude: -73.90124470079671),
            CLLocationCoordinate2D(latitude: 40.693333669720374, longitude: -73.90040655530399),
            CLLocationCoordinate2D(latitude: 40.69993642724117, longitude: -73.91184839276588),
            CLLocationCoordinate2D(latitude: 40.70105374093899, longitude: -73.91067403573005),
            CLLocationCoordinate2D(latitude: 40.70236757785446, longitude: -73.9129040771027),
            CLLocationCoordinate2D(latitude: 40.70343372165698, longitude: -73.91180450174156),
            CLLocationCoordinate2D(latitude: 40.70944371850317, longitude: -73.92195570963415)
        ]
    )
    
    static let gravesend = Neighborhood(
        name: "Gravesend",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.5941474105133, longitude: -74.00196162208934),
            CLLocationCoordinate2D(latitude: 40.592658295532516, longitude: -74.00108017334628),
            CLLocationCoordinate2D(latitude: 40.59372583213823, longitude: -73.99866514115176),
            CLLocationCoordinate2D(latitude: 40.59143597051542, longitude: -73.99698703936181),
            CLLocationCoordinate2D(latitude: 40.589703846218015, longitude: -73.99841943994622),
            CLLocationCoordinate2D(latitude: 40.5884293966414, longitude: -73.99756161899663),
            CLLocationCoordinate2D(latitude: 40.58958965427189, longitude: -73.99515078782387),
            CLLocationCoordinate2D(latitude: 40.58818395483871, longitude: -73.9943518101683),
            CLLocationCoordinate2D(latitude: 40.58640120632214, longitude: -73.99842233261235),
            CLLocationCoordinate2D(latitude: 40.58523626606538, longitude: -73.99814080628013),
            CLLocationCoordinate2D(latitude: 40.58410632684473, longitude: -74.00038607811294),
            CLLocationCoordinate2D(latitude: 40.58313110360481, longitude: -74.00017171688187),
            CLLocationCoordinate2D(latitude: 40.582203374681626, longitude: -73.99627213713677),
            CLLocationCoordinate2D(latitude: 40.58303168222105, longitude: -73.99397746892461),
            CLLocationCoordinate2D(latitude: 40.58454405479699, longitude: -73.99126372186736),
            CLLocationCoordinate2D(latitude: 40.58469299562759, longitude: -73.99019256763432),
            CLLocationCoordinate2D(latitude: 40.58204597518588, longitude: -73.99152687087215),
            CLLocationCoordinate2D(latitude: 40.580072983366136, longitude: -73.98791665114693),
            CLLocationCoordinate2D(latitude: 40.58153129444676, longitude: -73.98695318274865),
            CLLocationCoordinate2D(latitude: 40.58339610262564, longitude: -73.98391107661067),
            CLLocationCoordinate2D(latitude: 40.58273887051351, longitude: -73.97904281857046),
            CLLocationCoordinate2D(latitude: 40.58273887051351, longitude: -73.97532663557195),
            CLLocationCoordinate2D(latitude: 40.58383207059768, longitude: -73.96866747396832),
            CLLocationCoordinate2D(latitude: 40.583990194850884, longitude: -73.966685306088),
            CLLocationCoordinate2D(latitude: 40.5933650193019, longitude: -73.9646046219324),
            CLLocationCoordinate2D(latitude: 40.60943019218371, longitude: -73.96766274735687),
            CLLocationCoordinate2D(latitude: 40.608828652605354, longitude: -73.97299426274996),
            CLLocationCoordinate2D(latitude: 40.60714403803732, longitude: -73.98838136004635),
            CLLocationCoordinate2D(latitude: 40.5941474105133, longitude: -74.00196162208934)
        ]
    )
    static let midwood = Neighborhood(
        name: "Midwood",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.63055046473045, longitude: -73.94744327318229),
            CLLocationCoordinate2D(latitude: 40.62864246357984, longitude: -73.9659234634768),
            CLLocationCoordinate2D(latitude: 40.63229711722377, longitude: -73.96679098850872),
            CLLocationCoordinate2D(latitude: 40.62760731914352, longitude: -73.97654638526063),
            CLLocationCoordinate2D(latitude: 40.6088278098419, longitude: -73.97297801564021),
            CLLocationCoordinate2D(latitude: 40.61201301201717, longitude: -73.94408249885336),
            CLLocationCoordinate2D(latitude: 40.62917543555395, longitude: -73.94733381365977),
            CLLocationCoordinate2D(latitude: 40.63055046473045, longitude: -73.94744327318229)
        ]
    )
    static let sheepsheadBay = Neighborhood(
        name: "Sheepshead Bay",
        borough: "Brooklyn",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.5840217816299, longitude: -73.96667769385401),
            CLLocationCoordinate2D(latitude: 40.584164199878614, longitude: -73.96428651203557),
            CLLocationCoordinate2D(latitude: 40.5844020349719, longitude: -73.96216691082864),
            CLLocationCoordinate2D(latitude: 40.58279524080672, longitude: -73.95884150878898),
            CLLocationCoordinate2D(latitude: 40.58306145828337, longitude: -73.95708470526567),
            CLLocationCoordinate2D(latitude: 40.58263893551015, longitude: -73.95652406632098),
            CLLocationCoordinate2D(latitude: 40.5831398772668, longitude: -73.95350621883634),
            CLLocationCoordinate2D(latitude: 40.583641635178935, longitude: -73.94732869016272),
            CLLocationCoordinate2D(latitude: 40.58373438076083, longitude: -73.94155520332664),
            CLLocationCoordinate2D(latitude: 40.58345963180804, longitude: -73.94099875103488),
            CLLocationCoordinate2D(latitude: 40.582915136510024, longitude: -73.9309206030019),
            CLLocationCoordinate2D(latitude: 40.585763775430905, longitude: -73.92751716177297),
            CLLocationCoordinate2D(latitude: 40.585934141325225, longitude: -73.92853695596914),
            CLLocationCoordinate2D(latitude: 40.58683745149057, longitude: -73.92948802920588),
            CLLocationCoordinate2D(latitude: 40.58681297549259, longitude: -73.9313775855148),
            CLLocationCoordinate2D(latitude: 40.5875733461489, longitude: -73.93143990191284),
            CLLocationCoordinate2D(latitude: 40.58772090109716, longitude: -73.93018737807857),
            CLLocationCoordinate2D(latitude: 40.58957599717496, longitude: -73.93140306633181),
            CLLocationCoordinate2D(latitude: 40.594698179106956, longitude: -73.93312696775894),
            CLLocationCoordinate2D(latitude: 40.60102022582578, longitude: -73.93419912278283),
            CLLocationCoordinate2D(latitude: 40.60939678699077, longitude: -73.94359337837432),
            CLLocationCoordinate2D(latitude: 40.61201428374159, longitude: -73.94408647194439),
            CLLocationCoordinate2D(latitude: 40.60941256317031, longitude: -73.96766532402889),
            CLLocationCoordinate2D(latitude: 40.59336898963994, longitude: -73.96460000271384),
            CLLocationCoordinate2D(latitude: 40.5840217816299, longitude: -73.96667769385401)
        ]
    )
    
    static let financialDistrict = Neighborhood(
        name: "Financial District",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.701184839551075, longitude: -74.01359962958216),
            CLLocationCoordinate2D(latitude: 40.70059053627824, longitude: -74.01353544572822),
            CLLocationCoordinate2D(latitude: 40.70067952909474, longitude: -74.01233609306863),
            CLLocationCoordinate2D(latitude: 40.70121557851951, longitude: -74.01253443067657),
            CLLocationCoordinate2D(latitude: 40.70124920120688, longitude: -74.01223721741377),
            CLLocationCoordinate2D(latitude: 40.700701792818336, longitude: -74.01212871636645),
            CLLocationCoordinate2D(latitude: 40.70094713254957, longitude: -74.01106148096173),
            CLLocationCoordinate2D(latitude: 40.701486740635005, longitude: -74.01128299223362),
            CLLocationCoordinate2D(latitude: 40.70182746318528, longitude: -74.00968089058989),
            CLLocationCoordinate2D(latitude: 40.70305453838367, longitude: -74.00766684700159),
            CLLocationCoordinate2D(latitude: 40.70567449548909, longitude: -74.00349697225299),
            CLLocationCoordinate2D(latitude: 40.70458206106858, longitude: -74.00219744402),
            CLLocationCoordinate2D(latitude: 40.70476123472773, longitude: -74.00191189579326),
            CLLocationCoordinate2D(latitude: 40.70543672554595, longitude: -74.00263215338711),
            CLLocationCoordinate2D(latitude: 40.705527221750856, longitude: -74.00227215755446),
            CLLocationCoordinate2D(latitude: 40.70488464961272, longitude: -74.00150766941917),
            CLLocationCoordinate2D(latitude: 40.705493273741666, longitude: -74.00052383243782),
            CLLocationCoordinate2D(latitude: 40.706220618547206, longitude: -74.00152581024858),
            CLLocationCoordinate2D(latitude: 40.7064721645535, longitude: -74.00106966130383),
            CLLocationCoordinate2D(latitude: 40.70693153275599, longitude: -74.00149661054873),
            CLLocationCoordinate2D(latitude: 40.70804204368466, longitude: -73.99942657269244),
            CLLocationCoordinate2D(latitude: 40.71119886989331, longitude: -74.00323519029116),
            CLLocationCoordinate2D(latitude: 40.7118927761673, longitude: -74.00469302830905),
            CLLocationCoordinate2D(latitude: 40.712087934228066, longitude: -74.00542870608038),
            CLLocationCoordinate2D(latitude: 40.711359494495724, longitude: -74.00852832391107),
            CLLocationCoordinate2D(latitude: 40.71370978056066, longitude: -74.01385004537917),
            CLLocationCoordinate2D(latitude: 40.710807344767005, longitude: -74.0146015467646),
            CLLocationCoordinate2D(latitude: 40.70733613347926, longitude: -74.0157488170279),
            CLLocationCoordinate2D(latitude: 40.70490181119217, longitude: -74.01673099860321),
            CLLocationCoordinate2D(latitude: 40.70412826367951, longitude: -74.01670275163757),
            CLLocationCoordinate2D(latitude: 40.7023224609828, longitude: -74.01599675026242),
            CLLocationCoordinate2D(latitude: 40.70168540598908, longitude: -74.01542454329392),
            CLLocationCoordinate2D(latitude: 40.70128297499457, longitude: -74.01455153600399),
            CLLocationCoordinate2D(latitude: 40.701204400714374, longitude: -74.01393145231438),
            CLLocationCoordinate2D(latitude: 40.701184839551075, longitude: -74.01359962958216)
        ]
    )
    static let batteryPark = Neighborhood(
        name: "Battery Park",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.71891713643288, longitude: -74.01307502582871),
            CLLocationCoordinate2D(latitude: 40.71832039353569, longitude: -74.01323766614598),
            CLLocationCoordinate2D(latitude: 40.71855544175796, longitude: -74.01496896016607),
            CLLocationCoordinate2D(latitude: 40.71844076781886, longitude: -74.01499828634964),
            CLLocationCoordinate2D(latitude: 40.7186734841911, longitude: -74.0167021613572),
            CLLocationCoordinate2D(latitude: 40.71360888824785, longitude: -74.01763349022464),
            CLLocationCoordinate2D(latitude: 40.71343626760719, longitude: -74.01634772856747),
            CLLocationCoordinate2D(latitude: 40.71213743828912, longitude: -74.01662024451619),
            CLLocationCoordinate2D(latitude: 40.7123531783852, longitude: -74.01786556790584),
            CLLocationCoordinate2D(latitude: 40.70801422493162, longitude: -74.01885511359765),
            CLLocationCoordinate2D(latitude: 40.707835574666575, longitude: -74.01817532414223),
            CLLocationCoordinate2D(latitude: 40.706907808153375, longitude: -74.01853318443152),
            CLLocationCoordinate2D(latitude: 40.707027027432645, longitude: -74.01909588500816),
            CLLocationCoordinate2D(latitude: 40.706095346548324, longitude: -74.01933650509486),
            CLLocationCoordinate2D(latitude: 40.70476392153225, longitude: -74.01890587463588),
            CLLocationCoordinate2D(latitude: 40.70456350299153, longitude: -74.018147889715),
            CLLocationCoordinate2D(latitude: 40.70468054506162, longitude: -74.01807490803962),
            CLLocationCoordinate2D(latitude: 40.70473357252311, longitude: -74.01745784377363),
            CLLocationCoordinate2D(latitude: 40.70457207984555, longitude: -74.01750646557556),
            CLLocationCoordinate2D(latitude: 40.70443761020718, longitude: -74.01866244085798),
            CLLocationCoordinate2D(latitude: 40.70417071543241, longitude: -74.01844779938702),
            CLLocationCoordinate2D(latitude: 40.70425934179039, longitude: -74.01788316580227),
            CLLocationCoordinate2D(latitude: 40.704200224267424, longitude: -74.01753688591707),
            CLLocationCoordinate2D(latitude: 40.703797776720904, longitude: -74.0176771067479),
            CLLocationCoordinate2D(latitude: 40.70339409058016, longitude: -74.01760025140024),
            CLLocationCoordinate2D(latitude: 40.70286760719992, longitude: -74.01730424622745),
            CLLocationCoordinate2D(latitude: 40.701660833861524, longitude: -74.01612576029498),
            CLLocationCoordinate2D(latitude: 40.7008742093152, longitude: -74.01515365177517),
            CLLocationCoordinate2D(latitude: 40.70100648362089, longitude: -74.01498958351416),
            CLLocationCoordinate2D(latitude: 40.70073166417555, longitude: -74.01405265707203),
            CLLocationCoordinate2D(latitude: 40.70101313483744, longitude: -74.01396452681578),
            CLLocationCoordinate2D(latitude: 40.700952374934246, longitude: -74.0135804206064),
            CLLocationCoordinate2D(latitude: 40.70118156414341, longitude: -74.01360495674075),
            CLLocationCoordinate2D(latitude: 40.7012891224978, longitude: -74.01454914925547),
            CLLocationCoordinate2D(latitude: 40.70168800813906, longitude: -74.01543072179071),
            CLLocationCoordinate2D(latitude: 40.702320449871706, longitude: -74.01599882843097),
            CLLocationCoordinate2D(latitude: 40.7041311627695, longitude: -74.01670867293414),
            CLLocationCoordinate2D(latitude: 40.70490148740751, longitude: -74.01673634390659),
            CLLocationCoordinate2D(latitude: 40.70721984370327, longitude: -74.01579761275629),
            CLLocationCoordinate2D(latitude: 40.70941392675985, longitude: -74.01506797398544),
            CLLocationCoordinate2D(latitude: 40.710807120411886, longitude: -74.01459335689187),
            CLLocationCoordinate2D(latitude: 40.713711026389234, longitude: -74.01384876281683),
            CLLocationCoordinate2D(latitude: 40.71450906405792, longitude: -74.01352019329914),
            CLLocationCoordinate2D(latitude: 40.718808870603, longitude: -74.01249788840849),
            CLLocationCoordinate2D(latitude: 40.71891713643288, longitude: -74.01307502582871)
        ]
    )
    
    static let tribeca = Neighborhood(
        name: "Tribeca",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.71892228283022, longitude: -74.01307886608978),
            CLLocationCoordinate2D(latitude: 40.71880937187436, longitude: -74.01249913955702),
            CLLocationCoordinate2D(latitude: 40.71452030863665, longitude: -74.01351094871123),
            CLLocationCoordinate2D(latitude: 40.71370997877597, longitude: -74.01384933907072),
            CLLocationCoordinate2D(latitude: 40.71141235278404, longitude: -74.00864430562672),
            CLLocationCoordinate2D(latitude: 40.719389433902535, longitude: -74.00187706808319),
            CLLocationCoordinate2D(latitude: 40.725793209293954, longitude: -74.0108535991517),
            CLLocationCoordinate2D(latitude: 40.72600648203971, longitude: -74.01161538843958),
            CLLocationCoordinate2D(latitude: 40.72151000552478, longitude: -74.01254446549268),
            CLLocationCoordinate2D(latitude: 40.721589902144245, longitude: -74.01306940836048),
            CLLocationCoordinate2D(latitude: 40.721282769063606, longitude: -74.01313627896342),
            CLLocationCoordinate2D(latitude: 40.721578690795155, longitude: -74.01565993027874),
            CLLocationCoordinate2D(latitude: 40.72139974993962, longitude: -74.01625116779205),
            CLLocationCoordinate2D(latitude: 40.72128833154224, longitude: -74.0162187561488),
            CLLocationCoordinate2D(latitude: 40.72088987350324, longitude: -74.01292501513814),
            CLLocationCoordinate2D(latitude: 40.720343323150814, longitude: -74.01299415257012),
            CLLocationCoordinate2D(latitude: 40.720744323409576, longitude: -74.0163041910175),
            CLLocationCoordinate2D(latitude: 40.72038514641173, longitude: -74.01640240335408),
            CLLocationCoordinate2D(latitude: 40.72004682336279, longitude: -74.01343184876501),
            CLLocationCoordinate2D(latitude: 40.71982682002238, longitude: -74.01346004349392),
            CLLocationCoordinate2D(latitude: 40.71975563088452, longitude: -74.01291252684146),
            CLLocationCoordinate2D(latitude: 40.71892228283022, longitude: -74.01307886608978)
        ]
    )
    static let twoBridges = Neighborhood(
        name: "Two Bridges",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.70804718256545, longitude: -73.9994314089478),
            CLLocationCoordinate2D(latitude: 40.70820261797323, longitude: -73.99891169006814),
            CLLocationCoordinate2D(latitude: 40.70884622678585, longitude: -73.99696660299354),
            CLLocationCoordinate2D(latitude: 40.709547399262675, longitude: -73.99219800338747),
            CLLocationCoordinate2D(latitude: 40.713079361525445, longitude: -73.99405405143712),
            CLLocationCoordinate2D(latitude: 40.71274622675975, longitude: -73.99800132622092),
            CLLocationCoordinate2D(latitude: 40.71197517280865, longitude: -73.99777568497771),
            CLLocationCoordinate2D(latitude: 40.71173437500758, longitude: -74.00084826405747),
            CLLocationCoordinate2D(latitude: 40.71155656847483, longitude: -74.00269022707072),
            CLLocationCoordinate2D(latitude: 40.711394709904766, longitude: -74.00313383681842),
            CLLocationCoordinate2D(latitude: 40.71120539193839, longitude: -74.00323577944634),
            CLLocationCoordinate2D(latitude: 40.70804718256545, longitude: -73.9994314089478)
        ]
    )
    static let civicCenter = Neighborhood(
        name: "Civic Center",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.7127849638963, longitude: -73.99802077679439),
            CLLocationCoordinate2D(latitude: 40.71316654848934, longitude: -73.99812609182109),
            CLLocationCoordinate2D(latitude: 40.71371489666063, longitude: -73.99909132621197),
            CLLocationCoordinate2D(latitude: 40.714402444118974, longitude: -74.00050583844255),
            CLLocationCoordinate2D(latitude: 40.71518379608111, longitude: -74.00052905666469),
            CLLocationCoordinate2D(latitude: 40.7153066655373, longitude: -74.00079623523303),
            CLLocationCoordinate2D(latitude: 40.71654268949183, longitude: -73.99995679473169),
            CLLocationCoordinate2D(latitude: 40.717335754820056, longitude: -74.00161602451678),
            CLLocationCoordinate2D(latitude: 40.716739558528786, longitude: -74.00211028334634),
            CLLocationCoordinate2D(latitude: 40.7174511456283, longitude: -74.0035309947776),
            CLLocationCoordinate2D(latitude: 40.711412553938516, longitude: -74.00864472451956),
            CLLocationCoordinate2D(latitude: 40.7113595858454, longitude: -74.00852957546323),
            CLLocationCoordinate2D(latitude: 40.712088509971835, longitude: -74.00542811789859),
            CLLocationCoordinate2D(latitude: 40.71189473586912, longitude: -74.00468414462),
            CLLocationCoordinate2D(latitude: 40.71120219153448, longitude: -74.00323708801304),
            CLLocationCoordinate2D(latitude: 40.71139245221232, longitude: -74.00313827931775),
            CLLocationCoordinate2D(latitude: 40.71156185781501, longitude: -74.00268431203287),
            CLLocationCoordinate2D(latitude: 40.7119793227518, longitude: -73.99777676722319),
            CLLocationCoordinate2D(latitude: 40.7127849638963, longitude: -73.99802077679439)
        ]
    )
    static let chinatown = Neighborhood(
        name: "Chinatown",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.712745468561394, longitude: -73.99800802010436),
            CLLocationCoordinate2D(latitude: 40.71308160293924, longitude: -73.99404629125749),
            CLLocationCoordinate2D(latitude: 40.71338180256271, longitude: -73.99012414643494),
            CLLocationCoordinate2D(latitude: 40.71448588755308, longitude: -73.99023393327245),
            CLLocationCoordinate2D(latitude: 40.71675309467747, longitude: -73.98912363269918),
            CLLocationCoordinate2D(latitude: 40.71905687440426, longitude: -73.99648218450335),
            CLLocationCoordinate2D(latitude: 40.71787145416684, longitude: -73.99711423402543),
            CLLocationCoordinate2D(latitude: 40.71684083096798, longitude: -73.99779412134869),
            CLLocationCoordinate2D(latitude: 40.717227315514265, longitude: -73.99883184656076),
            CLLocationCoordinate2D(latitude: 40.71938919289096, longitude: -74.00187495638521),
            CLLocationCoordinate2D(latitude: 40.717446937545475, longitude: -74.00351866525722),
            CLLocationCoordinate2D(latitude: 40.71674115032809, longitude: -74.00210894446413),
            CLLocationCoordinate2D(latitude: 40.71734891199054, longitude: -74.00160886002388),
            CLLocationCoordinate2D(latitude: 40.71654690418791, longitude: -73.99996408415085),
            CLLocationCoordinate2D(latitude: 40.7153066652034, longitude: -74.0007958608362),
            CLLocationCoordinate2D(latitude: 40.715186309114756, longitude: -74.00052756161499),
            CLLocationCoordinate2D(latitude: 40.71440007143889, longitude: -74.00050083645868),
            CLLocationCoordinate2D(latitude: 40.71371315784231, longitude: -73.9990831267413),
            CLLocationCoordinate2D(latitude: 40.71316657836181, longitude: -73.99812585803183),
            CLLocationCoordinate2D(latitude: 40.712745468561394, longitude: -73.99800802010436)
        ]
    )
    
    static let centralPark = Neighborhood(
        name: "Central Park",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.768496147421246, longitude: -73.98142765917768),
            CLLocationCoordinate2D(latitude: 40.76831874700272, longitude: -73.98123935121251),
            CLLocationCoordinate2D(latitude: 40.768094891876814, longitude: -73.98115749997496),
            CLLocationCoordinate2D(latitude: 40.76789858753054, longitude: -73.98117568913891),
            CLLocationCoordinate2D(latitude: 40.7644362103222, longitude: -73.9729561162303),
            CLLocationCoordinate2D(latitude: 40.79659978302203, longitude: -73.9495087586714),
            CLLocationCoordinate2D(latitude: 40.79673425712784, longitude: -73.94967981273705),
            CLLocationCoordinate2D(latitude: 40.796908575008786, longitude: -73.94971270775008),
            CLLocationCoordinate2D(latitude: 40.79703806799452, longitude: -73.94974560276265),
            CLLocationCoordinate2D(latitude: 40.800439799917655, longitude: -73.95784604716934),
            CLLocationCoordinate2D(latitude: 40.800310313566996, longitude: -73.95801052223264),
            CLLocationCoordinate2D(latitude: 40.800300353068366, longitude: -73.9582999983439),
            CLLocationCoordinate2D(latitude: 40.768496147421246, longitude: -73.98142765917768)
        ]
    )
    
    static let midtown = Neighborhood(
        name: "Midtown",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.76415893574776, longitude: -73.98475029547356),
            CLLocationCoordinate2D(latitude: 40.76177807501665, longitude: -73.97906888551611),
            CLLocationCoordinate2D(latitude: 40.75356905146651, longitude: -73.98503306625108),
            CLLocationCoordinate2D(latitude: 40.755945612849246, longitude: -73.99072755781629),
            CLLocationCoordinate2D(latitude: 40.75219268588893, longitude: -73.99346857735057),
            CLLocationCoordinate2D(latitude: 40.74981480765095, longitude: -73.9877340004316),
            CLLocationCoordinate2D(latitude: 40.744812439081954, longitude: -73.9914193119129),
            CLLocationCoordinate2D(latitude: 40.741409860863286, longitude: -73.983372796842),
            CLLocationCoordinate2D(latitude: 40.74641025059978, longitude: -73.97975054357624),
            CLLocationCoordinate2D(latitude: 40.7477716366478, longitude: -73.98296858463945),
            CLLocationCoordinate2D(latitude: 40.752799492666185, longitude: -73.97929373147247),
            CLLocationCoordinate2D(latitude: 40.7480194194128, longitude: -73.9679267772299),
            CLLocationCoordinate2D(latitude: 40.75493272184002, longitude: -73.96189339786099),
            CLLocationCoordinate2D(latitude: 40.75543427195137, longitude: -73.96103774636603),
            CLLocationCoordinate2D(latitude: 40.756746004061824, longitude: -73.95995799942709),
            CLLocationCoordinate2D(latitude: 40.7585074763046, longitude: -73.9587779243713),
            CLLocationCoordinate2D(latitude: 40.76443652431138, longitude: -73.97295563081992),
            CLLocationCoordinate2D(latitude: 40.76790164073273, longitude: -73.98117962045926),
            CLLocationCoordinate2D(latitude: 40.76810431843066, longitude: -73.9811583815047),
            CLLocationCoordinate2D(latitude: 40.7683166467844, longitude: -73.98123908953363),
            CLLocationCoordinate2D(latitude: 40.768489156705755, longitude: -73.98143684622727),
            CLLocationCoordinate2D(latitude: 40.768509015105735, longitude: -73.98188259909662),
            CLLocationCoordinate2D(latitude: 40.76833690877427, longitude: -73.98226717019907),
            CLLocationCoordinate2D(latitude: 40.76809860696369, longitude: -73.98240701423637),
            CLLocationCoordinate2D(latitude: 40.76789340194196, longitude: -73.98234583247007),
            CLLocationCoordinate2D(latitude: 40.76774115264553, longitude: -73.98215354691918),
            CLLocationCoordinate2D(latitude: 40.76415893574776, longitude: -73.98475029547356)
        ]
    )
    
    static let theaterDistrict = Neighborhood(
        name: "Theater District",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.753571508931515, longitude: -73.98503416355642),
            CLLocationCoordinate2D(latitude: 40.76177819486213, longitude: -73.97906888784188),
            CLLocationCoordinate2D(latitude: 40.76415888707439, longitude: -73.98474981852176),
            CLLocationCoordinate2D(latitude: 40.75594572423836, longitude: -73.99072694108669),
            CLLocationCoordinate2D(latitude: 40.753571508931515, longitude: -73.98503416355642)
        ]
    )
    
    static let murrayHill = Neighborhood(
        name: "Murray Hill",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.747771802811656, longitude: -73.9829660511673),
            CLLocationCoordinate2D(latitude: 40.74320436736056, longitude: -73.97206926274323),
            CLLocationCoordinate2D(latitude: 40.74802001105476, longitude: -73.96792818654336),
            CLLocationCoordinate2D(latitude: 40.75279897404059, longitude: -73.97929380930219),
            CLLocationCoordinate2D(latitude: 40.747771802811656, longitude: -73.9829660511673)
        ]
    )
    
    static let hellsKitchen = Neighborhood(
        name: "Hell's Kitchen",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.767411820510546, longitude: -73.98239796628658),
            CLLocationCoordinate2D(latitude: 40.772406927299386, longitude: -73.99425200758104),
            CLLocationCoordinate2D(latitude: 40.772474036896426, longitude: -73.99420555706887),
            CLLocationCoordinate2D(latitude: 40.773265153409824, longitude: -73.99612391607323),
            CLLocationCoordinate2D(latitude: 40.7731392870966, longitude: -73.99622259958106),
            CLLocationCoordinate2D(latitude: 40.77237670050482, longitude: -73.99445276486065),
            CLLocationCoordinate2D(latitude: 40.771931603325726, longitude: -73.99477478596476),
            CLLocationCoordinate2D(latitude: 40.77282054496783, longitude: -73.99686272200111),
            CLLocationCoordinate2D(latitude: 40.77252695549939, longitude: -73.9970851262056),
            CLLocationCoordinate2D(latitude: 40.77166554375751, longitude: -73.99497641461424),
            CLLocationCoordinate2D(latitude: 40.77151607391659, longitude: -73.99492966977635),
            CLLocationCoordinate2D(latitude: 40.771437405443805, longitude: -73.99498160848535),
            CLLocationCoordinate2D(latitude: 40.77144054418119, longitude: -73.99512154366687),
            CLLocationCoordinate2D(latitude: 40.77119620275249, longitude: -73.9952832888418),
            CLLocationCoordinate2D(latitude: 40.77145580930028, longitude: -73.99589616560962),
            CLLocationCoordinate2D(latitude: 40.77132993958551, longitude: -73.99598446141495),
            CLLocationCoordinate2D(latitude: 40.77103886495692, longitude: -73.99541832948573),
            CLLocationCoordinate2D(latitude: 40.770551115422876, longitude: -73.99576112496564),
            CLLocationCoordinate2D(latitude: 40.77060573603072, longitude: -73.99591214222504),
            CLLocationCoordinate2D(latitude: 40.77047185806765, longitude: -73.9960017826035),
            CLLocationCoordinate2D(latitude: 40.77041285579472, longitude: -73.99586674195955),
            CLLocationCoordinate2D(latitude: 40.76977562790938, longitude: -73.99630822098705),
            CLLocationCoordinate2D(latitude: 40.77076310613123, longitude: -73.99866551787899),
            CLLocationCoordinate2D(latitude: 40.77041767900948, longitude: -73.99893952752832),
            CLLocationCoordinate2D(latitude: 40.76942249951907, longitude: -73.99658670400393),
            CLLocationCoordinate2D(latitude: 40.768734105486885, longitude: -73.9970496815646),
            CLLocationCoordinate2D(latitude: 40.76836853298602, longitude: -73.99614175101308),
            CLLocationCoordinate2D(latitude: 40.76805563325573, longitude: -73.99643033516836),
            CLLocationCoordinate2D(latitude: 40.76457387321406, longitude: -73.99885531423672),
            CLLocationCoordinate2D(latitude: 40.76586214568991, longitude: -74.00199284639582),
            CLLocationCoordinate2D(latitude: 40.76553137540992, longitude: -74.00233763015015),
            CLLocationCoordinate2D(latitude: 40.7651309670793, longitude: -74.00225718060769),
            CLLocationCoordinate2D(latitude: 40.76403418407972, longitude: -73.99951040336866),
            CLLocationCoordinate2D(latitude: 40.76429532453065, longitude: -73.99934950428373),
            CLLocationCoordinate2D(latitude: 40.7641734591146, longitude: -73.99914263403146),
            CLLocationCoordinate2D(latitude: 40.76338831447251, longitude: -73.99989226670922),
            CLLocationCoordinate2D(latitude: 40.764754951415, longitude: -74.00309875561933),
            CLLocationCoordinate2D(latitude: 40.76434583374868, longitude: -74.00312174120303),
            CLLocationCoordinate2D(latitude: 40.76343183837511, longitude: -74.00091512517915),
            CLLocationCoordinate2D(latitude: 40.762839910856115, longitude: -74.00136334405879),
            CLLocationCoordinate2D(latitude: 40.76377132383803, longitude: -74.00359294566633),
            CLLocationCoordinate2D(latitude: 40.763553705151, longitude: -74.0037998159186),
            CLLocationCoordinate2D(latitude: 40.76263969888464, longitude: -74.00155872151961),
            CLLocationCoordinate2D(latitude: 40.761734358155024, longitude: -74.00220759051173),
            CLLocationCoordinate2D(latitude: 40.762661735565274, longitude: -74.00438569848541),
            CLLocationCoordinate2D(latitude: 40.76247626111862, longitude: -74.00456613346527),
            CLLocationCoordinate2D(latitude: 40.76155864308231, longitude: -74.00231069621455),
            CLLocationCoordinate2D(latitude: 40.760982684865354, longitude: -74.00272311902633),
            CLLocationCoordinate2D(latitude: 40.76104125704589, longitude: -74.0030839890198),
            CLLocationCoordinate2D(latitude: 40.75909221318102, longitude: -74.00450562366774),
            CLLocationCoordinate2D(latitude: 40.759882956690575, longitude: -74.00642596738366),
            CLLocationCoordinate2D(latitude: 40.759238647874184, longitude: -74.00699304874946),
            CLLocationCoordinate2D(latitude: 40.7581832413978, longitude: -74.00463021633672),
            CLLocationCoordinate2D(latitude: 40.7571166408801, longitude: -74.00524453792694),
            CLLocationCoordinate2D(latitude: 40.75219275112792, longitude: -73.99346383034083),
            CLLocationCoordinate2D(latitude: 40.767411820510546, longitude: -73.98239796628658)
        ]
    )
    
    static let westVillage = Neighborhood(
        name: "West Village",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.72838789995734, longitude: -74.00285243298758),
            CLLocationCoordinate2D(latitude: 40.731080297601295, longitude: -74.00141786412776),
            CLLocationCoordinate2D(latitude: 40.73735437973653, longitude: -73.99683551347813),
            CLLocationCoordinate2D(latitude: 40.74256157061046, longitude: -74.00921899550006),
            CLLocationCoordinate2D(latitude: 40.74227497676918, longitude: -74.00926102518828),
            CLLocationCoordinate2D(latitude: 40.742576974851744, longitude: -74.01008516190574),
            CLLocationCoordinate2D(latitude: 40.7423799403077, longitude: -74.01029320981188),
            CLLocationCoordinate2D(latitude: 40.74261638169037, longitude: -74.01082373197254),
            CLLocationCoordinate2D(latitude: 40.74182824047915, longitude: -74.01140626610952),
            CLLocationCoordinate2D(latitude: 40.74123712844141, longitude: -74.0095650421408),
            CLLocationCoordinate2D(latitude: 40.74061200444825, longitude: -74.00969313854415),
            CLLocationCoordinate2D(latitude: 40.74070797646982, longitude: -74.01144272758498),
            CLLocationCoordinate2D(latitude: 40.73922039457412, longitude: -74.0115456445875),
            CLLocationCoordinate2D(latitude: 40.73918440427724, longitude: -74.01038189079125),
            CLLocationCoordinate2D(latitude: 40.73837180445307, longitude: -74.01043916384027),
            CLLocationCoordinate2D(latitude: 40.738401796735076, longitude: -74.0110804159322),
            CLLocationCoordinate2D(latitude: 40.738089876344304, longitude: -74.01111208270228),
            CLLocationCoordinate2D(latitude: 40.73805388543619, longitude: -74.0104787473026),
            CLLocationCoordinate2D(latitude: 40.7342934487892, longitude: -74.01082796445891),
            CLLocationCoordinate2D(latitude: 40.73435943583618, longitude: -74.01199963494798),
            CLLocationCoordinate2D(latitude: 40.7340654930324, longitude: -74.01199171825516),
            CLLocationCoordinate2D(latitude: 40.7340175022475, longitude: -74.0108517145362),
            CLLocationCoordinate2D(latitude: 40.73328563848506, longitude: -74.01087546461405),
            CLLocationCoordinate2D(latitude: 40.733351626531174, longitude: -74.01400255814842),
            CLLocationCoordinate2D(latitude: 40.733069677147995, longitude: -74.01401839153348),
            CLLocationCoordinate2D(latitude: 40.73302168564436, longitude: -74.01093088146143),
            CLLocationCoordinate2D(latitude: 40.73045467873976, longitude: -74.01114013178868),
            CLLocationCoordinate2D(latitude: 40.73068983834466, longitude: -74.01407343664232),
            CLLocationCoordinate2D(latitude: 40.72849498305132, longitude: -74.01436159505343),
            CLLocationCoordinate2D(latitude: 40.728241835978025, longitude: -74.01132694406164),
            CLLocationCoordinate2D(latitude: 40.72919929815268, longitude: -74.01120133654932),
            CLLocationCoordinate2D(latitude: 40.72838789995734, longitude: -74.00285243298758)
        ]
    )
    
    static let nolita = Neighborhood(
        name: "Nolita",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.72083163289872, longitude: -73.99763849229002),
            CLLocationCoordinate2D(latitude: 40.7195080380279, longitude: -73.99436833937968),
            CLLocationCoordinate2D(latitude: 40.72418211678226, longitude: -73.99260526631987),
            CLLocationCoordinate2D(latitude: 40.72510615990734, longitude: -73.99530396030364),
            CLLocationCoordinate2D(latitude: 40.72324438648775, longitude: -73.99676506324947),
            CLLocationCoordinate2D(latitude: 40.72083163289872, longitude: -73.99763849229002)
        ]
    )
    
    static let greenwichVillage = Neighborhood(
        name: "Greenwich Village",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.72838613668472, longitude: -74.00285116682171),
            CLLocationCoordinate2D(latitude: 40.72545447903039, longitude: -73.99677869663765),
            CLLocationCoordinate2D(latitude: 40.73176708269537, longitude: -73.9914731247948),
            CLLocationCoordinate2D(latitude: 40.7347845641041, longitude: -73.99075896697994),
            CLLocationCoordinate2D(latitude: 40.73735457400855, longitude: -73.99683498761966),
            CLLocationCoordinate2D(latitude: 40.731080704536566, longitude: -74.00141001246928),
            CLLocationCoordinate2D(latitude: 40.72838613668472, longitude: -74.00285116682171)
        ]
    )
    
    static let littleItaly = Neighborhood(
        name: "Little Italy",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.71684452909031, longitude: -73.9977859744129),
            CLLocationCoordinate2D(latitude: 40.717878075252514, longitude: -73.9971125032427),
            CLLocationCoordinate2D(latitude: 40.719057030736565, longitude: -73.99648149199399),
            CLLocationCoordinate2D(latitude: 40.71852649605037, longitude: -73.99478564641967),
            CLLocationCoordinate2D(latitude: 40.71950539749648, longitude: -73.99437135329126),
            CLLocationCoordinate2D(latitude: 40.72083285958681, longitude: -73.9976447301787),
            CLLocationCoordinate2D(latitude: 40.71802185655301, longitude: -73.99994652056712),
            CLLocationCoordinate2D(latitude: 40.71722448704665, longitude: -73.99883094444839),
            CLLocationCoordinate2D(latitude: 40.71684452909031, longitude: -73.9977859744129)
        ]
    )
    
    static let soho = Neighborhood(
        name: "SoHo",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.71802172247274, longitude: -73.99994604948303),
            CLLocationCoordinate2D(latitude: 40.720831224286115, longitude: -73.99764344089212),
            CLLocationCoordinate2D(latitude: 40.723252751098045, longitude: -73.99676302679813),
            CLLocationCoordinate2D(latitude: 40.72510204553561, longitude: -73.9953017705815),
            CLLocationCoordinate2D(latitude: 40.72545506392498, longitude: -73.99677922383698),
            CLLocationCoordinate2D(latitude: 40.728385954093454, longitude: -74.0028531613577),
            CLLocationCoordinate2D(latitude: 40.72919230099163, longitude: -74.0112004791612),
            CLLocationCoordinate2D(latitude: 40.72601038445788, longitude: -74.01161303720163),
            CLLocationCoordinate2D(latitude: 40.725793353583896, longitude: -74.01085413652355),
            CLLocationCoordinate2D(latitude: 40.71802172247274, longitude: -73.99994604948303)
        ]
    )
    
    static let flatironDistrict = Neighborhood(
        name: "Flatiron District",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.74481167137381, longitude: -73.99141698862766),
            CLLocationCoordinate2D(latitude: 40.74103468439708, longitude: -73.99416489357559),
            CLLocationCoordinate2D(latitude: 40.73831065694472, longitude: -73.98772731408648),
            CLLocationCoordinate2D(latitude: 40.73952767944229, longitude: -73.98685819238958),
            CLLocationCoordinate2D(latitude: 40.73885240563885, longitude: -73.98524620436831),
            CLLocationCoordinate2D(latitude: 40.74141359345592, longitude: -73.98337064592886),
            CLLocationCoordinate2D(latitude: 40.74481167137381, longitude: -73.99141698862766)
        ]
    )
    
    static let chelsea = Neighborhood(
        name: "Chelsea",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.73519959319873, longitude: -73.99172718703723),
            CLLocationCoordinate2D(latitude: 40.73714392370891, longitude: -73.99032262914895),
            CLLocationCoordinate2D(latitude: 40.7391690194228, longitude: -73.98975616049594),
            CLLocationCoordinate2D(latitude: 40.74103488749816, longitude: -73.99416589809837),
            CLLocationCoordinate2D(latitude: 40.74981938828594, longitude: -73.98773550259673),
            CLLocationCoordinate2D(latitude: 40.757116695528254, longitude: -74.00523976960488),
            CLLocationCoordinate2D(latitude: 40.75721242647174, longitude: -74.00547961701204),
            CLLocationCoordinate2D(latitude: 40.75495308720514, longitude: -74.00713284720074),
            CLLocationCoordinate2D(latitude: 40.75238697657903, longitude: -74.0083212176801),
            CLLocationCoordinate2D(latitude: 40.7506560393451, longitude: -74.00898839345729),
            CLLocationCoordinate2D(latitude: 40.75131004027139, longitude: -74.01057659254242),
            CLLocationCoordinate2D(latitude: 40.751052528630765, longitude: -74.01069556672566),
            CLLocationCoordinate2D(latitude: 40.750357242219934, longitude: -74.00911490971784),
            CLLocationCoordinate2D(latitude: 40.749988029729224, longitude: -74.00921506377388),
            CLLocationCoordinate2D(latitude: 40.7499649589939, longitude: -74.0096261896108),
            CLLocationCoordinate2D(latitude: 40.748951401488284, longitude: -74.00997276006328),
            CLLocationCoordinate2D(latitude: 40.74895716925607, longitude: -74.0112213645066),
            CLLocationCoordinate2D(latitude: 40.748657244678895, longitude: -74.01125181827365),
            CLLocationCoordinate2D(latitude: 40.74842076473155, longitude: -74.00893733198859),
            CLLocationCoordinate2D(latitude: 40.74779207005153, longitude: -74.00908198738118),
            CLLocationCoordinate2D(latitude: 40.74802278438631, longitude: -74.01133556613269),
            CLLocationCoordinate2D(latitude: 40.74760173012277, longitude: -74.01143454087473),
            CLLocationCoordinate2D(latitude: 40.74735947851681, longitude: -74.00916573524024),
            CLLocationCoordinate2D(latitude: 40.74678260549797, longitude: -74.00924958822957),
            CLLocationCoordinate2D(latitude: 40.74699601952503, longitude: -74.01154884763108),
            CLLocationCoordinate2D(latitude: 40.74659803065231, longitude: -74.01161736860661),
            CLLocationCoordinate2D(latitude: 40.74633847140913, longitude: -74.00931810920507),
            CLLocationCoordinate2D(latitude: 40.74574436534388, longitude: -74.00943992430982),
            CLLocationCoordinate2D(latitude: 40.746003759190444, longitude: -74.01174221562366),
            CLLocationCoordinate2D(latitude: 40.7455826922002, longitude: -74.01177266914368),
            CLLocationCoordinate2D(latitude: 40.74529428857511, longitude: -74.00952670383418),
            CLLocationCoordinate2D(latitude: 40.74499029188965, longitude: -74.00962951411537),
            CLLocationCoordinate2D(latitude: 40.74490422264137, longitude: -74.008777481178),
            CLLocationCoordinate2D(latitude: 40.74398614372686, longitude: -74.0089857558955),
            CLLocationCoordinate2D(latitude: 40.744000488807416, longitude: -74.00952537675627),
            CLLocationCoordinate2D(latitude: 40.74367772374217, longitude: -74.00954431085215),
            CLLocationCoordinate2D(latitude: 40.74392876336805, longitude: -74.01216667889263),
            CLLocationCoordinate2D(latitude: 40.74352709951131, longitude: -74.0122234810887),
            CLLocationCoordinate2D(latitude: 40.74325454051322, longitude: -74.00960111304822),
            CLLocationCoordinate2D(latitude: 40.742967635079964, longitude: -74.00963898114591),
            CLLocationCoordinate2D(latitude: 40.742887748957685, longitude: -74.00910231428348),
            CLLocationCoordinate2D(latitude: 40.74255063310787, longitude: -74.00920645164258),
            CLLocationCoordinate2D(latitude: 40.73519959319873, longitude: -73.99172718703723)
        ]
    )
    
    static let kipsBay = Neighborhood(
        name: "Kips Bay",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.73951668301919, longitude: -73.98475570342055),
            CLLocationCoordinate2D(latitude: 40.73516946923428, longitude: -73.9744781418042),
            CLLocationCoordinate2D(latitude: 40.73600622475709, longitude: -73.97456717829418),
            CLLocationCoordinate2D(latitude: 40.73644108962981, longitude: -73.97448109165798),
            CLLocationCoordinate2D(latitude: 40.73577918030949, longitude: -73.9728581354128),
            CLLocationCoordinate2D(latitude: 40.73581179538456, longitude: -73.97249226720845),
            CLLocationCoordinate2D(latitude: 40.73920784454637, longitude: -73.97271826096407),
            CLLocationCoordinate2D(latitude: 40.74306962549042, longitude: -73.97177596876433),
            CLLocationCoordinate2D(latitude: 40.746427781005394, longitude: -73.97976376262037),
            CLLocationCoordinate2D(latitude: 40.73951668301919, longitude: -73.98475570342055)
        ]
    )
    
    static let gramercy = Neighborhood(
        name: "Gramercy",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.73520445455296, longitude: -73.99172102800652),
            CLLocationCoordinate2D(latitude: 40.731356832614495, longitude: -73.98255318957932),
            CLLocationCoordinate2D(latitude: 40.736888625131144, longitude: -73.97854700567437),
            CLLocationCoordinate2D(latitude: 40.73951849651135, longitude: -73.98474788582368),
            CLLocationCoordinate2D(latitude: 40.738853347983024, longitude: -73.98524380298983),
            CLLocationCoordinate2D(latitude: 40.73952893967643, longitude: -73.98685947496715),
            CLLocationCoordinate2D(latitude: 40.73830870839072, longitude: -73.98772531419974),
            CLLocationCoordinate2D(latitude: 40.739166463092204, longitude: -73.9897543281938),
            CLLocationCoordinate2D(latitude: 40.73714384842435, longitude: -73.9903153224103),
            CLLocationCoordinate2D(latitude: 40.73520445455296, longitude: -73.99172102800652)
        ]
    )
    
    static let stuyvesantTown = Neighborhood(
        name: "Stuyvesant Town",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.73690079538517, longitude: -73.97854782528785),
            CLLocationCoordinate2D(latitude: 40.731366662181756, longitude: -73.98255631009368),
            CLLocationCoordinate2D(latitude: 40.726818150628986, longitude: -73.9717061182372),
            CLLocationCoordinate2D(latitude: 40.72929919585658, longitude: -73.97149625113609),
            CLLocationCoordinate2D(latitude: 40.7313284793147, longitude: -73.9735476888097),
            CLLocationCoordinate2D(latitude: 40.73516107679333, longitude: -73.97447110939311),
            CLLocationCoordinate2D(latitude: 40.73690079538517, longitude: -73.97854782528785)
        ]
    )
    
    static let eastVillage = Neighborhood(
        name: "East Village",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.72419673751935, longitude: -73.99261373557589),
            CLLocationCoordinate2D(latitude: 40.72070421900489, longitude: -73.98122548010862),
            CLLocationCoordinate2D(latitude: 40.71931454079893, longitude: -73.97713843732639),
            CLLocationCoordinate2D(latitude: 40.71864019727161, longitude: -73.97357951273239),
            CLLocationCoordinate2D(latitude: 40.72685085655564, longitude: -73.97166920761984),
            CLLocationCoordinate2D(latitude: 40.7347891520572, longitude: -73.99075971035793),
            CLLocationCoordinate2D(latitude: 40.731757425243956, longitude: -73.99147157270572),
            CLLocationCoordinate2D(latitude: 40.73009937396469, longitude: -73.99285001780822),
            CLLocationCoordinate2D(latitude: 40.72973974409146, longitude: -73.99078034394546),
            CLLocationCoordinate2D(latitude: 40.72419673751935, longitude: -73.99261373557589)
        ]
    )
    
    static let lowerEastSide = Neighborhood(
        name: "Lower East Side",
        borough: "Manhattan",
        boundary: [
            CLLocationCoordinate2D(latitude: 40.718541836040856, longitude: -73.9947546077552),
            CLLocationCoordinate2D(latitude: 40.71678860146082, longitude: -73.9891817931574),
            CLLocationCoordinate2D(latitude: 40.71448270951268, longitude: -73.99023996671677),
            CLLocationCoordinate2D(latitude: 40.7133999153028, longitude: -73.99005478634362),
            CLLocationCoordinate2D(latitude: 40.713079084007035, longitude: -73.99410230020837),
            CLLocationCoordinate2D(latitude: 40.709529784649334, longitude: -73.9922240421405),
            CLLocationCoordinate2D(latitude: 40.71001105666633, longitude: -73.9886262520384),
            CLLocationCoordinate2D(latitude: 40.7091888792005, longitude: -73.98849397399609),
            CLLocationCoordinate2D(latitude: 40.70987068368862, longitude: -73.98132484813097),
            CLLocationCoordinate2D(latitude: 40.710291794738396, longitude: -73.98129839379189),
            CLLocationCoordinate2D(latitude: 40.71049232287356, longitude: -73.97809741877474),
            CLLocationCoordinate2D(latitude: 40.71197621230439, longitude: -73.97640434107956),
            CLLocationCoordinate2D(latitude: 40.71863898116405, longitude: -73.97356671734909),
            CLLocationCoordinate2D(latitude: 40.71930887063044, longitude: -73.9770935097308),
            CLLocationCoordinate2D(latitude: 40.724194171452325, longitude: -73.9925858112171),
            CLLocationCoordinate2D(latitude: 40.718541836040856, longitude: -73.9947546077552)
        ]
    )
    
    static func getNeighborhoodName(for location: CLLocationCoordinate2D) -> String {
        return getAllNeighborhoods().first { $0.contains(location) }?.name ?? "New York"
    }
    
    static func getNeighborhoodForName(_ name: String) -> Neighborhood? {
        return getAllNeighborhoods().first { $0.name == name }
    }
    
    // MARK: - Get All Neighborhoods
    static func getAllNeighborhoods() -> [Neighborhood] {
        return [
            parkSlope,
            prospectPark,
            gowanus,
            windsorTerrace,
            carrollGardens,
            cobbleHill,
            boerumHill,
            prospectHeights,
            crownHeights,
            fortGreene,
            columbiaWaterfront,
            brooklynHeights,
            dumbo,
            downtownBrooklyn,
            vinegarHill,
            clintonHill,
            greenwoodCemetery,
            sunsetPark,
            redHook,
            prospectLeffertsGardens,
            flatbush,
            kensington,
            boroughPark,
            bedfordStuyvensant,
            dykerHeights,
            bensonhurst,
            bathBeach,
            bayRidge,
            fortHamilton,
            williamsburg,
            greenpoint,
            bushwick,
            gravesend,
            midwood,
            sheepsheadBay,
            financialDistrict,
            batteryPark,
            tribeca,
            twoBridges,
            civicCenter,
            chinatown,
            centralPark,
            midtown,
            theaterDistrict,
            murrayHill,
            hellsKitchen,
            westVillage,
            nolita,
            greenwichVillage,
            littleItaly,
            soho,
            flatironDistrict,
            chelsea,
            kipsBay,
            gramercy,
            stuyvesantTown,
            eastVillage,
            lowerEastSide
        ]
    }
    
    // MARK: - Get Neighborhoods by Borough
    static func getNeighborhoodsByBorough(_ borough: String) -> [Neighborhood] {
        return getAllNeighborhoods().filter { $0.borough == borough }
    }
}