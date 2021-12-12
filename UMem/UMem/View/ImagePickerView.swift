//
//  ImagePickerView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/9.
//

import Foundation

import SwiftUI
import UIKit

//这里UIKit实现了使用UIImagePickerConttoller 实现照片的选取和拍摄

struct UmemImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: Image?
    @Binding var isPresented: Bool
    @EnvironmentObject var model:PhotoCapturerViewModel
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(image: $image, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}


class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: Image?
    @Binding var isPresented: Bool
    //@EnvironmentObject var model:PhotoCapturerViewModel
    
    init(image: Binding<Image?>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? Photo {
            self.image = Image(uiImage: photo.image!)
            //print("选择到的图片")
            //print(photo)
            //self.model.addPhoto(photo: photo)//加入该图片
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}

