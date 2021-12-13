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
    
    
    @State private var imageListOfLibrary :[UIImage] = []

    
    //照片库选择框
    @State var isShowChoosingSheet = false
    
    //使用照片库还是自带相机
    @State var capturingType = UIImagePickerController.SourceType.camera
    
    @State var isShowPhotoLibray = false
    
    private var ColumnGrid = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    

    
    var body: some View {
            VStack{
                ScrollView(.vertical){
                    LazyVGrid(columns: ColumnGrid, spacing:15){
                        Button(action: {
                            //首先结束相机捕捉
                            self.model.stopCapturing()
                            //sheet开启
                            self.isShowChoosingSheet = true
                            
                            
                        }, label: {
                            Image("AdditionPhoto")
                                .resizable()
                                .frame(width: 85,height: 85)
                        }).shadow(color:Color(.sRGB, red: 64/255, green: 64/255, blue: 64/255, opacity: 0.3),radius: 40, x:0,y:20)
                        ForEach(self.imageListOfLibrary, id: \.self){image in
                            
                            Image(uiImage: image)
                                .resizable()
                                .cornerRadius(10)
                                .scaledToFit()
                                .frame(width: 85)
                        }
                        ForEach(self.model.getPhotoList()){photo in
                            Image(uiImage: photo.image!)
                                .resizable()
                                .cornerRadius(10)
                                .scaledToFit()
                                .frame(width: 85)

                        }.padding(.horizontal)
                            .shadow(color:Color(.sRGB, red: 64/255, green: 64/255, blue: 64/255, opacity: 0.3),radius: 40, x:0,y:20)
                        
                    }.padding()
                }
                .sheet(isPresented: $isShowPhotoLibray) {
                    ImagePicker(sourceType: self.capturingType, selectedImageList: self.$imageListOfLibrary)
                        .environmentObject(model)
                }
        .actionSheet(isPresented: $isShowChoosingSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose one mode to add your memory photos"), buttons: [ActionSheet.Button.default(Text("Use Camera!"), action: {
                self.isShowChoosingSheet = false
                self.isShowPhotoLibray = true
                self.capturingType = UIImagePickerController.SourceType.camera
                
            }), ActionSheet.Button.default(Text("My Photo Library"), action: {
                
                self.isShowChoosingSheet = false
                self.isShowPhotoLibray = true
                self.capturingType = UIImagePickerController.SourceType.photoLibrary
                
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
