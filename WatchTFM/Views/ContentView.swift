//
//  ContentView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = true
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var selectedTab = "Home"
    @State private var isEditing = false
    
    
    var body: some View {
        if isLoggedIn {
            NavigationView {
                VStack {
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
                    NavigationBarView(selectedTab: $selectedTab, taskViewModel: taskViewModel)
                        .opacity(isEditing ? 0.5 : 1.0)
                        .disabled(isEditing)
                }
                .environmentObject(taskViewModel)
                .navigationBarHidden(false)
                .navigationBarItems(trailing: Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Hecho" : "Editar")
                })
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
