//
//  MapControlsView.swift
//  Map
//
//  Created by Adam Kuzma on 4/12/25.
//

import SwiftUI

// MARK: - Map Controls View
struct MapControlsView: View {
    @Binding var isExploreMode: Bool
    @Binding var isLocationTracking: Bool
    @Binding var isTestMode: Bool
    @Binding var currentNeighborhood: String
    @Binding var exploredPercentage: Double
    @Binding var showNeighborhoodsList: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar View
            HStack {
                Picker("Mode", selection: $isExploreMode) {
                    Text("Explore").tag(true)
                    Text("Test").tag(false)
                }
                .pickerStyle(.segmented)
                .padding()
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Spacer()
                
                Button(action: {
                    isLocationTracking = true
                }) {
                    Image(systemName: "location.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            
            // Test Mode Button
            if !isExploreMode {
                Button(action: {
                    isTestMode.toggle()
                }) {
                    Text(isTestMode ? "Stop Test" : "Start Test")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                .padding(.top, 8)
            }
            
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
