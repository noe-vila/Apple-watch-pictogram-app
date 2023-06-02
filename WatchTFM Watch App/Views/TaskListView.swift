//
//  TaskListView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 1/6/23.
//

import SwiftUI
import WatchKit

struct TaskListView: View {
    var tasks: [Task]
    var currentTaskIndex: Int
    @State private var scrollAmount = 0.0
    @State private var currentIndex = 1
    
    
    var body: some View {
        TabView(selection: $currentIndex) {
            TaskView(task: tasks[currentTaskIndex - 1])
                .tag(0)
                .ignoresSafeArea(.all)
            TaskView(task: tasks[currentTaskIndex])
                .tag(1)
                .ignoresSafeArea(.all)
            TaskView(task: tasks[currentTaskIndex + 1])
                .tag(2)
                .ignoresSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
        .tabViewStyle(.carousel)
        .animation(.default, value: currentIndex)
    }
}
