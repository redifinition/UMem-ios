//
//  MemoryList.swift
//  UMem
//
//  Created by Jwy John on 2021/12/23.
//

import SwiftUI
import URLImage


struct MemoryList: View {
    @ObservedObject var memoryListViewModel = MemoryListViewModel()
    
    @State var isLoading = true
    
    @State var showCard = true
    
    @State var showCardList = []
    
    @State var chosedMemoryId: Int = 0
    
    var body: some View {

        VStack{
            Text("Redefinition's Memory Collections!")
                .fontWeight(.medium)
                .font(.title3)
            //分割框
            Rectangle()
                .fill(Color.gray)
                .opacity(0.5)
                .frame(height : 1)
                .padding(.top, 10)
            Spacer()
        if isLoading{
            ProgressView()
                .onAppear(perform: {
                    //调用api
                    memoryListViewModel.getMemoryListofUser(){response in
                        if response == 200{
                           isLoading = false
                        }

                    }
                })
            
        }
        else{

            ScrollView{
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], spacing:0){
                    ForEach(0..<self.memoryListViewModel.memoryData.count, id:\.self){index in
                        
                        ZStack{
                            VStack{
                            Spacer()
                                HStack{
                                    Spacer()
                                    VStack{
                                        NavigationLink(destination:{
                                            MemoryDetail(memoryId : self.chosedMemoryId)
                                        },label:{
                                            Image(systemName: "magnifyingglass.circle.fill")
                                        })
                                    Button(action: {
                                        print("111")
                                    }, label: {
                                        Image(systemName: "delete.left.fill")
                                    })
                                    }
                                }
                            }
                            .padding()
                            .frame(width: 180, height:200)
                            .offset(x: self.memoryListViewModel.showListArray[index] ? 0 : 15)
                                .rotationEffect(Angle(degrees: self.memoryListViewModel.showListArray[index] ? 0 : -10))
                            .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0).delay(0.2))
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 180, height:200)
                                .foregroundColor(Color(.sRGB, red: 230/255, green: 230/255, blue: 230/255, opacity: 1))
                            VStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 0)
                                        .frame(width: 180, height:120)
                                        .foregroundColor(Color(.sRGB, red: 255/255, green: 223/255, blue: 201/255, opacity: 1))
                                        .cornerRadius(20, corners: [.topLeft,.topRight])
//                                    ImageBlock(url: URL(string:  self.memoryListViewModel.memoryData[index].photoUrlList[0])!)
                                    
                                    if #available(iOS 15.0, *) {
                                        AsyncImage(url: URL(string: self.memoryListViewModel.memoryData[index].photoUrlList[0])!) { image in
                                            image.resizable()
                                        }placeholder: {
                                            ProgressView()
                                        }
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180, height: 120)
                                        .cornerRadius(20, corners: [.topLeft,.topRight])
                                    } else {
                                    ImageBlock(url: URL(string:  self.memoryListViewModel.memoryData[index].photoUrlList[0])!)
                                    }
                                }

                                    VStack(alignment: .leading) {
                                        Text(self.memoryListViewModel.memoryData[index].memoryTitle)
                                            .font(.callout)
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                        HStack{
                                            Image(systemName: "bookmark.circle.fill")
                                            ForEach(0..<self.memoryListViewModel.memoryData[index].tagList.count, id:\.self){i in

                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 0)
                                                        .frame(width: 45, height:15)
                                                        .foregroundColor(.gray.opacity(0.1))
                                                        .cornerRadius(10)
                                                        .shadow(color: .gray.opacity(0.6), radius: 20, x: 20, y: 20)
                                                    
                                                    
                                                    Text(self.memoryListViewModel.memoryData[index].tagList[i])
                                                        .font(.custom("", size: 9))
                                                        .fontWeight(.medium)
                                                        .foregroundColor(.gray)

                                                }
                                                
                                                }

                                        }
                                        HStack{
                                            Image(systemName: "face.smiling")
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 0)
                                                .frame(width: 45, height:15)
                                                .foregroundColor(Color(.sRGB, red: 100/255, green: 100/255, blue: 100/255, opacity: 0.1))
                                                .cornerRadius(10)
                                            
                                            Text(self.memoryListViewModel.memoryData[index].mood)
                                                .font(.custom("", size: 9))
                                                .fontWeight(.medium)
                                                .foregroundColor(.gray)
                                            

                                        }
                                            Spacer()
                                            Text(self.memoryListViewModel.memoryData[index].memoryDate)
                                                .font(.caption2)
                                                .fontWeight(.medium)
                                            
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 5)
                                    .frame(width: 170, height:70)
                                    

                            }

                        }
                    .cornerRadius(10)
                    .padding([.top, .horizontal,.bottom],10)
                    .shadow(color: .gray.opacity(0.6), radius: 20, x: 20, y: 20)
//                        Text(memoryListViewModel.memoryData[index].memoryTitle)
//                            .font(.title3)
//                            .fontWeight(.medium)
                        //.offset(x: showCard ? 0 : -50)
                        .rotationEffect(Angle(degrees: self.memoryListViewModel.showListArray[index] ? 0 : 10))
                        .rotation3DEffect(Angle(degrees: self.memoryListViewModel.showListArray[index] ? 0 : 10), axis: (x: 0,y:10, z:0))
                        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0).delay(0.1))
                        .onTapGesture {
                            //获取memoryid
                            self.chosedMemoryId = self.memoryListViewModel.memoryData[index].memoryId
                            
                            for i in 0..<self.memoryListViewModel.showListArray.count{
                                if i != index{
                                self.memoryListViewModel.showListArray[i] = true
                                }
                            }
                            self.memoryListViewModel.showListArray[index].toggle()
                        }
                        
                        }
                }
                }.padding(.horizontal,7)

            }
            
        }
            Spacer()
        }.onAppear(perform: {
            isLoading = true
        })

    }
    
    
    var checkBlockView:some View{
        VStack{
        Spacer()
            HStack{
                Spacer()
                VStack{
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                    })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "delete.left.fill")
                })
                }
            }
        }.frame(width: 180, height:200)
        //.offset(x: showCard ?  : 10)
        .rotationEffect(Angle(degrees: showCard ? 0 : -10))
        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0).delay(0.2))
    }
        
}

struct MemoryList_Previews: PreviewProvider {
    static var previews: some View {
        MemoryList()
    }
}

@ViewBuilder
func ImageBlock(url: URL)->some View{
    URLImage(url) { image in
        
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 180, height: 120)
            .cornerRadius(20, corners: [.topLeft,.topRight])
    }
}
class Observer: ObservableObject {

    @Published var enteredForeground = true

    init() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }

    @objc func willEnterForeground() {
        enteredForeground.toggle()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
