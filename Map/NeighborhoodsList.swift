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
                    ("Park Slope", Neighborhoods.parkSlope),
                    ("Prospect Park", Neighborhoods.prospectPark),
                    ("Greenwood Heights", Neighborhoods.greenwoodHeights),
                    ("Gowanus", Neighborhoods.gowanus),
                    ("Windsor Terrace", Neighborhoods.windsorTerrace),
                    ("Carroll Gardens", Neighborhoods.carrollGardens),
                    ("Cobble Hill", Neighborhoods.cobbleHill),
                    ("Boerum Hill", Neighborhoods.boeumHill),
                    ("Prospect Heights", Neighborhoods.prospectHeights),
                    ("Crown Heights", Neighborhoods.crownHeights),
                    ("Fort Greene", Neighborhoods.fortGreene),
                    ("Columbia Waterfront", Neighborhoods.columbiaWaterfront),
                    ("Brooklyn Heights", Neighborhoods.brooklynHeights),
                    ("DUMBO", Neighborhoods.dumbo),
                    ("Downtown Brooklyn", Neighborhoods.downtownBrooklyn)
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
        }
    }
}
