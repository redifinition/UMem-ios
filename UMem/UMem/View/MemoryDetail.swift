//
//  MemoryDetail.swift
//  UMem
//
//  Created by Jwy John on 2021/12/24.
//

import SwiftUI

struct MemoryDetail: View {
    var body: some View {
        VStack{
        Text("Title")
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
        horizontalSplit
            
        Spacer()
        }
    }
    
    var horizontalSplit:some View{
        //分割框
        Rectangle()
            .fill(Color.gray)
            .opacity(0.5)
            .frame(height : 1)
    }
}

struct MemoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        MemoryDetail()
    }
}
