//
//  PictureResultView.swift
//  UMem
//  展示拍摄完成的照片，并且显示添加照片
//  Created by lq on 2021/12/8.
//

import SwiftUI

struct PictureResultView: View {
    
    //视频捕捉的viewModel
    @EnvironmentObject  var model : PhotoCapturerViewModel
    
    @State private var image: Image?
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    

    
    var body: some View {
            VStack{
                Image(uiImage: model.photo.image!)
                Button(action: {
                    print(model.getPhotoList())
                }, label: {
                    Text("click")
                })
                Image(systemName: "plus.viewfinder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .shadow(radius: 10)
                    .onTapGesture { self.shouldPresentActionScheet = true }
                    .sheet(isPresented: $shouldPresentImagePicker) {
                        UmemImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Choose mode"), message: Text("Please choose one mode to add your memory photos"), buttons: [ActionSheet.Button.default(Text("Use Camera!"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = true
                    }), ActionSheet.Button.default(Text("My Photo Library"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = false
                    }), ActionSheet.Button.cancel()])
                }
            }
                       
                       
            }
                       
                       
    }
    
    


struct PictureResultView_Previews: PreviewProvider {
    static var previews: some View {
        PictureResultView()
    }
}
