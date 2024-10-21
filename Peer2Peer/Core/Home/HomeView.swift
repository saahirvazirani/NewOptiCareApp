import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    // Title
                    Text("OptiCare Dashboard")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.blue)
                        .shadow(radius: 3)
                        .padding(.top, 40)

                    Spacer()

                    // Blink Rate Monitoring Button
                    NavigationLink(destination: BlinkRateMonitoringView()) {
                        HStack {
                            Image(systemName: "eye")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Blink Rate Monitoring")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.7)  // Scale down if text overflows
                                .lineLimit(1)             // Ensure text stays on one line
                        }
                        .padding()  // Add padding for better touch target size
                        .frame(maxWidth: .infinity)  // Dynamic width based on text
                        .frame(height: 60)  // Height is fixed for consistent look
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                    }

                    // Drowsiness Monitoring Button
                    NavigationLink(destination: DrowsinessMonitoringView()) {
                        HStack {
                            Image(systemName: "zzz")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Drowsiness Monitoring")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(color: Color.orange.opacity(0.5), radius: 10, x: 0, y: 5)
                    }

                    // Manage Break Reminders Button
                    NavigationLink(destination: ReminderNotificationsView()) {
                        HStack {
                            Image(systemName: "bell")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Manage Break Reminders")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(color: Color.green.opacity(0.5), radius: 10, x: 0, y: 5)
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
