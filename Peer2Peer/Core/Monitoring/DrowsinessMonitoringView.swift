import SwiftUI
import AVFoundation

struct DrowsinessMonitoringView: View {
    @StateObject private var cameraManager = DrowsinessCameraManager()
    @State private var isMonitoring = false
    @State private var drowsinessLevel: String?
    @State private var timeRemaining = 15
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                if isMonitoring {
                    CameraPreview(session: $cameraManager.session)
                        .frame(height: 300)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top)

                    // Bold message to remind user to keep eyes visible
                    Text("Keep your eyes visible on the screen")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top, 5)

                    Text("Monitoring for Drowsiness")
                        .font(.headline)

                    Text("Time Remaining: \(timeRemaining) seconds")
                        .font(.title3)
                        .foregroundColor(.blue)

                    Button(action: {
                        stopMonitoring()
                    }) {
                        Text("Stop Monitoring")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.red.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 20)
                } else {
                    if let drowsiness = drowsinessLevel {
                        VStack(spacing: 15) {
                            // Drowsiness result and recommendation
                            Text("Drowsiness Level: \(drowsiness)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(drowsiness == "Very Drowsy" ? .red : (drowsiness == "Little Drowsy" ? .orange : .green))

                            Text(recommendation(for: drowsiness))
                                .font(.title3)
                                .fontWeight(.bold)  // Make the text bold
                                .foregroundColor(.white)  // Make the text white
                                .padding(.top, 5)
                                .frame(maxWidth: .infinity)  // Center the text
                                .multilineTextAlignment(.center)  // Center multiline text
                                .background(drowsiness == "Very Drowsy" ? Color.red : (drowsiness == "Little Drowsy" ? Color.orange : Color.green))  // Background based on drowsiness level
                                .cornerRadius(10)  // Rounded corners
                        }

                        // Return to Home Button
                        NavigationLink(destination: HomeView()) {
                            Text("Return to Home")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.orange.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 20)
                    } else {
                        Button(action: {
                            startMonitoring()
                        }) {
                            Text("Start Drowsiness Monitoring for 15 Seconds")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.orange.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Drowsiness Monitoring")
    }

    // Start monitoring and the 15-second timer
    func startMonitoring() {
        cameraManager.startMonitoring() // Start the camera
        isMonitoring = true
        timeRemaining = 15
        drowsinessLevel = nil
        
        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= 1

            if timeRemaining <= 0 {
                stopMonitoring() // Stop monitoring when time is up
            }
        }
    }

    // Stop monitoring and display the result
    func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
        cameraManager.stopMonitoring() // Stop the camera session

        // Get the most prevalent drowsiness level
        drowsinessLevel = cameraManager.getMostPrevalentDrowsinessLevel()
    }

    // Provide recommendations based on drowsiness level
    func recommendation(for level: String) -> String {
        switch level {
        case "Very Drowsy":
            return "You are very drowsy. It’s important to take a longer break and avoid staring at screens for a while. Rest your eyes and get some sleep if needed."
        case "Little Drowsy":
            return "You are a little drowsy. Consider taking a short break, resting your eyes, and hydrating to avoid fatigue."
        default:
            return "You are not drowsy. Keep up with regular breaks to maintain eye health!"
        }
    }
}
