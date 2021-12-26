//
//  DataShowView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/26.
//

import SwiftUI

struct DataShowView: View {
    //当前选择的查看选项
    @State var currentTab = 0
    
    
    //回忆数
    @State var memoryNum :[Double] = [0,4,0,3]
    
    @State var moodNum :[Double] = [3,3,2.3,4]
    
    @State var Richness: [Double] = [2,4,5.3]
    
    @State var MoodPortionData: [Double] = [0.1,0.23,0.12,0.32,0.12,0.21]
    
    @State var TagData: [(String, Int)] = [("Social",63150), ("Study",50900), ("Travel",77550), ("Sport",79600), ("Love",92550),("Important",63150), ("Family",50900), ("Record",77550),("Birthday",1),("Diary",1)]
    
    
    @ObservedObject var dataViewModel = StatisticViewModel()
    
    let chartStyle = ChartStyle(backgroundColor: Color.white, accentColor: Color.green, secondGradientColor: Colors.BorderBlue,  textColor: Color.black, legendTextColor: Color.gray, dropShadowColor: .gray )
    
    let barStyle = ChartStyle(backgroundColor: Color.white, accentColor: Color(.sRGB, red: 87/255, green: 163/255, blue: 255/255, opacity: 0.3), secondGradientColor: Colors.DarkPurple,  textColor: Color.black, legendTextColor: Color.gray, dropShadowColor: .gray )
    
    
    var body: some View {
        VStack{
            HStack{
                Image("Statistic")
                    .resizable()
                    .frame(width: 40, height: 40)

                Spacer()
                Text("Umem Data Center")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 40, height: 40)
            }.padding(.horizontal)
            //分割框
            Rectangle()
                .fill(Color.gray)
                .opacity(0.5)
                .frame(height : 0.5)
            Picker(selection: $currentTab, label: Text("")){
                Text("Last Month")
                    .tag(0)
                Text("Last six Months")
                    .tag(1)
                Text("Last Year")
                    .tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if currentTab == 0{
                currentMonthView()
            }
            if currentTab == 1{
                currentHalfYearView()
            }
            if currentTab == 2{
                currentYearView()
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct DataShowView_Previews: PreviewProvider {
    static var previews: some View {
        DataShowView()
    }
}



