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
    
    
    //动画
    @State var titleIsTapped  = false
    
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



