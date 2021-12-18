//
//  test.swift
//  UMem
//
//  Created by Jwy John on 2021/12/17.
//

import SwiftUI

struct test: View {
    @StateObject var titleManager = TextLimitManager()
    
    @State var memoryDate = Date()
    
    let moodImageSet = ["mood0","mood1","mood2","mood3","mood4","mood5","mood6","mood7"]
    //动画
    @State var titleIsTapped  = false
    
    @State var moodSheetIsPresented = false
    
    //选择的心情
    @State var mood = 0
    
    let moodNameSet = ["unchoosed","Sad", "Happy", "Hopeful", "Exciting", "Frightened", "Vigorous", "Playful"]
    
    
    // 选择的内容标签tag
    @State var tag = 0
    
    let tagImageList = ["tag0","tag1","tag2","tag3","tag4","tag5","tag6","tag7","tag8","tag9","tag10"]
    //被选择的标签数组
    @State var choosedTagList = [0]

    let tagNameList = ["none", "Family", "Love", "Sport", "Study", "Travel", "Birthday", "Social", "Important", "Record", "Diary" ]
    
    @State tagSheetIsPresented = true
    
    private var ColumnGridOfTag = [GridItem(.flexible()),GridItem(.flexible())]
    
    private var ColumnGrid = [GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "newspaper")
        VStack(alignment: .leading, spacing: 5, content:{
            HStack(spacing: 15){
                
                
                
                //输入回忆的标题
                TextField("", text: $titleManager.titleOfMemory)
                {(status) in
                        if status{
                            withAnimation(.easeIn){
                                titleIsTapped = true
                            }
                        }
                    }
            onCommit: {
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
                LazyVGrid(columns: ColumnGrid, spacing:8){
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
            //分割框
            Rectangle()
                .fill(Color.gray)
                .opacity(0.5)
                .frame(height : 1)
                .padding(.top, 10)
            
            //选择当前的memory标签
            HStack{
                Image(systemName: "dial.max.fill")
                Text("Choose your memory tag!")
                    .fontWeight(.medium)
                Spacer()
                ForEach(0..<self.choosedTagList.count, id:\.self){i in
                    Image(tagImageList[choosedTagList[i]])
                        .frame(width: 40, height: 40)
                }
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
                LazyVGrid(columns: ColumnGrid, spacing:8){
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
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}

class TextLimitManager: ObservableObject{
    
    
    @Published var isOvering = false
    
    @Published var contentIsOvering = false
    
    @Published var titleOfMemory = ""{
        // use didSet function
        didSet{
            if titleOfMemory.count > 15 && oldValue.count <= 15{
                titleOfMemory = oldValue
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






