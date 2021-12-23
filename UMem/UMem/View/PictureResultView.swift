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
    
    
    // 选择的内容标签tag
    @State var tag = 0
    
    let tagImageList = ["tag0","tag1","tag2","tag3","tag4","tag5","tag6","tag7","tag8","tag9","tag10"]
    //被选择的标签数组
    @State var choosedTagList:Set = [0]

    let tagNameList = ["none", "Family", "Love", "Sport", "Study", "Travel", "Diary", "Record", "Important", "Social", "Birthday" ]
    
    @State var tagSheetIsPresented = false
    
    private var ColumnGridOfTag = [GridItem(.flexible()),GridItem(.flexible())]
    
    
    private var ColumnGrid = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    //是否正在上传回忆
    @State var isUploading = false
    
    @State var isSuccess = false
    
    @State var shouldShowResult = false
    
    @State var showMenu = false
    
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
                
                
                //分割框
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.5)
                    .frame(height : 1)
                    .padding(.top, 10)
                
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
                
                //分割框
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.5)
                    .frame(height : 1)
                    .padding(.top, 10)
                
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
                
                
                //分割框
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.5)
                    .frame(height : 1)
                    .padding(.top, 10)
                
                
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
                
                Group{
                //选择当前的memory标签
                HStack{
                    Image(systemName: "dial.max.fill")
                    Text("Choose your memory tag!")
                        .fontWeight(.medium)
                    Spacer()
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing:8){
                        ForEach(self.choosedTagList.sorted(), id:\.self){tag in
                            Image(tagImageList[tag])
                                .frame(width: 40, height: 40)
                        }
                    }
                    Button(action: {
                        self.tagSheetIsPresented.toggle()
                    }, label: {
                        Image(systemName: "pencil.circle")
                    })
                    
                }.sheet(isPresented: $tagSheetIsPresented){
                    Text("Choose Your Tag Now!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    LazyVGrid(columns: ColumnGridOfTag, spacing:8){
                    ForEach(1..<self.tagImageList.count, id: \.self){index in
                        ZStack{
                            Rectangle()
                                .padding(.horizontal,5)
                                .foregroundColor(.gray.opacity(0.09))
                                .cornerRadius(20)

                        VStack{
                            Button(action: {
                                self.tagSheetIsPresented.toggle()
                                self.choosedTagList.insert(index)
                            }, label: {
                                Image(self.tagImageList[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                            })
                        
                            Text(self.tagNameList[index])
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                        }
                    }
                    .shadow(color: Color(.sRGB, red: 64/255, green: 64/255, blue: 64/255, opacity: 0.3), radius: 40, x:0,y:20)
                    }.padding(.horizontal)
                    HStack{
                    Text("Tips:")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                    Spacer()
                    }
                    Text("Choose the label that the memory belongs to! You can add multiple tags to memories! You can better organize your own memories when viewing your memories!")
                        .font(.body)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                


                    
                    Spacer()
                    
                }
                
                    HStack{
                Spacer()
                        Button(action: {
                            isUploading = true
                            postMemoryData(imageList: self.imageListOfLibrary, memoryDate: self.memoryDate, mood: self.mood, choosedTagList: Array(self.choosedTagList), memoryTitle: self.titleManager.titleOfMemory, memoryContent: self.titleManager.MemoryText){response in
                                if response == 200{
                                    isSuccess = true
                                }
                                else{
                                    isSuccess = false
                                }
                                isUploading = false
                                shouldShowResult = true
                            }
                                
                        }, label: {
                            if isUploading{
                                ProgressView()
                            }
                            Image("complete")
                        })
                    }.sheet(isPresented: $shouldShowResult){
                        VStack{
                            if isSuccess == true{
                                VStack{
                                Text("You have successfully create one memory!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 20)

                                Image("successPhoto")
                                    NavigationLink(destination: {
                                        MemoryList()
                                    }, label: {
//                                            Rectangle()
//                                                .shadow(color: Color(.sRGB, red: 64/255, green: 64/255, blue: 64/255, opacity: 0.3), radius: 40, x:0,y:20)
//                                                .frame(height:50)
//                                                .foregroundColor(Color.gray.opacity(0.2))
//                                                .cornerRadius(10)
                                        Text("Go to see my memory!")
                                            .font(.title3)
                                            .fontWeight(.medium)


                                    })
                                        .padding()
                                    NavigationLink(destination: {
                                        HomeView(showMenu: $showMenu)
                                    }, label: {
                                                    Text("Continue to create memory!")
                                                        .font(.title3)
                                                        .fontWeight(.medium)

                                    })
                                        .padding()
                                }.padding()
                                Spacer()
                        }
                            else{
                                VStack{
                                Text("Upload fails! Please check your information and try again!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 20)
                                        
                                Image("failurePhoto")
                                        .padding()
                                }.padding()
                                Spacer()
                            }
                        }
                    }

                }
            .padding()
            //Spacer()
                
                

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
        .padding(.horizontal)
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
//            .onDisappear(perform: {
//                self.shouldShowResult.toggle()
//            })
                       
                       
                       
    }
        
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



//调用post api
func postMemoryData(imageList: [UIImage], memoryDate: Date, mood: Int, choosedTagList: [Int], memoryTitle: String, memoryContent: String, completion:@escaping(Int)->()){
    
    struct MemoryData: Codable{
        var photoDataList : [String]
        var memoryTitle : String
        var memoryContent : String
        var mood : Int
        var tagList : [Int]
        var memoryDate : String
    }
    //首先需要将imageList逐个转换为base64data
    var imageBase64Data = uiimageToBase64Data(uiImageList: imageList)
    
    //将date转换为字符串
    let dataFormater = DateFormatter()
    dataFormater.dateFormat = "YYYY-MM-dd"
    var memoryDateStr = dataFormater.string(from: memoryDate)
    
    
    
    let url = URL(string: "http://47.102.195.143:8080/memory/infor/posting")
    guard let requestUrl = url else { fatalError() }

    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // Set HTTP Request Header
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let title = memoryTitle == "" ? "No title" : memoryTitle
    let newTodoItem = MemoryData(photoDataList: imageBase64Data, memoryTitle: title, memoryContent: memoryContent, mood: mood, tagList: choosedTagList, memoryDate: memoryDateStr)
    
    let jsonData = try! JSONEncoder().encode(newTodoItem)
    
    
    request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            let response = response as? HTTPURLResponse
            do{
                print(response  as Any)
                completion(response!.statusCode)
            }catch let jsonErr{
                print(jsonErr)
           }

     
    }
    task.resume()
}

//将uiimage转化为base64字符串
func uiimageToBase64Data(uiImageList: [UIImage]) -> [String]{
    var base64List:[String] = []
    for uiimage in uiImageList{
        let uiimage = compressImage(image: uiimage)//上传一般图片
        //uiimage.jpegData(compressionQuality: 1)//上传高清图片
        let imageStringData = "data:image/png;base64," + convertImageToBase64(image: uiimage)
        base64List.append(imageStringData)
    }
//    let imageData = image.jpegData(compressionQuality: 1)
//    return imageData?.base64EncodedString(options:
//    Data.Base64EncodingOptions.lineLength64Characters)
    return base64List
    
}



func convertImageToBase64(image: UIImage) -> String {
    let imageData = image.pngData()!
    return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
}


extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}


func compressImage(image: UIImage) -> UIImage {
        let resizedImage = image.aspectFittedToHeight(200)
    resizedImage.jpegData(compressionQuality: 1) // Add this line
        return resizedImage
}
