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
            
            // Calculate percentages for each neighborhood
            updatedPercentages["Park Slope"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.parkSlope)
            updatedPercentages["Prospect Park"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.prospectPark)
            updatedPercentages["Greenwood Cemetery"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.greenwoodCemetery)
            updatedPercentages["Sunset Park"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.sunsetPark)
            updatedPercentages["Gowanus"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.gowanus)
            updatedPercentages["Windsor Terrace"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.windsorTerrace)
            updatedPercentages["Carroll Gardens"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.carrollGardens)
            updatedPercentages["Cobble Hill"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.cobbleHill)
            updatedPercentages["Boerum Hill"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.boerumHill)
            updatedPercentages["Prospect Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.prospectHeights)
            updatedPercentages["Crown Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.crownHeights)
            updatedPercentages["Fort Greene"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.fortGreene)
            updatedPercentages["Columbia Waterfront"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.columbiaWaterfront)
            updatedPercentages["Brooklyn Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.brooklynHeights)
            updatedPercentages["Dumbo"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.dumbo)
            updatedPercentages["Downtown Brooklyn"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.downtownBrooklyn)
            updatedPercentages["Vinegar Hill"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.vinegarHill)
            updatedPercentages["Clinton Hill"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.clintonHill)
            updatedPercentages["Red Hook"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.redHook)
            updatedPercentages["Prospect Lefferts Gardens"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.prospectLeffertsGardens)
            updatedPercentages["Flatbush"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.flatbush)
            updatedPercentages["Kensington"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.kensington)
            updatedPercentages["Borough Park"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.boroughPark)
            updatedPercentages["Bedford Stuyvensant"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.bedfordStuyvensant)
            updatedPercentages["Dyker Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.dykerHeights)
            updatedPercentages["Bensonhurst"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.bensonhurst)
            updatedPercentages["Bath Beach"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.bathBeach)
            updatedPercentages["Bay Ridge"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.bayRidge)
            updatedPercentages["Fort Hamilton"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.fortHamilton)
            updatedPercentages["Williamsburg"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.williamsburg)
            updatedPercentages["Greenpoint"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.greenpoint)
            updatedPercentages["Bushwick"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.bushwick)
            updatedPercentages["Gravesend"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.gravesend)
            updatedPercentages["Midwood"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.midwood)
            updatedPercentages["Sheepshead Bay"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.sheepsheadBay)
            updatedPercentages["Financial District"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.financialDistrict)
            updatedPercentages["Battery Park"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.batteryPark)
            updatedPercentages["Tribeca"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.tribeca)
            updatedPercentages["Two Bridges"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.twoBridges)
            updatedPercentages["Civic Center"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.civicCenter)
            updatedPercentages["Chinatown"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.chinatown)
            
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
