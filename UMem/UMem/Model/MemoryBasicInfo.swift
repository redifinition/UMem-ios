//
//  MemoryBasicInfo.swift
//  UMem
//
//  Created by Jwy John on 2021/12/23.
//

import Foundation


struct MemoryBasicInfo: Decodable{
    let memoryTitle : String
    let photoUrlList: [String]
    let mood: String
    let tagList: [String]
    let memoryDate: String
    let memoryId : Int
}


struct ResponseData: Decodable{
    
   var memoryResult: [MemoryBasicInfo]
}
