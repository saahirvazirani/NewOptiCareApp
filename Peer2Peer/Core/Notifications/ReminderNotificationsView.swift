import SwiftUI

struct ReminderNotificationsView: View {
    @State private var selectedMinutes = 20
    @StateObject private var notificationManager = EyeRestNotificationManager()

    @State private var countdown: Int = 0
    @State private var totalSeconds: Int = 0
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    Text("Eye Rest Reminder")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.top, 40)

                    // Info Section with Facts
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Fact 1: On average, we spend more than 10 hours a day in front of a screen.")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)

                        Text("Fact 2: A healthy blink rate is around 15-20 times per minute.")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)

                        Text("Fact 3: Screen use decreases blink rate by over 60%.")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .shadow(radius: 3)

                    // Picker for Time Intervals
                    VStack {
                        Text("Set a Reminder Interval")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        Picker("Rest Interval", selection: $selectedMinutes) {
                            ForEach(Array(stride(from: 5, through: 120, by: 5)), id: \.self) { minutes in
                                Text("\(minutes) minutes").tag(minutes)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 150)
                        .clipped()
                    }
                    .padding()

                    // Timer/Progress Section
                    if countdown > 0 {
                        VStack {
                            Text("Time Remaining: \(formattedTime(countdown))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding()

                            ProgressView(value: Double(totalSeconds - countdown), total: Double(totalSeconds))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .padding()
                        }
                    }

                    // Set Reminder Button
                    Button(action: {
                        startTimer()
                        notificationManager.scheduleNotification(in: selectedMinutes)
                        print("Scheduled notification for \(selectedMinutes) minutes.")
                    }) {
                        Text("Set Reminder for \(selectedMinutes) minutes")
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

                    Spacer()
                }
                .padding()
            }
            .onAppear {
                notificationManager.requestNotificationPermission()
            }
        }
    }

    // Start the countdown timer
    func startTimer() {
        totalSeconds = selectedMinutes * 60
        countdown = totalSeconds

        timer?.invalidate() // Stop any previous timer

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer?.invalidate()
            }
        }
    }

    // Format the time as minutes and seconds
    func formattedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ReminderNotificationsView()
}
