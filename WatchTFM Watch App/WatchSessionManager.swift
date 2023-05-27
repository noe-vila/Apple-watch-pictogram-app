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
        do {
            let task = try JSONDecoder().decode(Task.self, from: messageData)
            
            // Update the UI or perform any actions with the received task data
            DispatchQueue.main.async {
                // For example, update a label with the task name:
                YourViewModel.shared.updateTask(task)
            }
        } catch {
            print("Error decoding task data: \(error)")
        }
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

class YourViewModel: ObservableObject {
    static let shared = YourViewModel()
    
    @Published var task: Task = Task()
    
    func updateTask(_ taskData: Task) {
        task = taskData
    }
}
