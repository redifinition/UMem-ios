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
    
    //被编辑的照片
    @Published var mainImage : FilteredImage!
    
    //编辑条的值
    @Published var value :CGFloat = 1.0
    //只要有照片被选择，就开始加载过滤器的设置
    //使用多样化啊的过滤器
    let filters : [CIFilter] = [
        CIFilter.sepiaTone(),
        CIFilter.comicEffect(),
        CIFilter.colorInvert(),
        CIFilter.photoEffectFade(),
        CIFilter.colorMonochrome(),
        CIFilter.photoEffectChrome(),
        CIFilter.gaussianBlur(),
        CIFilter.bloom()
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
                
                let isEditable = filter.inputKeys.count > 1
                
                let filteredData = FilteredImage(image: UIImage(cgImage: cgimage!),filter: filter, isEditable: isEditable)
                
                
                DispatchQueue.main.async {
                    //将处理好的图片加入到图片列表
                    self.filteredImageList.append(filteredData)
                    
                    //默认第一个过滤器
                    if self.mainImage == nil{
                        self.mainImage = self.filteredImageList.first
                    }
                }
            }

            

        }
    }
    
    func updateEffect(){
        
        let context = CIContext()
        
        //to avoid lag do it in background:
        DispatchQueue.global(qos: .userInteractive).async {
            //将图片放入对应的过滤器中
            let CiImage = CIImage(image: self.imageData)
            
            let filter = self.mainImage.filter
            
            filter.setValue(CiImage, forKey: kCIInputImageKey)
            
            //reading input keys
            if filter.inputKeys.contains("inputRadius"){
                filter.setValue(self.value * 10, forKey: kCIInputRadiusKey)
            }
            
            if filter.inputKeys.contains("inputIntensity"){
                filter.setValue(self.value, forKey: kCIInputIntensityKey)
            }
            
            //取回图像
            guard let newImage = filter.outputImage else{return}
            
            //create UIImage
            
            let cgimage = context.createCGImage(newImage, from: newImage.extent)
            
            
            
            DispatchQueue.main.async {
                // updating view
                
                self.mainImage.image = UIImage(cgImage: cgimage!)
            }
        }
    }
    
    //将图片数据载入
    func initPhoto(newImage:UIImage){
        self.imageData = newImage
    }
}
