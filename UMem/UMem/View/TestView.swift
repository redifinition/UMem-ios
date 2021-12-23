//
//  TestView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/24.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        HStack{
            Image(systemName: "bookmark.circle.fill")
            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing:0){
                ForEach(1..<4, id:\.self){i in
                ZStack{
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 45, height:15)
                        .foregroundColor(Color(.sRGB, red: 169/255, green: 196/255, blue: 232/255, opacity: 1))
                        .cornerRadius(10)
                    
                    Text("Important")
                        .font(.custom("", size: 9))
                        .fontWeight(.medium)
                        .foregroundColor(.gray)

                }
                
            }
            }.padding(.horizontal,3)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
