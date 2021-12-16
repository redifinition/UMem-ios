//
//  ImageFilterViewModel.swift
//  UMem
//
//  Created by Jwy John on 2021/12/16.
//

import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageFilterViewModel: ObservableObject{
    @Published var imageData = UIImage()
    
    //待选择的经过处理的所有滤镜图片
    @Published var filteredImageList: [FilteredImage] = []
    
    //只要有照片被选择，就开始加载过滤器的设置
    
    let filters : [CIFilter] = [
        CIFilter.sepiaTone()
    ]
    func loadFilter(){
        
        let context = CIContext()
        
        filters.forEach{(filter) in
            
            //to avoid lag do it in background:
            DispatchQueue.global(qos: .userInteractive).async {
                //将图片放入对应的过滤器中
                let CiImage = CIImage(image: self.imageData)
                
                filter.setValue(CiImage, forKey: kCIInputImageKey)
                //取回图像
                guard let newImage = filter.outputImage else{return}
                
                //create UIImage
                
                let cgimage = context.createCGImage(newImage, from: newImage.extent)
                
                let filteredData = FilteredImage(image: UIImage(cgImage: cgimage!),filter: filter)
                
                
                DispatchQueue.main.async {
                    //将处理好的图片加入到图片列表
                    self.filteredImageList.append(filteredData)
                }
            }

            

        }
    }
    
    //将图片数据载入
    func initPhoto(newImage:UIImage){
        self.imageData = newImage
    }
}
