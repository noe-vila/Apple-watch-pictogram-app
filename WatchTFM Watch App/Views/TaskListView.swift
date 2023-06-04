//
//  TaskListView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 1/6/23.
//

import SwiftUI
import WatchKit

struct TaskListView: View {
    var taskViewModel: TaskViewModel
    @State private var currentIndex: Int
    @State private var initialIndex: Int
    
    init(taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
        _currentIndex = State(initialValue: taskViewModel.getCurrentTaskIndex() ?? taskViewModel.getNextTaskIndex() ?? taskViewModel.getTaskItems().count - 1)
        _initialIndex = _currentIndex
    }
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(taskViewModel.getTaskItems().enumerated()), id: \.1.self) { index, task in
                TaskView(task: task)
                    .tag(index)
                    .ignoresSafeArea(.all)
                    .opacity(index < initialIndex ? 0.5 : 1)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(.carousel)
        .animation(.default, value: currentIndex)
    }
}
