//
//  HomeView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/5.
//

import SwiftUI

struct HomeView: View {
    @Binding var showMenu:Bool
    
    @State var userName:String = "Redefinition"
    
    var randomSentence:[String] = ["May there be enough clouds in your life to make a beautiful sunset.","Life is like a box of chocolates, you never know what you are going to get.","Life is like a box of chocolates, you never know what you are going to get.","The best and most beautiful things in the world cannot be seen or even touched, they must be felt with heart.","The value of life lies not length of days, but in the use of we make of them."," Courage is the ladder on which all the other virtues mount.","We have to dare to be ourselves, however frightening or strange that self may prove to be.","Only you can control your future."]
    
    //卡片展示
    @State var showCard = false
    
    var randomNum = Int.random(in: 0...8)
    
    var body: some View {
            
        ZStack {
            //背景
            Color(.sRGB, red: 224/255, green: 228/255, blue: 236/255, opacity: 1)
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack(spacing: 0){
                //主页的顶栏
                HStack{
                    //头像
                    Button{
                        
                        withAnimation{showMenu.toggle()}
                    } label:{
                        Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                    }
                    Spacer()
                    
                    NavigationLink {
                        
                        Text("还没想好做啥")
                            .navigationTitle("还没想好做啥")
                         
                    } label: {
                        Image(systemName: "cloud")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,10)
                    
                Divider()
                }
                .overlay(
                    Image("logo")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 40, height:40)
                )
                //Spacer()
                VStack(alignment: .leading,
                       spacing:6){
                HStack{
                Image("Date")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(width: 50, height:50)
                Text(Date().addingTimeInterval(600),style: .date)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    Spacer()
                }.padding(.horizontal)
                
                    
                    
                // 用户的名字
                Text("Hello,\(userName)")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.leading)
                        .font(.title3)
                        
                }
                       .frame(maxWidth: .infinity, alignment: .leading )
                Spacer()
                
                
                //开始界面欢迎卡片
                    ZStack{
                        WelcomeCardViewTwo
                            .offset(x: 100)
                        WelcomeCardViewOne
                            .shadow(color: Color(.sRGB, red: 17/255, green: 82/255, blue: 197/255, opacity: 1), radius: showCard ? 100 :40, x:0,y:showCard ? 100 : 20)
                    }.onTapGesture {
                        <#code#>
                    }
                
                Spacer()
                //点击添加回忆的按钮
                NavigationLink(destination: {
                    CameraCapturingView()
                }, label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 50, height: 50)
                })
                
            }
        }
    }
    

    
    var WelcomeCardViewOne: some View{
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(.sRGB, red: 230/255, green: 230/255, blue: 230/255, opacity: 1))
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 1))
            Image("DiaryImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Start recording today's life!")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Click the button below!")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Text(randomSentence[randomNum])
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        //.layoutPriority(100)
         
                        Spacer()
                    }
                    .padding()

                }

            }
        }
        .cornerRadius(10)
        .padding([.top, .horizontal,.bottom],30)
        .shadow(color: .gray, radius: 20, x: 5, y: 5)
    }
    
    var WelcomeCardViewTwo: some View{
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.sRGB, red: 230/255, green: 230/255, blue: 230/255, opacity: 1))
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundColor(Color(.sRGB, red: 200/255, green: 200/255, blue: 200/255, opacity: 1))
            Image("DiaryImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Start recording today's life!")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Click the button below!")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Text(randomSentence[randomNum])
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        //.layoutPriority(100)
         
                        Spacer()
                    }
                    .padding()

                }

            }
        }
        .cornerRadius(10)
        .padding([.top, .horizontal,.bottom],30)
        .shadow(color: .gray, radius: 20, x: 5, y: 5)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
