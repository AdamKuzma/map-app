//
//  ContentView.swift
//  Map
//
//  Created by Adam Kuzma on 3/20/25.
//

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
            updatedPercentages["Greenwood Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.greenwoodHeights)
            updatedPercentages["Gowanus"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.gowanus)
            updatedPercentages["Windsor Terrace"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.windsorTerrace)
            updatedPercentages["Carroll Gardens"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.carrollGardens)
            updatedPercentages["Cobble Hill"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.cobbleHill)
            updatedPercentages["Boerum Hill"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.boeumHill)
            updatedPercentages["Prospect Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.prospectHeights)
            updatedPercentages["Crown Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.crownHeights)
            updatedPercentages["Fort Greene"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.fortGreene)
            updatedPercentages["Columbia Waterfront"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.columbiaWaterfront)
            updatedPercentages["Brooklyn Heights"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.brooklynHeights)
            updatedPercentages["DUMBO"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.dumbo)
            updatedPercentages["Downtown Brooklyn"] = overlay.calculateNeighborhoodPercentage(Neighborhoods.downtownBrooklyn)
            
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
    @State private var isTestMode = false
    @State private var isLocationTracking = false
    @State private var isExploreMode = true
    @State private var exploredPercentage = 0.0
    @State private var currentNeighborhood = "New York"
    @State private var showNeighborhoodsList = false
    @State private var fogOverlay: FogOverlay?
    @State private var showDebugLogs = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            // Map View
            MapBoxMapView(
                locationManager: locationManager,
                isTestMode: $isTestMode,
                isLocationTracking: $isLocationTracking,
                isExploreMode: $isExploreMode,
                exploredPercentage: $exploredPercentage,
                currentNeighborhood: $currentNeighborhood,
                fogOverlay: $fogOverlay
            )
            .ignoresSafeArea()
            
            // Controls Overlay
            MapControlsView(
                isExploreMode: $isExploreMode,
                isLocationTracking: $isLocationTracking,
                isTestMode: $isTestMode,
                currentNeighborhood: $currentNeighborhood,
                exploredPercentage: $exploredPercentage,
                showNeighborhoodsList: $showNeighborhoodsList,
                showDebugLogs: $showDebugLogs
            )
        }
        .sheet(isPresented: $showNeighborhoodsList) {
            NeighborhoodsListView(fogOverlay: $fogOverlay, locationManager: locationManager)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showDebugLogs) {
            DebugLogsView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Debug Logs View
struct DebugLogsView: View {
    @State private var logs: [String] = []
    
    var body: some View {
        NavigationView {
            List(logs, id: \.self) { log in
                Text(log)
                    .font(.system(.body, design: .monospaced))
            }
            .navigationTitle("Debug Logs")
            .navigationBarItems(trailing: Button("Clear") {
                logs = []
            })
        }
        .onAppear {
            // Start capturing logs
            NotificationCenter.default.addObserver(forName: NSNotification.Name("DebugLog"), object: nil, queue: .main) { notification in
                if let log = notification.object as? String {
                    logs.append(log)
                }
            }
        }
    }
}

// MARK: - Debug Logging
extension ContentView {
    static func debugLog(_ message: String) {
        print(message)
        NotificationCenter.default.post(name: NSNotification.Name("DebugLog"), object: message)
    }
}

#Preview {
    ContentView()
}
