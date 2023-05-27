//
//  TaskView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 27/5/23.
//

import SwiftUI

struct TaskView: View {
    var task: Task
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.gray, lineWidth: 4)
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.white.opacity(0.8)))
            VStack {
                Image(uiImage: UIImage(data: task.imageData) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                Text(task.name)}
        }
        .scenePadding(.all)
    }
    
}
