//
//  ContentView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var isEditing = false
    @State private var selectedTab: String = "Home"
    @State private var isPresentingAddView = false
    @State private var selectedImage: UIImage? = nil
    @State private var refreshHome: Bool = false
    
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        NavigationView {
            if loginViewModel.isLoggedIn {
                VStack {
                    if selectedTab == "Home" || selectedTab == "Add" {
                        HomeView(taskViewModel: taskViewModel, isEditing: $isEditing, refreshHome: $refreshHome)
                            .animation(.default, value: isEditing)
                    } else if selectedTab == "Search" {
                        SearchView(viewModel: searchViewModel, onImageSelected: { pictogramResult in
                            selectedImage = pictogramResult.image
                        })
                    } else if selectedTab == "Profile" {
                        ProfileView(viewModel: loginViewModel, taskViewModel: taskViewModel)
                            .onAppear {
                                loginViewModel.profileLogout()
                            }
                            .onDisappear {
                                selectedTab = "Home"
                            }
                    } else {
                        Spacer()
                    }
                    NavigationBarView(selectedTab: $selectedTab)
                        .opacity(isEditing ? 0.5 : 1.0)
                        .animation(.default, value: isEditing)
                        .disabled(isEditing)
                }
                .alert(item: $connectivityManager.notificationMessage) { message in
                    Alert(title: Text(message.text),
                          dismissButton: .default(Text("Dismiss")))
               }

                .environmentObject(taskViewModel)
                .navigationBarHidden(false)
                .sheet(isPresented: $isPresentingAddView, onDismiss: {
                    selectedTab = "Home"
                    WatchConnectivityManager.shared.send("Hello from the phone")
                }) {
                    AddView(taskViewModel: taskViewModel,
                            isPresentingAddView: $isPresentingAddView,
                            refreshHome: $refreshHome)
                }
                .onChange(of: selectedTab) { newTab in
                    isPresentingAddView = newTab == "Add"
                }
                .onAppear(){
                    taskViewModel.loadTasks()
                }
            } else {
                LoginView(viewModel: loginViewModel)
                    .navigationBarHidden(false)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
