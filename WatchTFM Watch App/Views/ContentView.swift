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
    
    var body: some View {
            if !loginViewModel.isLoggedIn {
                VStack {
                    Text("LoggedIn")
                    Text("\(tasknumber)")
                    Button(action: {
                        tasknumber = taskViewModel.getTotalTasks()
                    }) {
                        Text("Okay")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            } else {
                LoginView(viewModel: loginViewModel)
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
