//
//  MemHomePage.swift
//  UMem
//
//  Created by Jwy John on 2021/12/5.
//

import SwiftUI

struct MemHomePage: View {
    @State var showMenu: Bool = false//默认侧边栏不显示
    
    //Hidding native one...
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    //最开始默认在增加新的回忆页面
    
    @State var currentTabValue = "addition"
    
    //offset for both drag gesture and showing menu.
    @State var offset:CGFloat = 0
    @State var lastStoredOffset:CGFloat = 0
    
    //手势操作的坐标偏移
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        
        let sideBarWidth = getRect().width - 90
        //whole navigation view
        NavigationView{
            HStack(spacing:0){
                //side menu
                SideMenu(showMenu: $showMenu)
                
                //main tab view
                VStack(spacing: 0){
                    TabView(selection: $currentTabValue){
                        
                        MemoryList()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("View")
                        
                        HomeView(showMenu: $showMenu)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("addition")
                        
                        StatisticShowView()
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarHidden(true)
                            .tag("discover")
                        
                    }
                    VStack(spacing:0){
                    Divider()
                    //Custome Tab Bar
                    HStack(spacing:0){
                        
                        //Tab buttons
                        CreateTabButton(image: "View")
                        
                        CreateTabButton(image: "addition")
                       
                        
                        CreateTabButton(image: "discover")
                    }
                    .padding([.top],15)
                    }
                    
                }
                .frame(width: getRect().width)
                // the background when the menu is showing
                .overlay(
                    Rectangle()
                        .fill(
                            Color.primary
                                .opacity(Double((offset / sideBarWidth / 5)))
                            

                            
                        
                        )
                        .ignoresSafeArea(.container, edges: .vertical)
                        .onTapGesture {
                            withAnimation{
                                showMenu.toggle()
                            }

                        }
                )
            }
            //max Size
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset)
            //手势
//            .gesture(
//                DragGesture()
//                    .updating($gestureOffset, body: { value, out,_ in
//                        out = value.translation.width
//                    })
//                    .onEnded(onEnd(value:))
//            
//            )
            //no navigation bar title
            //hidding navigation bar
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .animation(.easeOut, value: offset == 0)
        .onChange(of: showMenu){newValue in
            if showMenu && offset == 0{
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth{
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: gestureOffset){newValue in
            onChange()
        }
    }
    
    func onChange(){
        let sideBarWidth = getRect().width - 90
        
        offset = (gestureOffset != 0) ? (gestureOffset < sideBarWidth ? gestureOffset : offset) : offset
    }
    
    func onEnd(value: DragGesture.Value){
        
        let sideBarWidth = getRect().width - 90
            
        
        let translation = value.translation.width
        withAnimation{
            //check
            if translation > 0{
                if translation > (sideBarWidth / 2){
                    //展示侧边栏
                    offset  = sideBarWidth
                    showMenu = true
                }else{
                    
                    //特殊情况
                    if offset == sideBarWidth{
                        return
                    }
                    
                offset = 0
                 showMenu = false
            }
            }else{
                if -translation > (sideBarWidth / 2){
                    offset = 0
                    showMenu = false
                    
                }
                else{
                    
                    if offset == 0 || !showMenu{
                        return
                    }
                    offset = sideBarWidth
                    showMenu = true
                }
            }
        //存储上一次的偏移量
        lastStoredOffset = offset
        
    }
    

}
    
    @ViewBuilder
    func CreateTabButton(image:String)->some View{
    Button{
        withAnimation{currentTabValue = image}
    }  label: {
        Image(image)
            .resizable()
            .renderingMode(.template)
            .aspectRatio( contentMode: .fit)
            .frame(width: 40, height: 40)
            .foregroundColor(currentTabValue == image ? .primary : .gray)
            .frame(maxWidth: .infinity)
    }


    }
    
}




struct MemHomePage_Previews: PreviewProvider {
    static var previews: some View {
        MemHomePage()
    }
}
