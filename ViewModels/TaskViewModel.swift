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
    let baseURL = "https://pictowatch-95035-default-rtdb.europe-west1.firebasedatabase.app"
    var isLoading: Bool = false
    
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
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            return
        }
        user.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
              print("Error with user token: \(error)")
            return;
          }
            guard let idToken = idToken else { return }
            let endpoint = "/users/\(user.uid)/taskItems.json?auth=\(idToken)"
            let url = URL(string: self.baseURL + endpoint)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let taskData: [String: Any] = [
                "imageData": task.imageData,
                "name": task.name,
                "startDate": task.startDate.timeIntervalSince1970,
                "endDate": task.endDate.timeIntervalSince1970,
                "avgColorData": task.avgColorData
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: taskData)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error saving task: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    print("Task saved successfully.")
                } else {
                    print("Error saving task: \(response!)")
                }
            }
            
            task.resume()
        }
        
    }
    
    func getTaskIndex(task: Task) -> Int? {
        return taskItems.firstIndex { $0 == task }
    }
    
    func getCurrentTask() -> Task? {
        let calendar = Calendar.current
        let currentTime = Date()
        var currentComponents = calendar.dateComponents([.hour, .minute, .second], from: currentTime)
        currentComponents.year = 2000
        currentComponents.month = 1
        currentComponents.day = 1
        let currentComponentsHMS = calendar.date(from: currentComponents)!
        let task = taskItems.first(where: { $0.startDate <= currentComponentsHMS && $0.endDate >= currentComponentsHMS })
        return task
    }
    
    func getNextTask() -> Task? {
        let calendar = Calendar.current
        let currentTime = Date()
        var currentComponents = calendar.dateComponents([.hour, .minute, .second], from: currentTime)
        currentComponents.year = 2000
        currentComponents.month = 1
        currentComponents.day = 1
        let currentComponentsHMS = calendar.date(byAdding: .second, value: 1, to: calendar.date(from: currentComponents)!)!
        let task = taskItems.first(where: { $0.startDate > currentComponentsHMS })
        return task
    }
    
    func getCurrentTaskIndex() -> Int? {
        guard let task = getCurrentTask() else { return nil }
        if let index = getTaskIndex(task: task) {
            return index
        } else {
            return nil
        }
    }
    
    func getNextTaskIndex() -> Int? {
        guard let task = getNextTask() else { return 0 }
        if let index = getTaskIndex(task: task) {
            return index
        } else {
            return nil
        }
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
        let myTask = taskItems[index]
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            return
        }
        user.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print("Error with user token: \(error)")
                return;
            }
            guard let idToken = idToken else { return }
            let endpoint = "/users/\(user.uid)/taskItems/\(myTask.id).json?auth=\(idToken)"
            let url = URL(string: self.baseURL + endpoint)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error removing task with ID \(myTask.id): \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    DispatchQueue.main.async {
                        self.taskItems.remove(at: index)
                        print("Task with ID \(myTask.id) removed successfully.")
                    }
                } else {
                    print("Error removing task with ID \(myTask.id): \(response!)")
                }
            }
            
            task.resume()
        }
    }
    
    
    func loadTasks() {
        isLoading = true
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            isLoading = false
            return
        }
        user.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print("Error with user token: \(error)")
                self.isLoading = false
                return;
            }
            guard let idToken = idToken else { return }
            let endpoint = "/users/\(user.uid)/taskItems.json?auth=\(idToken)"
            let url = URL(string: self.baseURL + endpoint)!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error loading tasks: \(error)")
                    self.isLoading = false
                    return
                }
                
                guard let data = data else {
                    print("No data received.")
                    self.isLoading = false
                    return
                }
                
                do {
                    let taskData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    var loadedTasks: [Task] = []
                    
                    taskData?.forEach { taskId, taskInfo in
                        guard let taskInfo = taskInfo as? [String: Any],
                              let imageDataString = taskInfo["imageData"] as? String,
                              let imageData = Data(base64Encoded: imageDataString),
                              let name = taskInfo["name"] as? String,
                              let startDateTimestamp = taskInfo["startDate"] as? TimeInterval,
                              let endDateTimestamp = taskInfo["endDate"] as? TimeInterval,
                              let avgColorDataString = taskInfo["avgColorData"] as? String,
                              let avgColorData = Data(base64Encoded: avgColorDataString) else {
                            print("Invalid task data for task with ID: \(taskId)")
                            self.isLoading = false
                            return
                        }
                        
                        let startDate = Date(timeIntervalSince1970: startDateTimestamp)
                        let endDate = Date(timeIntervalSince1970: endDateTimestamp)
                        
                        let loadedTask = Task(id: taskId, imageData: imageData, name: name, startDate: startDate, endDate: endDate, avgColorData: avgColorData)
                        loadedTasks.append(loadedTask)
                    }
                    loadedTasks.sort { $0.startDate < $1.startDate }
                    DispatchQueue.main.async {
                        self.taskItems = loadedTasks
                        self.isLoading = false
                        print("Tasks loaded successfully.")
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        print("Error parsing task data: \(error)")
                    }
                }
            }
            
            task.resume()
        }
    }

    
}
