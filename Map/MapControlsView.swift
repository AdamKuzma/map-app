//
//  MapControlsView.swift
//  Map
//
//  Created by Adam Kuzma on 4/12/25.
//

import SwiftUI
import MapboxMaps

// MARK: - Map Controls View
struct MapControlsView: View {
    @Binding var isExploreMode: Bool
    @Binding var isLocationTracking: Bool
    @Binding var isTestMode: Bool
    @Binding var currentNeighborhood: String
    @Binding var exploredPercentage: Double
    @Binding var showNeighborhoodsList: Bool
    @State private var is3DEnabled = false
    
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
            
            HStack {
                Spacer()
                VStack(spacing: 12) {
                    // 3D View Toggle Button
                    Button(action: {
                        is3DEnabled.toggle()
                        if let mapView = (UIApplication.shared.windows.first?.rootViewController?.view.subviews.first { $0 is MapboxMaps.MapView }) as? MapboxMaps.MapView {
                            let currentCamera = mapView.mapboxMap.cameraState
                            let newPitch = is3DEnabled ? 45.0 : 0.0
                            let camera = CameraOptions(
                                center: currentCamera.center,
                                zoom: currentCamera.zoom,
                                bearing: currentCamera.bearing,
                                pitch: newPitch
                            )
                            mapView.mapboxMap.setCamera(to: camera)
                        }
                    }) {
                        Image(systemName: is3DEnabled ? "view.3d" : "view.2d")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}
