//
//  TaskViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI

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
    
    func addTask(_ task: Task) {
        if let insertIndex = taskItems.firstIndex(where: { $0.startDate > task.startDate }) {
            taskItems.insert(task, at: insertIndex)
        } else {
            taskItems.append(task)
        }
        saveTasks()
    }
    
    func getTaskIndex(task: Task) -> Int? {
        return taskItems.firstIndex { $0 == task }
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
