import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notifications")) {
                    NavigationLink(destination: ReminderNotificationsView()) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.blue)
                            Text("Set Eye Rest Reminder")
                        }
                    }
                }
                
                // Add other settings sections here as needed
                
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

