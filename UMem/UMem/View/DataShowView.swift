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
                Text("最近一个月")
                    .tag(0)
                Text("最近半年")
                    .tag(1)
                Text("最近一年")
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
    }
}

struct DataShowView_Previews: PreviewProvider {
    static var previews: some View {
        DataShowView()
    }
}



