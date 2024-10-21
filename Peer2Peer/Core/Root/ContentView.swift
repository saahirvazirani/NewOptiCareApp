import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil { // Compare the actual value, not the binding
                MainTabBarController() // Show MainTabBarController when user is logged in
            } else {
                LoginView() // Show LoginView when user is not logged in
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
//
