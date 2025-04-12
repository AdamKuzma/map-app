//
//  ContentView.swift
//  Map
//
//  Created by Adam Kuzma on 3/20/25.
//

import SwiftUI
import MapboxMaps
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isLocationTracking = false
    @State private var isTestMode = false
    @State private var isExploreMode = true  // Default to Explore mode
    @State private var exploredPercentage: Double = 0
    @State private var currentNeighborhood: String = "New York"
    
    var body: some View {
        ZStack {

            // Map View
            MapBoxMapView(
                 locationManager: locationManager,
                 isTestMode: $isTestMode,
                 isLocationTracking: $isLocationTracking,
                 isExploreMode: $isExploreMode,
                 exploredPercentage: $exploredPercentage,
                 currentNeighborhood: $currentNeighborhood)
                .ignoresSafeArea()
            

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

#Preview {
    ContentView()
}
