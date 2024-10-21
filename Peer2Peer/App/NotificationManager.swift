
import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification(in minutes: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Rest Your Eyes!"
        content.body = "Hey, I think it's time to look 20 feet away from your screen, while blinking for 20 seconds."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(minutes * 60), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
