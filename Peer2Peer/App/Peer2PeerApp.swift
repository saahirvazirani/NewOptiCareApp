
import SwiftUI
import Firebase
import UserNotifications
@main
struct Peer2PeerApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Set notification delegate to handle notification events
        UNUserNotificationCenter.current().delegate = self
        
        // Request notification permissions
        NotificationManager().requestNotificationPermission()
        
        return true
    }
    
    // Handle notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Present the notification as a banner and play sound when app is active
        completionHandler([.banner, .sound])
    }
    
    // Optionally handle the user's response to the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Perform actions when the user taps on the notification
        completionHandler()
    }
}

