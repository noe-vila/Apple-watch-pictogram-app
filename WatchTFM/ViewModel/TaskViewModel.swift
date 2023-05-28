//
//  TaskViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
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
        saveTasks()
        return nil
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
        taskItems.remove(at: index)
        saveTasks()
    }
    
    private func saveTasks() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(taskItems)
            let taskItemsRef = db.collection("users").document(userId).collection("taskItems")
            let batch = db.batch()
            let taskItemsDoc = taskItemsRef.document("tasks")
            batch.setData(["data": data], forDocument: taskItemsDoc)
            batch.commit { error in
                if let error = error {
                    print("Error saving tasks: \(error)")
                } else {
                    print("Tasks saved successfully.")
                }
            }
        } catch {
            print("Error encoding tasks: \(error)")
        }
    }
    
    func loadTasks() {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        let taskItemsRef = db.collection("users").document(userId).collection("taskItems").document("tasks")
        taskItemsRef.getDocument { snapshot, error in
            if let error = error {
                print("Error loading tasks: \(error)")
                return
            }
            
            guard let snapshotData = snapshot?.data(),
                  let jsonData = snapshotData["data"] as? Data else {
                return
            }
            
            do {
                self.taskItems = try JSONDecoder().decode([Task].self, from: jsonData)
            } catch {
                print("Error decoding tasks: \(error)")
            }
        }
    }
}
