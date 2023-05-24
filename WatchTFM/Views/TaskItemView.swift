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
            Circle()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
            Text(task.name)
        }
        .padding()
    }
}
