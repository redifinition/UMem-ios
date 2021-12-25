//
//  MemoryDetail.swift
//  UMem
//
//  Created by Jwy John on 2021/12/24.
//

import SwiftUI
import Photos
import URLImage


struct MemoryDetail: View {
    //ViewModel
    @ObservedObject var photoDetailViewModel = MemoryDetailViewModel()
    
    
    //需要初始化的参数
    var memoryId : Int
    
    //控制走马灯滑动时间的timerinternal
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    @State private var currentInex = 0
    
    @State var moodImageSet = ["mood0","mood1","mood2","mood3","mood4","mood5","mood6","mood7"]
    
    let tagImageList = ["tag0","tag1","tag2","tag3","tag4","tag5","tag6","tag7","tag8","tag9","tag10"]
    
    
    @State var isshowSavingSheet = false
    
    
    @State var isLoading = true
    
    //尝试缓存照片
    @State var imageList :[UIImage] = []
    
    var body: some View {
        
        if isLoading{
            ProgressView()
                .onAppear(perform: {
                    photoDetailViewModel.getMemoryDetailInfo(memoryId: self.memoryId){response in
                        if response == 200{
                            isLoading = false
                        }
                    }
                })
        }
        else{
            if #available(iOS 15.0, *) {
                ScrollView{
                VStack{
                    GeometryReader{ proxy in
                        TabView(selection: $currentInex){
                            ForEach(0..<(self.photoDetailViewModel.memoryDetailData?.photoUrlList.count == 0 ? 1 : (self.photoDetailViewModel.memoryDetailData?.photoUrlList.count)!), id:\.self){i in
                                if (self.photoDetailViewModel.memoryDetailData?.photoUrlList.count)! > 0{
                                    AsyncImage(url: URL(string: (self.photoDetailViewModel.memoryDetailData?.photoUrlList[i])!)!) { image in
                                        image.resizable()
                                    }placeholder: {
                                        ProgressView()
                                    }
                                    .scaledToFill()
                                    .overlay(Color.black.opacity(0.1))
                                    .tag(i)
                                    .onLongPressGesture(perform: {
                                        isshowSavingSheet.toggle()
                                    })
                                    .actionSheet(isPresented: $isshowSavingSheet) { () -> ActionSheet in
                                        ActionSheet(title: Text("UMem"), message: Text("Do you want to save this photo?"), buttons: [ActionSheet.Button.default(Text("Save Photo"), action: {
                                            
                                                                                //保存第i张图片到本地
                                                PHPhotoLibrary.shared().performChanges {
                                                    _ = PHAssetChangeRequest.creationRequestForAsset(from: self.imageList[i])
                                            
                                                                                } completionHandler: { (success, error) in
                                            
                                                                                }
                                            
                                        }), ActionSheet.Button.cancel()])
                                    }}
                                else{
                                    Image("noPhoto")
                                        .resizable()
                                        .scaledToFill()
                                        .overlay(Color.black.opacity(0.1))
                                        .tag(i)
                                }
                                
                                
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .onReceive(timer, perform: {_ in
                            withAnimation{
                                //改变page到下一个
                                currentInex = currentInex < (self.photoDetailViewModel.memoryDetailData?.photoUrlList.count)! ? currentInex + 1 : 0
                            }
                        })
                    }.frame(height: 300)
                    HStack{
                        Text(self.photoDetailViewModel.memoryDetailData!.memoryTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Spacer()
                    }.padding(.horizontal)

                    HStack{
                        Text("Tag:")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                        ForEach(0..<(self.photoDetailViewModel.memoryDetailData?.memoryTagList.count)!, id:\.self){index in
                            Image(self.tagImageList[(self.photoDetailViewModel.memoryDetailData?.memoryTagList[index])!])
                                .frame(width: 20, height: 20)
                        }.padding(.horizontal,3)
                        Spacer()
                    }.padding()
                    horizontalSplit.padding(.horizontal)
                    HStack{
                        Text("Mood:")
                            .font(.body)
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                        Image(self.moodImageSet[self.photoDetailViewModel.memoryDetailData!.mood])
                        Spacer()
                        Text("Published on "+self.photoDetailViewModel.memoryDetailData!.memoryDate)
                            .foregroundColor(.gray)
                            .fontWeight(.light)
                    }.padding()

                        Text(self.photoDetailViewModel.memoryDetailData!.memoryContent)
                            .font(.body)
                            .padding()
                    Spacer()

                    
                }
                }
                .task{
                    do{
                        await mySleep(1)
                        for i in 0..<self.photoDetailViewModel.memoryDetailData!.photoUrlList.count{
                            let (data,_) = try await URLSession.shared.data(from: URL(string: (self.photoDetailViewModel.memoryDetailData?.photoUrlList[i])!)!)
                            self.imageList.append(UIImage(data: data)!)
                        }
                    }catch{
                        
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @available(iOS 15.0.0, *)
    func mySleep(_ seconds: Int) async{
        sleep(UInt32(seconds))
    }
    
    var horizontalSplit:some View{
        //分割框
        Rectangle()
            .fill(Color.gray)
            .opacity(0.5)
            .frame(height : 1)
    }
    
}

struct MemoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        MemoryDetail(memoryId: 14333052)
    }
}


@ViewBuilder
func ImageBlockOfDetail(url: URL)->some View{
    URLImage(url) { image in
        
        image
            .resizable()
            .scaledToFill()
            .overlay(Color.black.opacity(0.1))
    }
}
