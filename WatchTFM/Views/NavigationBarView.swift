//
//  NavigationBa.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI

struct NavigationBarView: View {
    @Binding var selectedTab: String
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(imageName: "house", selectedImageName: "house.fill", tabName: "Home", selectedTab: $selectedTab)
            Spacer()
            TabButton(imageName: "magnifyingglass.circle", selectedImageName: "magnifyingglass.circle.fill", tabName: "Search", selectedTab: $selectedTab)
            Spacer()
            TabButton(imageName: "plus.circle", selectedImageName: "plus.circle.fill", tabName: "Add", selectedTab: $selectedTab)
            Spacer()
            TabButton(imageName: "person", selectedImageName: "person.fill", tabName: "Profile", selectedTab: $selectedTab)
        }
        .padding()
        .background(NavigationBarStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TabButton: View {
    let imageName: String
    let selectedImageName: String
    let tabName: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {
            selectedTab = tabName
        }) {
            Image(systemName: selectedTab == tabName ? selectedImageName : imageName)
                .font(.system(size: 25))
                .foregroundColor(selectedTab == tabName ? Color.primary : .gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
        }
    }
}

struct NavigationBarStyle: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        EmptyView()
    }
}
