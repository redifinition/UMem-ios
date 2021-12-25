//
//  StatisticShowView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/25.
//

import SwiftUI


struct StatisticShowView: View {
    var body: some View {
        MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title")
    }
}

struct StatisticShowView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticShowView()
    }
}
