//
//  HomeView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/5.
//

import SwiftUI

struct HomeView: View {
    @Binding var showMenu:Bool
    
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
                    .frame(width: 50, height:50)
            )
            Spacer()
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
