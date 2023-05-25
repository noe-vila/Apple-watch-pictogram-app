//
//  ProfileView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 25/5/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var showSettings = false
    @State private var showLoginView = true
    @State private var showStatistics = false
    @State private var showLogin = true
    @StateObject var viewModel: LoginViewModel
    let images = Array(1...61)
    
    var body: some View {
        if viewModel.isProfileLoggedIn {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.purple)
                    
                    Text("Estadísticas")
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    LazyVGrid(columns: gridItems(), spacing: 20) {
                        ForEach(images, id: \.self) { image in
                            Button(action: {
                                showStatistics.toggle()
                            }) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $showStatistics) {
                                StatisticsView()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
            }
            .navigationBarItems(trailing: Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: "gear")
            })
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .onDisappear {
                viewModel.profileLogout()
            }
        } else {
            VStack {
                Spacer()
                LoginView(viewModel: viewModel)
                    .opacity(showLoginView ? 1 : 0)
                    .transition(.opacity)
                Spacer()
            }
            Spacer()
        }
    }
}

private func gridItems() -> [GridItem] {
    let spacing: CGFloat = 10
    let totalSpacing = spacing * 3
    let screenWidth = UIScreen.main.bounds.width
    let itemWidth = (screenWidth - totalSpacing) / 4
    return Array(repeating: GridItem(.fixed(itemWidth)), count: 4)
}
