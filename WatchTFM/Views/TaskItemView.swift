//
//  TaskItemView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI

struct TaskItemView: View {
    var task: Task
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 75, height: 75)
                    .foregroundColor(Color.gray.opacity(0.2))
                Image(uiImage: UIImage(data: task.imageData) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            Text(task.name)
        }
        .padding()
    }
}
