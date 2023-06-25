//
//  StatisticsView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 25/5/23.
//

import SwiftUI
import SwiftUICharts

struct StatisticsView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var task: Task
    
    var body: some View {
        let randomCompletada = Int.random(in: 50..<100)
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: ChartForm.medium.width, height: ChartForm.medium.height)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(colorScheme == .light ? Color.clear : Color.primary))
                    Image(uiImage: UIImage(data: Data(base64Encoded: task.imageData) ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: ChartForm.medium.width - 10, height: ChartForm.medium.height - 10)
                }
                Spacer()
                VStack {
                    Text(task.name).font(.title)
                    Image(systemName: "clock")
                        .frame(width: 20, height: 20)
                    Text("\(formattedTime(task.startDate))")
                    Text("\(formattedTime(task.endDate))")
                }
                Spacer()
            }
            HStack{
                BarChartView(data: ChartData(values: [
                    ("Tiempo usado", Int.random(in: 75..<100)),
                    ("Completada", randomCompletada),
                    ("Incompleta", 100 - randomCompletada)
                ]), title: "Porcentajes", gradientColor: GradientColor.init(start: Color(UIColor.decodeFromData(Data(base64Encoded: task.avgColorData) ?? Data()) ?? UIColor.white), end: .white), form: ChartForm.medium, dropShadow: false, cornerImage: Image(systemName: "chart.bar.xaxis"))
                
                LineChartView(data: [Double.random(in: 0...10),Double.random(in: 0...10),Double.random(in: 0...10),Double.random(in: 0...10),Double.random(in: 0...10),1,0,0], title: "Nº veces ayuda consultada", form: ChartForm.medium, dropShadow: false, gradient: GradientColor.init(start: Color(UIColor.decodeFromData(Data(base64Encoded: task.avgColorData) ?? Data()) ?? UIColor.white), end: .white))
            }
        }
        .padding()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
}
