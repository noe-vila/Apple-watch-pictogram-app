//
//  TaskView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 27/5/23.
//

import SwiftUI

struct TaskView: View {
    var task: Task
    @State var shouldPresentActions = false
    
    var body: some View {
        NavigationView {
            TaskRoundedView(task: task)
                .navigationBarHidden(true)
                .onLongPressGesture(minimumDuration: 1) {
                    shouldPresentActions = true
                }
                .sheet(isPresented: $shouldPresentActions, onDismiss: {
                    shouldPresentActions = false
                }) {
                    ActionsView(task: task)
                }
        }
    }
}
