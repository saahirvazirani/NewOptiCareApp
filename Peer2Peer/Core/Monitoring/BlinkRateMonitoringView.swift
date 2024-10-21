import SwiftUI
import AVFoundation

struct BlinkRateMonitoringView: View {
    @StateObject private var cameraManager = BlinkRateCameraManager()
    @State private var isMonitoring = false
    @State private var blinksPerMinute: Int?
    @State private var timeRemaining = 60
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
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

                    Text("Blinking Rate Monitoring")
                        .font(.headline)

                    // Show timer countdown
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
                    // Display the results after monitoring
                    if let blinks = blinksPerMinute {
                        // Show blink count and recommendation
                        VStack(spacing: 15) {
                            Text("You blinked \(blinks) times.")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(blinks >= 15 && blinks <= 20 ? .green : .red)

                            Text(recommendation(for: blinks))
                                .font(.title3)
                                .fontWeight(.bold)    // Make the text bold
                                .foregroundColor(.white)  // Make the text white
                                .padding(.top, 5)
                                .frame(maxWidth: .infinity)  // Center the text
                                .multilineTextAlignment(.center)  // Center multiline text
                                .background(blinks >= 15 && blinks <= 20 ? Color.green : Color.red)  // Different background based on condition
                                .cornerRadius(10)   // Rounded corners
                        }

                        // Return to Home Button
                        NavigationLink(destination: HomeView()) {
                            Text("Return to Home")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 20)
                    } else {
                        Button(action: {
                            startMonitoring()
                        }) {
                            Text("Start Monitoring for 1 Minute")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Blink Rate Monitoring")
    }

    // Start monitoring and the 1-minute timer
    func startMonitoring() {
        cameraManager.startMonitoring() // Start camera monitoring
        isMonitoring = true
        timeRemaining = 60 // 1 minute timer
        blinksPerMinute = nil
        
        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining -= 1

            if timeRemaining <= 0 {
                stopMonitoring() // Stop monitoring when time is up
            }
        }
    }

    // Stop monitoring and show results
    func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
        cameraManager.stopMonitoring() // Stop the camera session
        
        // Get the blink rate after 1 minute
        blinksPerMinute = cameraManager.getBlinkRate()
    }

    // Provide recommendations based on the blink rate
    func recommendation(for blinks: Int) -> String {
        if blinks < 15 {
            return "You’re blinking too little. Consider taking a break and make sure you blink frequently while working."
        } else if blinks > 20 {
            return "You’re blinking too much. You might be feeling tired. Take a break and relax your eyes."
        } else {
            return "You’re blinking at a healthy rate. Keep up with regular breaks to maintain this balance!"
        }
    }
}
