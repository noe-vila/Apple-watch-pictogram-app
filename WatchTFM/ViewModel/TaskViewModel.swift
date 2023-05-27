//
//  TaskViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI
import WatchConnectivity


class TaskViewModel: ObservableObject {
    @Published private var taskItems: [Task] = []
    
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("tasks.json")
    }
    
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
        do {
            let data = try JSONEncoder().encode(taskItems)
            try data.write(to: fileURL)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }
    
    private func loadTasks() {
        do {
            let data = try Data(contentsOf: fileURL)
            taskItems = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Error loading tasks: \(error)")
        }
    }
}
