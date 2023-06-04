//
//  TaskListView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 1/6/23.
//

import SwiftUI
import WatchKit

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var currentIndex: Int = 0
    @State private var initialIndex: Int = 0
    
    
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
        .onAppear {
            currentIndex = taskViewModel.getCurrentTaskIndex() ?? taskViewModel.getNextTaskIndex() ?? taskViewModel.getTaskItems().count - 1
            initialIndex = currentIndex
        }
    }
}
