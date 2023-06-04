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
        NavigationView {
            TaskRoundedView(task: task)
                .navigationBarHidden(true)
        }
    }
}
