//
//  HomeView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @Binding var isEditing: Bool

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(taskViewModel.getTaskItems(), id: \.self) { task in
                    HStack {
                        TaskItemView(task: task)
                            .opacity(isEditing ? 0.5 : 1.0)
                        Spacer()

                        if isEditing {
                            Button(action: {
                                guard let index = taskViewModel.getTaskIndex(task: task) else { return }
                                withAnimation {
                                    taskViewModel.removeTask(index: index)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .frame(height: 50)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        taskViewModel.removeTask(index: index)
                    }
                }
            }
        }
        .padding(.bottom, 20)
        .navigationBarHidden(false)
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
        }) {
            Text(isEditing ? "Hecho" : "Editar")
        })
    }
}
