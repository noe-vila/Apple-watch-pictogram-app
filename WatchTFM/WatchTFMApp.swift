//
//  WatchTFMApp.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI
import Firebase
import WatchConnectivity

@main
struct WatchTFMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
