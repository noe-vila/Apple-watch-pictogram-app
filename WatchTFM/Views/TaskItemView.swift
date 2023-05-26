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
                    .strokeBorder(Color.gray, lineWidth: 4)
                    .frame(width: 75, height: 75)
                    .background(Circle().foregroundColor(Color.white.opacity(0.8)))
                Image(uiImage: UIImage(data: task.imageData) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            Text(task.name)
            Spacer()
            Text("\(formattedTime(task.startDate))")
            Text(" - ")
            Text("\(formattedTime(task.endDate))")
        }
        .padding()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}
