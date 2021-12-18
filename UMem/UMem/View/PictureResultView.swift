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
    
    //选择的日期
    @State var memoryDate = Date()
    
    
    
    @State var moodSheetIsPresented = false
    
    //选择的心情
    @State var mood = 0
    
    let moodNameSet = ["unchoosed","Sad", "Happy", "Hopeful", "Exciting", "Frightened", "Vigorous", "Playful"]
    
    private var ColumnGridOfMood = [GridItem(.flexible()),GridItem(.flexible())]
    
    @State var moodImageSet = ["mood0","mood1","mood2","mood3","mood4","mood5","mood6","mood7"]
    
    
    
    private var ColumnGrid = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    

    
    var body: some View {
        ScrollView{
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
                        .foregroundColor(titleManager.isOvering ? .red : .gray)
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
                
                
                HStack{
                Image(systemName: "calendar")
                HStack{

                    DatePicker("Select the date!", selection: $memoryDate, in: ...Date(), displayedComponents: [.date])
                        .accentColor(Color.gray)
                        .datePickerStyle(
                            CompactDatePickerStyle()
                        )
                }.padding(8)
                        .background(Color.gray.opacity(0.09))
                        .cornerRadius(5)
                }.padding(.vertical,5)
                
                
                //输入回忆文本

                    VStack{
                        HStack{
                            Image(systemName: "wallet.pass")
                            Spacer()
                            Button(action: {
                                self.endEditing()
                            }, label: {
                                Image(systemName: "checkmark.icloud")
                            })
                        }.padding(.vertical,5)
                        TextEditor(text: $titleManager.MemoryText)
                            .frame(height: 250)
                            .foregroundColor(titleManager.contentIsOvering ? .red : .gray)
                            .colorMultiply(Color(.sRGB, red: 245/255, green: 245/255, blue: 245/255))
                            .cornerRadius(10)
                    }
                //展示输入字符的个数
                HStack{
                    Spacer()
                    Text("\(titleManager.MemoryText.count)/5000")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                        .padding(.top , 4)
                }
                
                //选择当前心情
                HStack{
                    Image(systemName: "face.smiling")
                    Text("Choose your mood now!")
                        .fontWeight(.medium)
                    Spacer()
                    Text("mood:")
                        .foregroundColor(.gray)
                    Image(moodImageSet[mood])
                        .frame(width: 40, height: 40)
                    Text(self.moodNameSet[mood])
                        .font(.caption)
                    Button(action: {
                        self.moodSheetIsPresented.toggle()
                    }, label: {
                        Image(systemName: "pencil.circle")
                    })
                    
                }.sheet(isPresented: $moodSheetIsPresented){
                    Text("Choose Your Mood Now!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    LazyVGrid(columns: ColumnGridOfMood, spacing:8){
                    ForEach(1..<self.moodImageSet.count, id: \.self){index in
                        ZStack{
                            Rectangle()
                                .padding(.horizontal,5)
                                .foregroundColor(.gray.opacity(0.09))
                                .cornerRadius(20)

                        VStack{
                            Button(action: {
                                self.moodSheetIsPresented.toggle()
                                self.mood = index
                            }, label: {
                                Image(self.moodImageSet[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                            })
                        
                            Text(self.moodNameSet[index])
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                        }
                    }
                    .shadow(color: Color(.sRGB, red: 64/255, green: 64/255, blue: 64/255, opacity: 0.3), radius: 40, x:0,y:20)
                    }.padding()
                    HStack{
                    Text("Tips:")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding()
                        .foregroundColor(.gray)
                    Spacer()
                    }
                    Text("Choose the mood of the memories you want to store! Choose the one that best represents your mood at the time!")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding()
                        .foregroundColor(.gray)
                


                    
                    Spacer()
                    
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
    
    @Published var isOvering = false
    
    @Published var contentIsOvering = false
    
    @Published var titleOfMemory = ""{
        // use didSet function
        didSet{
            if titleOfMemory.count > 15 && oldValue.count <= 15{
                self.titleOfMemory = oldValue
                isOvering = true
            }
            else{
                isOvering = false
            }
        }
    }
    
    @Published var MemoryText = "Record my memory!"{
        // use didSet function
        didSet{
            if MemoryText.count > 5000 && oldValue.count <= 5000{
                MemoryText  = oldValue
                contentIsOvering = true
            }
            else{
                contentIsOvering = false
            }
        }
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}



