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
                let brooklynNeighborhoods = Neighborhoods.getNeighborhoodsByBorough("Brooklyn")
                
                // Sort neighborhoods by highest percentage explored
                let sortedNeighborhoods = brooklynNeighborhoods.sorted { 
                    (neighborhoodPercentages[$0.name] ?? 0.0) > (neighborhoodPercentages[$1.name] ?? 0.0)
                }
                
                ForEach(sortedNeighborhoods, id: \.name) { neighborhood in
                    HStack {
                        Text(neighborhood.name)
                            .foregroundColor((neighborhoodPercentages[neighborhood.name] ?? 0.0) > 0.0 ? .primary : .gray)
                        Spacer()
                        Text(String(format: "%.1f%%", neighborhoodPercentages[neighborhood.name] ?? 0.0))
                            .foregroundColor((neighborhoodPercentages[neighborhood.name] ?? 0.0) > 0.0 ? .primary : .gray)
                    }
                }
            }
            Section(header: Text("Manhattan")) {
                let manhattanNeighborhoods = Neighborhoods.getNeighborhoodsByBorough("Manhattan")
                
                let sortedManhattan = manhattanNeighborhoods.sorted {
                    (neighborhoodPercentages[$0.name] ?? 0.0) > (neighborhoodPercentages[$1.name] ?? 0.0)
                }
                ForEach(sortedManhattan, id: \.name) { neighborhood in
                    HStack {
                        Text(neighborhood.name)
                            .foregroundColor((neighborhoodPercentages[neighborhood.name] ?? 0.0) > 0.0 ? .primary : .gray)
                        Spacer()
                        Text(String(format: "%.1f%%", neighborhoodPercentages[neighborhood.name] ?? 0.0))
                            .foregroundColor((neighborhoodPercentages[neighborhood.name] ?? 0.0) > 0.0 ? .primary : .gray)
                    }
                }
            }
        }
    }
}
