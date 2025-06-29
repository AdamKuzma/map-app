//
//  NeighborhoodsList.swift
//  Map
//
//  Created by Adam Kuzma on 4/12/25.
//

import SwiftUI
import CoreLocation

// MARK: - Neighborhoods List
struct NeighborhoodsList: View {
    let neighborhoodPercentages: [String: Double]
    
    var body: some View {
        List {
            Section(header: Text("Brooklyn")) {
                let neighborhoods = [
                    ("Vinegar Hill", Neighborhoods.vinegarHill),
                    ("Park Slope", Neighborhoods.parkSlope),
                    ("Prospect Park", Neighborhoods.prospectPark),
                    ("Gowanus", Neighborhoods.gowanus),
                    ("Windsor Terrace", Neighborhoods.windsorTerrace),
                    ("Carroll Gardens", Neighborhoods.carrollGardens),
                    ("Cobble Hill", Neighborhoods.cobbleHill),
                    ("Boerum Hill", Neighborhoods.boerumHill),
                    ("Clinton Hill", Neighborhoods.clintonHill),
                    ("Greenwood Cemetery", Neighborhoods.greenwoodCemetery),
                    ("Prospect Heights", Neighborhoods.prospectHeights),
                    ("Crown Heights", Neighborhoods.crownHeights),
                    ("Fort Greene", Neighborhoods.fortGreene),
                    ("Columbia Waterfront", Neighborhoods.columbiaWaterfront),
                    ("Brooklyn Heights", Neighborhoods.brooklynHeights),
                    ("Dumbo", Neighborhoods.dumbo),
                    ("Downtown Brooklyn", Neighborhoods.downtownBrooklyn),
                    ("Sunset Park", Neighborhoods.sunsetPark),
                    ("Red Hook", Neighborhoods.redHook),
                    ("Prospect Lefferts Gardens", Neighborhoods.prospectLeffertsGardens),
                    ("Flatbush", Neighborhoods.flatbush),
                    ("Kensington", Neighborhoods.kensington),
                    ("Borough Park", Neighborhoods.boroughPark),
                    ("Bedford Stuyvensant", Neighborhoods.bedfordStuyvensant),
                    ("Dyker Heights", Neighborhoods.dykerHeights),
                    ("Bensonhurst", Neighborhoods.bensonhurst),
                    ("Bath Beach", Neighborhoods.bathBeach),
                    ("Bay Ridge", Neighborhoods.bayRidge),
                    ("Fort Hamilton", Neighborhoods.fortHamilton),
                    ("Williamsburg", Neighborhoods.williamsburg),
                    ("Greenpoint", Neighborhoods.greenpoint),
                    ("Bushwick", Neighborhoods.bushwick),
                    ("Gravesend", Neighborhoods.gravesend),
                    ("Midwood", Neighborhoods.midwood),
                    ("Sheepshead Bay", Neighborhoods.sheepsheadBay)
                ]
                
                // Sort neighborhoods by highest percentage explored
                let sortedNeighborhoods = neighborhoods.sorted { 
                    (neighborhoodPercentages[$0.0] ?? 0.0) > (neighborhoodPercentages[$1.0] ?? 0.0)
                }
                
                ForEach(sortedNeighborhoods, id: \.0) { name, neighborhood in
                    HStack {
                        Text(name)
                            .foregroundColor((neighborhoodPercentages[name] ?? 0.0) > 0.0 ? .primary : .gray)
                        Spacer()
                        Text(String(format: "%.1f%%", neighborhoodPercentages[name] ?? 0.0))
                            .foregroundColor((neighborhoodPercentages[name] ?? 0.0) > 0.0 ? .primary : .gray)
                    }
                }
            }
            Section(header: Text("Manhattan")) {
                let manhattanNeighborhoods = [
                    ("Financial District", Neighborhoods.financialDistrict),
                    ("Battery Park", Neighborhoods.batteryPark),
                    ("Tribeca", Neighborhoods.tribeca),
                    ("Two Bridges", Neighborhoods.twoBridges),
                    ("Civic Center", Neighborhoods.civicCenter),
                    ("Chinatown", Neighborhoods.chinatown)
                ]
                let sortedManhattan = manhattanNeighborhoods.sorted {
                    (neighborhoodPercentages[$0.0] ?? 0.0) > (neighborhoodPercentages[$1.0] ?? 0.0)
                }
                ForEach(sortedManhattan, id: \ .0) { name, neighborhood in
                    HStack {
                        Text(name)
                            .foregroundColor((neighborhoodPercentages[name] ?? 0.0) > 0.0 ? .primary : .gray)
                        Spacer()
                        Text(String(format: "%.1f%%", neighborhoodPercentages[name] ?? 0.0))
                            .foregroundColor((neighborhoodPercentages[name] ?? 0.0) > 0.0 ? .primary : .gray)
                    }
                }
            }
        }
    }
}
