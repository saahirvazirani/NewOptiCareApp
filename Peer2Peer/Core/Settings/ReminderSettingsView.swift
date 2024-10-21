import SwiftUI

struct ReminderSettingsView: View {
    @State private var selectedMinutes = 20
    @StateObject private var notificationManager = NotificationManager()

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Set Reminder to Rest Your Eyes")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.green)
                    .padding(.top, 40)

                Text("Recommended: Set a reminder for 20 minutes.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                // Picker to choose the interval in 5-minute increments
                VStack {
                    Text("Rest Interval")
                        .font(.title2)
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

                Button(action: {
                    notificationManager.scheduleNotification(in: selectedMinutes)
                    print("Scheduled notification for \(selectedMinutes) minutes.")
                }) {
                    Text("Set Reminder for \(selectedMinutes) minutes")
                        .font(.title2)
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
            .onAppear {
                notificationManager.requestNotificationPermission()
            }
        }
        .navigationTitle("Eye Rest Reminder Settings")
    }
}

#Preview {
    ReminderSettingsView()
}
