//
//  opticare.swift
//  opticare app new
//
//
//
import SwiftUI
import Firebase
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
