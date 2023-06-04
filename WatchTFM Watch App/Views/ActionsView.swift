//
//  ActionsView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 4/6/23.
//

import SwiftUI

struct ActionsView: View {
    @Binding var task: Task
    @Binding var shouldPresentActions: Bool
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .onTapGesture {
                        taskViewModel.finishTask(task: task, isSuccess: false)
                        taskViewModel.setTaskDone(task: task)
                        task.taskTodayDone = true
                        shouldPresentActions = false
                    }

                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green)
                    .onTapGesture {
                        taskViewModel.finishTask(task: task, isSuccess: true)
                        taskViewModel.setTaskDone(task: task)
                        task.taskTodayDone = true
                        shouldPresentActions = false
                    }
                
            }
            
            HStack(spacing: 20) {
                
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.purple)
    
                Image(systemName: "arrow.uturn.down.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .onTapGesture {
                        shouldPresentActions = false
                    }
            }
        }
        .navigationTitle("Acciones".uppercased())
        .padding(.top)
    }
}
