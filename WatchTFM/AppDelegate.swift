//
//  AppDelegate.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 27/5/23.
//

import UIKit
import WatchConnectivity
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate, WCSessionDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        return true
    }
    

    // MARK: - WCSessionDelegate

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Session became inactive
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Session was deactivated (e.g., when switching to a new paired Apple Watch)
        WCSession.default.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Session activation completed
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        // Handle received message data from Apple Watch
        // This method will be called when the Apple Watch sends a message to the iPhone app
        // You can process the message data and send a reply back to the watch if needed
    }
}
