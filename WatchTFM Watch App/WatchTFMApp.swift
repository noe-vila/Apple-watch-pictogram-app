//
//  WatchTFMApp.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI
import Firebase
import WatchConnectivity

@main
struct WatchTFM_Watch_AppApp: App {
    @StateObject private var taskViewModel = TaskViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .edgesIgnoringSafeArea(.all)
            .environmentObject(taskViewModel)
        }
    }
}
