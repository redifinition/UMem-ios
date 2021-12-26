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



