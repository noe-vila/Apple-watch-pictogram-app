//
//  TaskView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 27/5/23.
//

import SwiftUI


struct TaskRoundedView: View {
    var task: Task
    @State private var progress: Double = 0
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: Data(base64Encoded: task.imageData) ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFill()
                .padding(.all)
                .clipShape(Circle())
            Circle()
                .stroke(Color.black, lineWidth: 15)
            Circle()
                .stroke(Color(UIColor.decodeFromData(Data(base64Encoded: task.avgColorData) ?? Data()) ?? UIColor.white).opacity(0.5), lineWidth: 15)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(UIColor.decodeFromData(Data(base64Encoded: task.avgColorData) ?? Data()) ?? UIColor.white),
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
        .onAppear() {
            progress = calculateTimePercentage(initial: task.startDate, end: task.endDate)
        }
        .onDisappear() {
            progress = 0
        }
        .scaledToFill()
        .padding()
    }
    
    private func calculateTimePercentage(initial: Date, end: Date) -> Double {
        let calendar = Calendar.current
        
        let initialComponents = calendar.dateComponents([.hour, .minute, .second], from: initial)
        let initialTime = calendar.date(from: initialComponents)!
        
        let endComponents = calendar.dateComponents([.hour, .minute, .second], from: end)
        let endTime = calendar.date(from: endComponents)!
        
        let currentComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
        let currentTime = calendar.date(from: currentComponents)!
        
        let totalTimeInterval = endTime.timeIntervalSince(initialTime)
        let passedTimeInterval = currentTime.timeIntervalSince(initialTime)
        
        if totalTimeInterval > 0 && passedTimeInterval >= 0 {
            let percentage = passedTimeInterval / totalTimeInterval
            return min(percentage, 1.0)
        }
        
        return 0
    }
}
