//
//  MemoryList.swift
//  UMem
//
//  Created by Jwy John on 2021/12/23.
//

import SwiftUI

struct MemoryList: View {
    @ObservedObject var memoryListViewModel = MemoryListViewModel()
    
    @State var isLoading = true
    
    var body: some View {
        VStack{
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
                    VStack {
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
                                    UIImage(data: self.memoryListViewModel.memoryData[index].photoUrlList[0])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 120)
                            .cornerRadius(20, corners: [.topLeft,.topRight])
                                }

                                    VStack(alignment: .leading) {
                                        Text(self.memoryListViewModel.memoryData[index].memoryTitle)
                                            .font(.callout)
                                            .fontWeight(.medium)
                                            .lineLimit(1)
                                            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing:5){
                                                ForEach(0..<self.memoryListViewModel.memoryData[index].tagList.count, id:\.self){i in
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 0)
                                                        .frame(width: 40, height:15)
                                                        .foregroundColor(Color(.sRGB, red: 169/255, green: 196/255, blue: 232/255, opacity: 1))
                                                        .cornerRadius(10)
                                                    
                                                    Text(self.memoryListViewModel.memoryData[index].tagList[i])
                                                        .font(.caption2)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(.gray)

                                                }
                                                
                                            }
                                            }.padding(.horizontal,3)
                                        HStack{
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 0)
                                                .frame(width: 40, height:15)
                                                .foregroundColor(Color(.sRGB, red: 100/255, green: 100/255, blue: 100/255, opacity: 0.1))
                                                .cornerRadius(10)
                                            
                                            Text(self.memoryListViewModel.memoryData[index].mood)
                                                .font(.caption2)
                                                .fontWeight(.medium)
                                                .foregroundColor(.gray)
                                            

                                        }
                                            Spacer()
                                            Text(self.memoryListViewModel.memoryData[index].memoryDate)
                                                .font(.caption2)
                                                .fontWeight(.medium)
                                            
                                        }.padding(.horizontal, 1)
                                        
                                        Spacer()
                                    }.frame(width: 170, height:70)
                                    

                            }

                        }
                    }
                    .cornerRadius(10)
                    .padding([.top, .horizontal,.bottom],10)
                    .shadow(color: .gray.opacity(0.6), radius: 20, x: 20, y: 20)
//                        Text(memoryListViewModel.memoryData[index].memoryTitle)
//                            .font(.title3)
//                            .fontWeight(.medium)
                        
                }
                }.padding(.horizontal,7)

            }
            
        }
        }.onAppear(perform: {
            isLoading = true
        })

    }
        
}

struct MemoryList_Previews: PreviewProvider {
    static var previews: some View {
        MemoryList()
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
