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
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var tasknumber = -1
    @State private var refreshHome = false
    
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
            if !loginViewModel.isLoggedIn {
                VStack {
                    Text("LoggedIn")
                    Text("\(tasknumber)")
                    Button(action: {
                        WatchConnectivityManager.shared.send("Hello from the watch")
                    }) {
                        Text("Okay")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .alert(item: $connectivityManager.notificationMessage) { message in
                Alert(title: Text(message.text),
                      dismissButton: .default(Text("Dismiss")))
           }
            } else {
                LoginView(viewModel: loginViewModel, refreshHome: $refreshHome)
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
