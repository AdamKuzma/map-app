//
//  ContentView.swift
//  Map
//
//  Created by Adam Kuzma on 3/20/25.
//

/// Context for Cursor AI:
/// Use the latest SwiftUI syntax (as of Xcode 15, iOS 17).
/// Use Mapbox Maps SDK v11+ for iOS (using `MapboxMaps` package).
/// Prefer `.task`, `@State`, and `Observable` over older patterns.
/// Assume the app uses Swift Concurrency (async/await), not Combine.

import SwiftUI
import MapboxMaps
import CoreLocation

// MARK: - Neighborhoods List View
struct NeighborhoodsListView: View {
    @Binding var fogOverlay: FogOverlay?
    @ObservedObject var locationManager: LocationManager
    @State private var neighborhoodPercentages: [String: Double] = [:]
    @State private var lastRefreshTime: Date = Date()
    @State private var needsRefresh: Bool = true
    
    // Minimum time between full refreshes (in seconds)
    private let minRefreshInterval: TimeInterval = 10.0
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Explored Neighborhoods")
                    .font(.headline)
                    .padding(.top, 30)
                Spacer()
            }
            
            NeighborhoodsList(neighborhoodPercentages: neighborhoodPercentages)
        }
        .onAppear {
            refreshNeighborhoodPercentages(forceRefresh: true)
        }
        .onChange(of: locationManager.currentLocation) { _ in
            // Only mark for refresh when location changes
            needsRefresh = true
            checkAndRefresh()
        }
        .onReceive(Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()) { _ in
            // Check less frequently if a refresh is needed
            checkAndRefresh()
        }
    }
    
    private func checkAndRefresh() {
        // Skip if no refresh needed
        guard needsRefresh else { return }
        
        let currentTime = Date()
        let timeSinceLastRefresh = currentTime.timeIntervalSince(lastRefreshTime)
        
        // Only refresh if enough time has passed since last refresh
        if timeSinceLastRefresh >= minRefreshInterval {
            refreshNeighborhoodPercentages(forceRefresh: false)
        }
    }
    
    private func refreshNeighborhoodPercentages(forceRefresh: Bool) {
        guard let overlay = fogOverlay else {
            print("Can't refresh - FogOverlay is nil")
            return
        }
        
        // Skip if no overlay or no location
        guard locationManager.currentLocation != nil else {
            print("Skipping refresh - no current location")
            return
        }
        
        // Only proceed with full refresh if forced or needed
        if forceRefresh || needsRefresh {
            print("Refreshing neighborhood percentages...")
            
            // Batch update percentages to reduce UI updates
            var updatedPercentages: [String: Double] = [:]
            
            // Calculate percentages for each neighborhood using a for loop
            for neighborhood in Neighborhoods.getAllNeighborhoods() {
                updatedPercentages[neighborhood.name] = overlay.calculateNeighborhoodPercentage(neighborhood)
            }
            
            // Update state with all percentages at once
            neighborhoodPercentages = updatedPercentages
            
            // Reset tracking variables
            lastRefreshTime = Date()
            needsRefresh = false
            
            print("Percentages refreshed")
        }
    }
}

// MARK: - Content View
struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isExploreMode = true
    @State private var exploredPercentage = 0.0
    @State private var currentNeighborhood = "New York"
    @State private var showNeighborhoodsList = false
    @State private var fogOverlay: FogOverlay?
    @State private var renderingMode: RenderingMode = .overlay
    @State private var currentZoomLevel: Double = 0.0
    @Environment(\.scenePhase) private var scenePhase
    
    enum RenderingMode: String, CaseIterable {
        case overlay = "Overlay"
        case mapbox = "Mapbox"
    }
    
    var body: some View {
        ZStack {
            // Map View
            MapBoxMapView(
                locationManager: locationManager,
                isExploreMode: $isExploreMode,
                exploredPercentage: $exploredPercentage,
                currentNeighborhood: $currentNeighborhood,
                fogOverlay: $fogOverlay,
                renderingMode: $renderingMode,
                currentZoomLevel: $currentZoomLevel
            )
            .ignoresSafeArea()
            
            // Controls Overlay
            VStack(spacing: 0) {
                // Rendering Mode Tabs
                // Picker("Rendering Mode", selection: $renderingMode) {
                //     ForEach(RenderingMode.allCases, id: \.self) { mode in
                //         Text(mode.rawValue).tag(mode)
                //     }
                // }
                // .pickerStyle(.segmented)
                // .padding(.horizontal)
                // .padding(.top, 8)
                
                // Main Controls
            MapControlsView(
                isExploreMode: $isExploreMode,
                currentNeighborhood: $currentNeighborhood,
                exploredPercentage: $exploredPercentage,
                showNeighborhoodsList: $showNeighborhoodsList,
                currentZoomLevel: $currentZoomLevel
            )
            }
        }
        .sheet(isPresented: $showNeighborhoodsList) {
            NeighborhoodsListView(fogOverlay: $fogOverlay, locationManager: locationManager)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}


#Preview {
    ContentView()
}
