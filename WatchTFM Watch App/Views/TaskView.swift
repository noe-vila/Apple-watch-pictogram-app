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
        VStack {
            Image(uiImage: UIImage(data: Data(base64Encoded: task.imageData) ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFit()
            Text(task.name)
        }
        .frame(width: .infinity, height: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}
