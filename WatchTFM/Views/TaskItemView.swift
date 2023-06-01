//
//  TaskItemView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 23/5/23.
//

import SwiftUI

struct TaskItemView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var task: Task
    
    var body: some View {
        
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.gray, lineWidth: 4)
                    .frame(width: 75, height: 75)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(colorScheme == .light ? Color.clear : Color.primary))
                Image(uiImage: UIImage(data: Data(base64Encoded: task.imageData) ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            Text(task.name)
            Spacer()
            VStack {
                Text("\(formattedTime(task.startDate))")
                Text("\(formattedTime(task.endDate))")
            }
            
            Image(systemName: "clock")
                .frame(width: 20, height: 20)
        }
        .padding()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}
