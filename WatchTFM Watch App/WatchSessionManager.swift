//
//  WatchSessionManager.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 27/5/23.
//

import WatchConnectivity
import WatchKit

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    private override init() {
        super.init()
    }
    
    func startSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation completion
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
 
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        // Handle incoming message data with a response
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        // Handle incoming application context
    }
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        // Handle the completion of a user info transfer
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // Handle incoming messages without a reply handler
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        
    }
}
