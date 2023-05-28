//
//  HomeView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var showInfo = false
    @Binding var isEditing: Bool
    @Binding var refreshHome: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(taskViewModel.getTaskItems(), id: \.self) { task in
                    HStack {
                        TaskItemView(task: task)
                            .opacity(isEditing ? 0.5 : 1.0)
                            .animation(.default, value: isEditing)
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
                            .transition(.scale)
                        }
                    }
                }
            }
            .animation(.default, value: refreshHome)
        }
        .padding(.bottom, 20)
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
        }) {
            Image(systemName: isEditing ? "checkmark.diamond.fill" : "pencil")
                .rotationEffect(.degrees(isEditing ? 360 : 0))
                .animation(.easeInOut, value: isEditing)
                .foregroundColor(Color.primary)
        })
        .navigationBarItems(leading: Button(action: {
            showInfo.toggle()
        }) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(Color.primary)
        })
        .sheet(isPresented: $showInfo) {
            AuthorView()
        }
        .onReceive(taskViewModel.objectWillChange) { _ in
            refreshHome.toggle()
        }
    }
}
