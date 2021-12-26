//
//  StatisticShowView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/25.
//

import SwiftUI


struct StatisticShowView: View {
    let chartStyle = ChartStyle(backgroundColor: Color.black, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd,  textColor: Color.white, legendTextColor: Color.white, dropShadowColor: .gray )
    
//    barChartStyleOrangeLight
//    barChartStyleOrangeDark
//    barChartStyleNeonBlueLight
//    barChartStyleNeonBlueDark
//    barChartMidnightGreenLight
//    barChartMidnightGreenDark
    var body: some View {
        ScrollView{
        VStack{
       MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title", legend: "1213")
            
            LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
                .padding()// legend is optional, use optional .padding()
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title",legend: "Legendary", rateValue: 0) // legend is optional
            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", style:self.chartStyle, form: ChartForm.small,cornerImage:Image(systemName: "waveform.path.ecg"))
            PieChartView(data: [8,23,54,32], title: "Title", legend: "Legendary") // legend is optional
    }
        }
    }
}

struct StatisticShowView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticShowView()
    }
}
