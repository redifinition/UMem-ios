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
    
    private var ColumnGrid = [GridItem(.flexible()),GridItem(.flexible())]
    

    
    var body: some View {
            VStack{
                ScrollView(.vertical){
                    LazyVGrid(columns: ColumnGrid, spacing:15){
                        ForEach(self.model.getPhotoList()){photo in
                            Image(uiImage: photo.image!)
                                .resizable()
                                .cornerRadius(10)
                                .scaledToFit()
                                .frame(width: 175)
                            
                        }.padding(.horizontal)
                            .shadow(color:Color(.sRGB, red: 64/255, green: 64/255, blue: 64/255, opacity: 0.3),radius: 40, x:0,y:20)
                        
                    }.padding()
                }
                //Image(uiImage: model.photo.image!)
//                Button(action: {
//                    print(self.model.getPhotoList())
//                }, label: {
//                    Text("click")
//                })
//                Image(systemName: "plus.viewfinder")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 50, height: 50)
//                    .shadow(radius: 10)
//                    .onTapGesture { self.shouldPresentActionScheet = true }
//                    .sheet(isPresented: $shouldPresentImagePicker) {
//                        UmemImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
//                            .environmentObject(model)
//                }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
//                    ActionSheet(title: Text("Choose mode"), message: Text("Please choose one mode to add your memory photos"), buttons: [ActionSheet.Button.default(Text("Use Camera!"), action: {
//                        self.shouldPresentImagePicker = true
//                        self.shouldPresentCamera = true
//                    }), ActionSheet.Button.default(Text("My Photo Library"), action: {
//                        self.shouldPresentImagePicker = true
//                        self.shouldPresentCamera = false
//                    }), ActionSheet.Button.cancel()])
//                }
            }
                       
                       
            }
                       
                       
    }
    
    


struct PictureResultView_Previews: PreviewProvider {
    static var previews: some View {
        PictureResultView()
    }
}
