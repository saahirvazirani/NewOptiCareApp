import SwiftUI
import AVFoundation

struct MonitoringView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var isMonitoring = false
    @State private var navigateToResults = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isMonitoring {
                    // Camera Preview Layer
                    CameraPreview(session: $cameraManager.session)
                        .onAppear {
                            DispatchQueue.global(qos: .userInitiated).async {
                                cameraManager.session.startRunning()
                                print("Camera session started")
                            }
                        }
                        .onDisappear {
                            DispatchQueue.global(qos: .userInitiated).async {
                                cameraManager.session.stopRunning()
                                print("Camera session stopped")
                            }
                        }
                        .frame(height: 300)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Spacer()
                    
                    // Eye Strain Score Text
                    Text("Eye Strain Score: \(cameraManager.eyeStrainScore)")
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                    
                    // Eye Strain Score Progress View (Moved below the score)
                    ProgressView(value: Double(cameraManager.eyeStrainScore), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .padding(.horizontal)
                    
                    Spacer()

                    // Stop Monitoring Button
                    Button(action: {
                        isMonitoring = false
                        navigateToResults = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            cameraManager.session.stopRunning()
                        }
                    }) {
                        Text("Stop Monitoring")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                    
                    // Navigation Link using value-based navigation
                    NavigationLink(value: cameraManager.eyeStrainScore) {
                        EmptyView()
                    }
                    .navigationDestination(for: Int.self) { score in
                        ResultsView(eyeStrainScore: score)
                    }
                } else {
                    Text("Start Monitoring to Analyze Eye Movement")
                        .font(.title3)
                        .padding()
                    
                    Button(action: {
                        isMonitoring.toggle()
                    }) {
                        Text("Start Monitoring")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Monitoring")
        }
    }
}
