//
//  MapControlsView.swift
//  Map
//
//  Created by Adam Kuzma on 4/12/25.
//

/// Context for Cursor AI:
/// Use the latest SwiftUI syntax (as of Xcode 15, iOS 17).
/// Use Mapbox Maps SDK v11+ for iOS (using `MapboxMaps` package).
/// Prefer `.task`, `@State`, and `Observable` over older patterns.
/// Assume the app uses Swift Concurrency (async/await), not Combine.

import SwiftUI
import MapboxMaps

// MARK: - Map Controls View
struct MapControlsView: View {
    @Binding var isExploreMode: Bool
    @Binding var currentNeighborhood: String
    @Binding var exploredPercentage: Double
    @Binding var showNeighborhoodsList: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar View
            
            Spacer()
            
            // Neighborhood and Explored Percentage
            Button(action: {
                showNeighborhoodsList = true
            }) {
                Text("\(currentNeighborhood) • \(String(format: "%.1f", exploredPercentage))%")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    .padding(.bottom, 8)
            }
        }
    }
}
