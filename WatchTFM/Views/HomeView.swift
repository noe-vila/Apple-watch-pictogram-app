//
//  HomeView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI

struct HomeView: View {
    @State var taskViewModel: TaskViewModel
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
                        if isEditing {
                            Button(action: {
                                guard let index = taskViewModel.getTaskIndex(task: task) else { return }
                                taskViewModel.removeTask(index: index)
                                refreshHome.toggle()
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
                .animation(.default, value: refreshHome)
            }
        }
        .padding(.bottom, 20)
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
        }) {
            Text(isEditing ? "Hecho" : "Editar")
        })
        .navigationBarItems(leading: Button(action: {
            showInfo.toggle()
        }) {
            Text("Info")
        })
        .sheet(isPresented: $showInfo) {
            AuthorView()
        }
    }
}
