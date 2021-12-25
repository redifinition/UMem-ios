//
//  PhotoDetail.swift
//  UMem
//
//  Created by Jwy John on 2021/12/25.
//

import Foundation

struct MemoryDetailInfo: Decodable{
    let memoryTitle : String
    let mood: Int
    let memoryDate: String
    let photoUrlList : [String]
    let memoryTagList: [Int]
    let memoryContent: String
}
