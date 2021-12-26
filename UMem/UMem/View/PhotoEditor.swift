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
    
    @Binding var isEditored: [Bool]
    
    
    var index:Int
    
    var body: some View {
        VStack{

            //如果滤镜图片加载出来了则显示
            if !coreImageData.filteredImageList.isEmpty && coreImageData.mainImage != nil && self.isEditored[index] == false{
                
                Image(uiImage:coreImageData.mainImage.image.rotate(radians: .pi/2)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width)

                
                Slider(value: $coreImageData.value)
                    .padding()
                    .opacity(coreImageData.mainImage.isEditable ? 1 : 0)
                    .disabled(coreImageData.mainImage.isEditable ? false : true)


                
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
                        Image(uiImage: imageList[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 85, height: 100)
                            .onTapGesture {
                                coreImageData.mainImage.image = imageList[index]
                            }
                    ForEach(coreImageData.filteredImageList){filtered in
                        
                        Image(uiImage: (filtered.image.rotate(radians: .pi/2))!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 85, height: 100)
                            .onTapGesture {
//                                let updatedImage = Image(uiImage: filtered.image)
//                                imageList[index] = updatedImage.asUIImage()
                                coreImageData.mainImage = filtered
                                
                                
                            }
                    }
                    .padding()
                }
                }
            }
            else if !coreImageData.filteredImageList.isEmpty && coreImageData.mainImage != nil && self.isEditored[index] == true{
                Image(uiImage: imageList[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width)
            }
            else{
                Image(uiImage: imageList[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width)
                
                //否则显示加载框
                ProgressView()
            }
            
//            Button(action: {
//                self.imageList[index] = UIImage(imageLiteralResourceName: "Image")
//            }, label: {
//                Text("click")
//            })
        }
        .onChange(of: coreImageData.value, perform: {(_) in
            coreImageData.updateEffect()
        })
        .onAppear(perform: {
            //load the filtered image
            print("开始渲染滤镜后的图片")
            //初始化照片
            coreImageData.initPhoto(newImage: imageList[index])
            //先清除原先的照片
            coreImageData.filteredImageList.removeAll()
            coreImageData.loadFilter()
            coreImageData.detectFaces()
            
            
            
        })
        .onDisappear(perform: {

            self.imageList[index] = self.coreImageData.mainImage.image
            if self.isEditored[index] == false{
            self.imageList[index] = self.imageList[index].rotate(radians: .pi/2)!
                self.isEditored[index] = true
            }
        })
        
    }
}

struct PhotoEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        PhotoEditor(imageList: .constant([UIImage(imageLiteralResourceName: "Image")]), isEditored: .constant([false]), index: 0)
    }
}


extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}








extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
