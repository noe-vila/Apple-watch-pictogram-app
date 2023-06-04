//
//  TaskView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 27/5/23.
//

import SwiftUI

struct TaskView: View {
    @State var task: Task
    @State var shouldPresentActions = false
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        let currentTask = taskViewModel.getCurrentTask()
        NavigationView {
            TaskRoundedView(task: task)
                .navigationBarHidden(true)
                .onLongPressGesture(minimumDuration: 1) {
                    if task == currentTask {
                        shouldPresentActions = true
                    }
                }
                .sheet(isPresented: $shouldPresentActions, onDismiss: {
                    shouldPresentActions = false
                }) {
                    ActionsView(task: $task, shouldPresentActions: $shouldPresentActions)
                }
        }
    }
}
