//
//  ContentView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 21/5/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var healthKitManager = HealthKitManager()
    @State private var imageUrl = URL(string: "https://api.arasaac.org/api/pictograms/6522?download=false")
    @State private var taskCompleted = false
    
    var body: some View {
        VStack {
            AsyncImage(url: imageUrl, content: { image in
                image
                    .resizable()
                    .background(Color.white)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }, placeholder: {
                ProgressView()
            })
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        withAnimation {
                            taskCompleted.toggle()
                        }
                    }
            )
            
            if taskCompleted {
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 25)))
                    
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 25)))
                }
                
            }
        }
        .transition(.identity)
        .animation(.easeInOut, value: taskCompleted)
        .padding()
        .onAppear {
            healthKitManager.start()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
