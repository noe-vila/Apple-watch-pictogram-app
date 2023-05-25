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
    @State private var isEditing = false
    @State private var selectedTab: String = "Home"
    @State private var isPresentingAddView = false
    
    var body: some View {
        NavigationView {
            if loginViewModel.isLoggedIn {
                
                VStack {
                    if selectedTab == "Home" || selectedTab == "Add" {
                        HomeView(isEditing: $isEditing)
                    } else if selectedTab == "Search" {
                        SearchView()
                    } else if selectedTab == "Profile" {
                        ProfileView(viewModel: loginViewModel)
                            .onAppear {
                                loginViewModel.profileLogout()
                            }
                    }
                    NavigationBarView(selectedTab: $selectedTab)
                        .opacity(isEditing ? 0.5 : 1.0)
                        .disabled(isEditing)
                }
                .environmentObject(taskViewModel)
                .navigationBarHidden(false)
                .sheet(isPresented: $isPresentingAddView, onDismiss: {
                    selectedTab = "Home"
                }) {
                    AddView()
                }
                .onChange(of: selectedTab) { newTab in
                    isPresentingAddView = newTab == "Add"
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
