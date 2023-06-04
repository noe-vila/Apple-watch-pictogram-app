//
//  ActionsView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 4/6/23.
//

import SwiftUI

struct ActionsView: View {
    var task: Task
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)

                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green)
                
            }
            
            HStack(spacing: 20) {
                
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.purple)
    
                Image(systemName: "arrow.uturn.down.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Acciones".uppercased())
        .padding(.top)
    }
}
