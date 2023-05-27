//
//  WatchTFMApp.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI
import WatchConnectivity

@main
struct WatchTFM_Watch_AppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                WatchSessionManager.shared.startSession()
            }
        }
    }
}
