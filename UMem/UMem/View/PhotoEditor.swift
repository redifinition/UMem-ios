//
//  PhotoEditor.swift
//  UMem
//
//  Created by Jwy John on 2021/12/14.
//

import SwiftUI

struct PhotoEditor: View {
    @Binding public var imageList:[UIImage]
    
    @StateObject var coreImageData = ImageFilterViewModel()
    
    var index:Int
    
    var body: some View {
        VStack{
            Image(uiImage:imageList[index])
                .resizable()
                .cornerRadius(10)
                .scaledToFit()
                .frame(width: 85)
                .onAppear(perform: {
                    //load the filtered image
                    print("开始渲染滤镜后的图片")
                    //初始化照片
                    coreImageData.initPhoto(newImage: imageList[index])
                    //先清除原先的照片
                    coreImageData.filteredImageList.removeAll()
                    coreImageData.loadFilter()
                    
                })
            //如果滤镜图片加载出来了则显示
            if !coreImageData.filteredImageList.isEmpty{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
                    ForEach(coreImageData.filteredImageList){filtered in
                        
                        Image(uiImage: filtered.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                    }
                    .padding()
                }
                }
            }
            else{
                //否则显示加载框
                ProgressView()
            }
            
//            Button(action: {
//                self.imageList[index] = UIImage(imageLiteralResourceName: "Image")
//            }, label: {
//                Text("click")
//            })
        }
        
    }
}

struct PhotoEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        PhotoEditor(imageList: .constant([UIImage(imageLiteralResourceName: "Image")]), index: 0)
    }
}
