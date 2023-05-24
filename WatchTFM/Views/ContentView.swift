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
    @State private var isEditing = false
    @State private var selectedTab: String = "Home"
    @State private var isPresentingAddView = false
    
    var body: some View {
        if isLoggedIn {
            NavigationView {
                VStack {
                    if selectedTab == "Home" || selectedTab == "Add" {
                        HomeView(isEditing: $isEditing)
                    } else if selectedTab == "Search" {
                        SearchView()
                    } else if selectedTab == "Profile" {
                        //ProfileView
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
