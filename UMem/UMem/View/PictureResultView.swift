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

    @State var isEditored:[Bool] = []
    
    //照片库选择框
    @State var isShowChoosingSheet = false
    
    //使用照片库还是自带相机
    @State var capturingType = UIImagePickerController.SourceType.camera
    
    @State var isShowPhotoLibray = false
    
    @StateObject var titleManager = LimitManager()
    
    //动画
    @State var titleIsTapped  = false
    
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
                        
                        
                        
                        ForEach(0..<self.imageListOfLibrary.count, id: \.self){ i in
                            NavigationLink(
                                destination: PhotoEditor(imageList :$imageListOfLibrary, isEditored: $isEditored, index: i)

                            ){

                                Image(uiImage: self.imageListOfLibrary[i])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                                .scaledToFit()
                                .frame(width: 85,height: 100)
                            }

                        }
                        

                        
                    }.padding()
                }
                .frame(height: 200)
                
                .sheet(isPresented: $isShowPhotoLibray) {
                    ImagePicker(sourceType: self.capturingType, selectedImageList: self.$imageListOfLibrary,
                                isEditored: self.$isEditored)
                        .environmentObject(model)
                }
                
            VStack{
                HStack{
                    Image(systemName: "newspaper")
            VStack(alignment: .leading, spacing: 5, content:{
                HStack(spacing: 15){
                    //输入回忆的标题
                    TextField("",text: $titleManager.titleOfMemory){(status) in
                            if status{
                                withAnimation(.easeIn){
                                    titleIsTapped = true
                                }
                            }
                        } onCommit: {
                            //当没有文本输入时
                            if titleManager.titleOfMemory == ""{
                            withAnimation(.easeOut){
                                titleIsTapped = false
                            }
                            }
                        }
                }
                //被点击时
                .padding(.top, titleIsTapped ? 15 : 0)
                .background(
                    Text("Your Memory Title")
                        .scaleEffect(titleIsTapped ? 0.8 : 1)
                        .offset(x: titleIsTapped ? -15 : 0, y:  titleIsTapped ? -15 : 0)
                        .foregroundColor(titleIsTapped ? .accentColor : .gray)
                    
                    ,alignment: .leading
                )
                .padding(.horizontal)
                
                //分割框
                Rectangle()
                    .fill(titleIsTapped ? Color.accentColor : Color.gray)
                    .opacity(titleIsTapped ? 1 : 0.5)
                    .frame(height : 1)
                    .padding(.top, 10)

            })
                .padding(.top,12)
                .background(Color.gray.opacity(0.09))
                .cornerRadius(5)
                }
                
                //展示输入字符的个数
                HStack{
                    Spacer()
                    Text("\(titleManager.titleOfMemory.count)/15")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                        .padding(.top , 4)
                }

            }
            .padding()
            
            Spacer()
                
                
                

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
            .onAppear(perform:{
                let photoList = self.model.getPhotoList()
                
                    photoList.forEach{(image)in
                imageListOfLibrary.append(image.image!)
                    }
                
                for _ in photoList{
                    self.isEditored.append(false)
                }
                self.model.clearPhoto()
                
            }
            )
                       
                       
                       
    }
        
}
    
    


struct PictureResultView_Previews: PreviewProvider {
    static var previews: some View {
        PictureResultView()
    }
}

class LimitManager: ObservableObject{
    @Published var titleOfMemory = ""{
        // use didSet function
        didSet{
            if titleOfMemory.count > 15 && oldValue.count <= 15{
                self.titleOfMemory = oldValue
            }
        }
    }
}
