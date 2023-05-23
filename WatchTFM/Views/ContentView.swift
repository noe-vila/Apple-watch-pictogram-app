//
//  ContentView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI

struct ContentView: View {
    @State private var taskItems = ["Elemento 1", "Elemento 2", "Elemento 3"]
    @State private var newItem = ""
    @State private var isLoggedIn = true
    @State private var selectedTab = "Home"

    var body: some View {
        if isLoggedIn {
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(taskItems, id: \.self) { task in
                                TaskItemView(task: task)
                            }
                        }
                    }
                    .padding(.bottom, 20)

                    NavigationBarView(selectedTab: $selectedTab)
                }
                .navigationBarHidden(true)
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

struct TaskItemView: View {
    var task: String
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
            Text(task)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
