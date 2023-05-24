//
//  TaskViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published private var taskItems: [String] = []
    @State private var newItem = ""
    
    // File URL for storing the task data
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("tasks.txt")
    }
    
    init() {
        loadTasks() // Load the tasks from the file when the view model is initialized
    }
    
    func getTaskItems() -> [String] {
        return taskItems
    }
    
    func addTask(_ task: String) {
        if taskItems.contains(task) {
            let taskWithOrderedNumber = "New \(task)"
            addTask(taskWithOrderedNumber)
        } else {
            taskItems.append(task)
            saveTasks()
        }
    }
    
    func getTaskIndex(task: String) -> Int? {
        return taskItems.firstIndex(of: task)
    }
    
    func removeTask(index: Int) {
        taskItems.remove(at: index)
        saveTasks()
    }
    
    private func saveTasks() {
        let tasksString = taskItems.joined(separator: "\n")
        do {
            try tasksString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }
    
    private func loadTasks() {
        do {
            let tasksString = try String(contentsOf: fileURL, encoding: .utf8)
            let tasks = tasksString.split(separator: "\n").filter { !$0.isEmpty }
            taskItems = tasks.map { String($0) }
        } catch {
            print("Error loading tasks: \(error)")
        }
    }
}
