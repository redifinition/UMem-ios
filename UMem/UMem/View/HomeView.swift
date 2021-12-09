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
    
    var body: some View {
            
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
                        .padding(.horizontal)
            Text(Date().addingTimeInterval(600),style: .date)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading)
            }
            
                
                
            // 用户的名字
            Text("Hello,\(userName)")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .font(.title3)
                    
            }
                   .frame(maxWidth: .infinity, alignment: .leading )
            Spacer()
            //点击添加回忆的按钮
            NavigationLink(destination: {
                CameraCapturingView()
            }, label: {
                Image(systemName: "pencil")
            })
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
