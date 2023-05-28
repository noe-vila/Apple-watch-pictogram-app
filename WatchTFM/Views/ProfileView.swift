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
    @StateObject var viewModel: LoginViewModel
    @StateObject var taskViewModel: TaskViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShowingStatisticsIcon = false
    
    var body: some View {
        if viewModel.isProfileLoggedIn  {
            VStack(spacing: 8) {
                HStack {
                    if isShowingStatisticsIcon {Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.primary)
                    }
                    
                    Text("Estadísticas".uppercased())
                        .font(.headline)
                        .frame(height: 30)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            isShowingStatisticsIcon = true
                        }
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: gridItems(), spacing: 20) {
                        ForEach(taskViewModel.getAlphabeticalTaskItems(), id: \.self) { task in
                            Button(action: {
                                showStatistics.toggle()
                            }) {
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(Color.gray, lineWidth: 4)
                                            .frame(width: 75, height: 75)
                                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.white.opacity(0.8)))
                                        Image(uiImage: UIImage(data: task.imageData) ?? UIImage())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                    Text(task.name)
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                }
                            }
                            .sheet(isPresented: $showStatistics) {
                                StatisticsView()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: "gear")
                    .foregroundColor(Color.primary)
                    .rotationEffect(.degrees(showSettings ? 180 : 0))
                    .animation(.easeInOut, value: showSettings)
            }
            )
            .sheet(isPresented: $showSettings) {
                SettingsView(showSettings: $showSettings, viewModel: viewModel)
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
