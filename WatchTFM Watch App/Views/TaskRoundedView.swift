//
//  TaskView.swift
//  WatchTFM Watch App
//
//  Created by Noe Vila Muñoz on 27/5/23.
//

import SwiftUI


struct TaskRoundedView: View {
    var task: Task
    
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    
    let durationAndDelay : CGFloat = 0.3
    
    //MARK: Flip Card Function
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    //MARK: View Body
    var body: some View {
        ZStack {
            frontCoinView(task: task, degree: $backDegree, progress: 0)
            backCoinView(task: task, degree: $frontDegree, progress: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onTapGesture {
            flipCard ()
        }
    }
}

struct frontCoinView: View {
    var task: Task
    @Binding var degree : Double
    @State var progress: Double
    
    
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
            progress = task.taskTodayDone ? 1 : calculateTimePercentage(initial: task.startDate, end: task.endDate)
        }
        .scaledToFill()
        .padding()
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct backCoinView: View {
    var task: Task
    @Binding var degree : Double
    @State var progress: Double
    
    var body: some View {
        ZStack {
            VStack {
                Text(task.name.uppercased())
                    .frame(width: 100, height: 80)
                Image(systemName: "clock")
                    .frame(width: 20, height: 20)
                Text("\(formattedTime(task.startDate))")
                Text("\(formattedTime(task.endDate))")
            }
            .padding()
            .scaledToFit()
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
            progress = task.taskTodayDone ? 1 : calculateTimePercentage(initial: task.startDate, end: task.endDate)
        }
        .scaledToFill()
        .padding()
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
