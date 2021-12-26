//
//  currentMonthView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/26.
//

import SwiftUI


struct currentMonthView: View {
    //回忆数
    @State var memoryNum :[Double] = [0,4,0,3]
    
    @State var moodNum :[Double] = [3,3,2.3,4]
    
    @State var Richness: [Double] = [2,4,5.3]
    
    @State var MoodPortionData: [Double] = [0.1,0.23,0.12,0.32,0.12,0.21]
    
    @State var TagData: [(String, Int)] = [("Social",63150), ("Study",50900), ("Travel",77550), ("Sport",79600), ("Love",92550),("Important",63150), ("Family",50900), ("Record",77550),("Birthday",1),("Diary",1)]
    
    
    @ObservedObject var dataViewModel = StatisticViewModel()
    
    let chartStyle = ChartStyle(backgroundColor: Color.white, accentColor: Color.green, secondGradientColor: Colors.BorderBlue,  textColor: Color.black, legendTextColor: Color.gray, dropShadowColor: .gray )
    
    let barStyle = ChartStyle(backgroundColor: Color.white, accentColor: Color(.sRGB, red: 87/255, green: 163/255, blue: 255/255, opacity: 0.3), secondGradientColor: Colors.DarkPurple,  textColor: Color.black, legendTextColor: Color.gray, dropShadowColor: .gray )
    
    
    @State var isLoading = true
    
    var body: some View {
        if isLoading{
            ProgressView()
                .onAppear(perform: {
                    self.dataViewModel.getStatisticsOfAMonth(){response in
                        if response == 200{
                            self.moodNum = self.dataViewModel.statistics!.moodNum
                            self.memoryNum = self.dataViewModel.statistics!.memoryNum
                            self.Richness = self.dataViewModel.statistics!.Richness
                            self.MoodPortionData = self.dataViewModel.statistics!.MoodPortionData
                            self.TagData[0].1 = self.dataViewModel.statistics!.tagData.Social
                            self.TagData[1].1 = self.dataViewModel.statistics!.tagData.Study
                            self.TagData[2].1 = self.dataViewModel.statistics!.tagData.Travel
                            self.TagData[3].1 = self.dataViewModel.statistics!.tagData.Sport
                            self.TagData[4].1 = self.dataViewModel.statistics!.tagData.Love
                            self.TagData[5].1 = self.dataViewModel.statistics!.tagData.Important
                            self.TagData[6].1 = self.dataViewModel.statistics!.tagData.Family
                            self.TagData[7].1 = self.dataViewModel.statistics!.tagData.Record
                            self.TagData[8].1 = self.dataViewModel.statistics!.tagData.Birthday
                            self.TagData[9].1 = self.dataViewModel.statistics!.tagData.Diary
                            
                            
                            isLoading = false
                        }
                    }
                })
        }else{
        VStack{
        horizontalSplit
        ScrollView{
        VStack{
            HStack{
            MultiLineChartView(data: [(memoryNum, GradientColors.orange), (moodNum, GradientColors.bluPurpl),(Richness, GradientColors.green)], title: "Total",form: ChartForm.medium)
                
                VStack{
                    HStack{
                        Image("DiscoverImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Find more data!")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                        NavigationLink(destination: {
                            
                        }, label: {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 25, height: 30)
                        })
                    }
                    Spacer()
            HStack{
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.orange)
                Text("Mem num per week")
                    .font(.custom("", fixedSize: 14))
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Spacer()
            }
            HStack{
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.purple)
                Text("Mem score per week")
                    .font(.custom("", fixedSize: 14))
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Spacer()
            }
            HStack{
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.green)
                Text("Richesss per week")
                    .font(.custom("", fixedSize: 14))                 .fontWeight(.light)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Spacer()
            }
                    BarChartView(data: ChartData(points: memoryNum), title: "Memory num", style: chartStyle, form: ChartForm.small, cornerImage:Image(systemName: "sun.min.fill"))
                }


            }.padding(.horizontal)
            horizontalSplit
            HStack{
                Image(systemName: "figure.stand.line.dotted.figure.stand")
                Text("Your Mood")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            HStack{
                VStack{
                    Text("What is Mood Portion?")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    HStack{
                    Image("moodPortion")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 90)
                        VStack{
                            HStack{
                    Text("Mood percentage shows the percentage of different moods in your memories recorded in the past period of time.")
                            .foregroundColor(.gray)
                            .font(.caption)
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                }.padding(.vertical)
                PieChartView(data: MoodPortionData,title: "Mood Portion", style: barStyle, form: ChartForm.medium)
//                BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly") // legend is optional
                
                
            }.padding(.horizontal)
            
            horizontalSplit
            HStack{
                Image(systemName: "camera.filters")
            Text("Your Tags")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.gray)
            }
            BarChartView(data: ChartData(values: TagData), title: "Tag Collections", style: Styles.barChartMidnightGreenLight, form: ChartForm.extraLarge, cornerImage: Image(systemName: "arrow.up.and.person.rectangle.portrait"))

            Spacer()
        }
        }
        }
        }
    }
    
    var horizontalSplit:some View{
        //分割框
        Rectangle()
            .fill(Color.gray)
            .opacity(0.5)
            .frame(height : 1)
    }
}

struct currentMonthView_Previews: PreviewProvider {
    static var previews: some View {
        currentMonthView()
    }
}
