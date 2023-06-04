//
//  ContentView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var healthKitManager = HealthKitManager()
    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var refreshHome = false
    
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        if loginViewModel.isLoggedIn {
            if taskViewModel.isLoading {
                ProgressView()
            } else {
                TaskListView()
//                TaskView(task: taskViewModel.getCurrentTask() ?? Task())
//                    .alert(item: $connectivityManager.notificationMessage) { message in
//                        Alert(title: Text(message.text),
//                              dismissButton: .default(Text("Dismiss")))
//                    }
            }
        } else {
            LoginView(viewModel: loginViewModel, refreshHome: $refreshHome)
        }
    }
}
