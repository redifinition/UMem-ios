//
//  SideMenu.swift
//  UMem
//
//  Created by Jwy John on 2021/12/5.
//

import SwiftUI

struct SideMenu: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            
            
            VStack(alignment: .leading, spacing: 14){
                
                //头像和核心信息
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                
                Text("Redefinition")
                    .font(.title2.bold())
                
                Text("19921305202@163.com")
                    .font(.callout)
                
                HStack(spacing: 12){
                    Button{
                        
                    } label:{
                        Label{
                            Text("days")
                        } icon:{
                            Text("18")
                                .fontWeight(.bold)
                        }
                    }
                    
                    Button{
                        
                    } label:{
                        Label{
                            Text("memories")
                        } icon:{
                            Text("5")
                                .fontWeight(.bold)
                        }
                    }
                }
                .foregroundColor(.primary)
                    
                
            }
            .padding(.horizontal)
            .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack{
                VStack(alignment: .leading, spacing:45){
                    
                    
                    //可供选择的按钮
                    TabButton(title: "Create A New Memory", image:Image(systemName: "memories.badge.plus"))
                    
                    TabButton(title: "Me", image:Image(systemName: "person.fill"))

                    TabButton(title: "My Memories", image:Image(systemName: "heart.text.square"))

                    TabButton(title: "Settings", image:Image("设置"))

                    TabButton(title: "Instructions", image:Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                    
                    TabButton(title: "Statistics", image:Image(systemName: "waveform.path.ecg.rectangle"))
                    

                    

                }
                .padding()
                .padding(.leading)
                .padding(.top,35)
                    
                    
                Divider()
                    
                TabButton(title: "About the app", image:Image(systemName: "person.crop.square.fill.and.at.rectangle"))
                        .padding()
                        .padding(.leading)
                    
                    
                
                    
                }


                Divider()
                
                
                TabButton(title: "Exit", image:Image("进入"))
                    .padding()
                    .padding(.leading)
                
            }
            
            
            VStack(spacing:0){
                Divider()
                HStack{
                    
                    Button{
                        
                    } label:{
                        Image("memory")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio( contentMode: .fill)
                            .frame(width: 40, height: 40)
                    }
                    Spacer()
                    Text("Start to find your memories!")
                        .fontWeight(.medium)
                        .italic()
                        .lineLimit(1)
                    
                }
                .padding([.horizontal,.top],15)
                .foregroundColor(.primary)
            }
                    
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity,alignment: .leading)

        //get max width
        .frame(width: getRect().width-90)
        .frame(maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.04)
                .ignoresSafeArea(.container,edges: .vertical)
        )
        .frame(maxWidth: .infinity,alignment: .leading)
    
    }
    
    
    //产生侧边窗口的一系列选项按钮，使用函数创建view
    @ViewBuilder
    func TabButton(title:String,image:Image)->some View{
        
        NavigationLink{
            // 目前默认全部跳转到home页面
            HomeView(showMenu: $showMenu)
            
        } label:{
            HStack(spacing: 14){
                
                image
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio( contentMode: .fill)
                    .frame(width: 22, height: 22)
                    
                
                Text(title)
                    .fontWeight(.bold)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading )
        }
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
