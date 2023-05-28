//
//  TaskViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import WatchConnectivity


class TaskViewModel: ObservableObject {
    @Published private var taskItems: [Task] = []
    
    init() {
        loadTasks()
    }
    
    func getTaskItems() -> [Task] {
        return taskItems
    }
    
    func getAlphabeticalTaskItems() -> [Task] {
        return taskItems.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    func getTotalTasks() -> Int {
        return taskItems.count
    }
    
    func addTask(_ task: Task) -> String? {
        for existingTask in taskItems {
            if task.startDate <= existingTask.endDate && task.endDate >= existingTask.startDate {
                return existingTask.name
            }
        }
        
        if let insertIndex = taskItems.firstIndex(where: { $0.startDate > task.startDate }) {
            taskItems.insert(task, at: insertIndex)
        } else {
            taskItems.append(task)
        }
        
        saveTask(task)
        return nil
    }

    private func saveTask(_ task: Task) {
        let db = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        let taskRef = db.child("users").child(userId).child("taskItems").childByAutoId()
        let imageDataString = task.imageData
        let name = task.name
        let startDate = task.startDate.timeIntervalSince1970
        let endDate = task.endDate.timeIntervalSince1970
        
        let taskData: [String: Any] = [
            "imageData": imageDataString,
            "name": name,
            "startDate": startDate,
            "endDate": endDate
        ]
        
        taskRef.setValue(taskData) { (error, _) in
            if let error = error {
                print("Error saving task: \(error)")
            } else {
                print("Task saved successfully.")
            }
        }
    }
    
    func getTaskIndex(task: Task) -> Int? {
        return taskItems.firstIndex { $0 == task }
    }
    
    func getCurrentTask() -> Task? {
        let currentDate = Date()
        return taskItems.first(where: { $0.startDate <= currentDate && $0.endDate >= currentDate })
    }
    
    func sendCurrentTaskToWatch() {
        guard let currentTask = getCurrentTask() else {
            return
        }
        let session = WCSession.default
        if session.isReachable {
            do {
                let encodedTask = try JSONEncoder().encode(currentTask)
                session.sendMessageData(encodedTask, replyHandler: nil, errorHandler: { error in
                    print("Error sending task to watch: \(error)")
                })
            } catch {
                print("Error encoding task: \(error)")
            }
        }
    }
    
    func removeTask(index: Int) {
        let task = taskItems[index]
        let db = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        let taskRef = db.child("users").child(userId).child("taskItems").child(task.id)
        taskRef.removeValue { (error, _) in
            if let error = error {
                print("Error removing task with ID \(task.id): \(error)")
            } else {
                self.taskItems.remove(at: index)
                print("Task with ID \(task.id) removed successfully.")
            }
        }
    }
    
    private func saveTasks() {
        let db = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        for (index, task) in taskItems.enumerated() {
            let taskRef = db.child("users").child(userId).child("taskItems").child(task.id)
            let imageDataString = task.imageData
            let name = task.name
            let startDate = task.startDate.timeIntervalSince1970
            let endDate = task.endDate.timeIntervalSince1970
            
            let taskData: [String: Any] = [
                "imageData": imageDataString,
                "name": name,
                "startDate": startDate,
                "endDate": endDate
            ]
            
            taskRef.setValue(taskData) { (error, _) in
                if let error = error {
                    print("Error saving task at index \(index): \(error)")
                } else {
                    print("Task at index \(index) saved successfully.")
                }
            }
        }
    }
    
    
    func loadTasks() {
        let db = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        let taskItemsRef = db.child("users").child(userId).child("taskItems")
        taskItemsRef.observeSingleEvent(of: .value) { snapshot in
            guard let tasksSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            var loadedTasks: [Task] = []
            
            for taskSnapshot in tasksSnapshot {
                guard let taskData = taskSnapshot.value as? [String: Any],
                      let imageDataString = taskData["imageData"] as? String,
                      let imageData = Data(base64Encoded: imageDataString),
                      let name = taskData["name"] as? String,
                      let startDateTimestamp = taskData["startDate"] as? TimeInterval,
                      let endDateTimestamp = taskData["endDate"] as? TimeInterval else {
                    print("Invalid task data for task with ID: \(taskSnapshot.key)")
                    continue
                }
                
                let startDate = Date(timeIntervalSince1970: startDateTimestamp)
                let endDate = Date(timeIntervalSince1970: endDateTimestamp)
                
                let loadedTask = Task(id: taskSnapshot.key, imageData: imageData, name: name, startDate: startDate, endDate: endDate)
                loadedTasks.append(loadedTask)
            }
            
            self.taskItems = loadedTasks
        }
    }
    
}
