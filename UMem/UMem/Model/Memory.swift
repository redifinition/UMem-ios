//
//  Memory.swift
//  UMem
//  一段回忆，包含照片列表，心情，时间，回忆内容等等
//  Created by lq on 2021/12/13.
//

import Foundation

class Memory :Identifiable{
    var photoList:[Photo]
    var memoryContent:String
    var mood:[Mood]
    var time:Date
    
    init(photoList:[Photo],memoryContent:String,mood:[Mood],time:Date){
        self.photoList = photoList
        self.memoryContent = memoryContent
        self.mood = mood
        self.time = time
    }
}


enum Mood{
    case happy
    case excited
    case nervous
    case dread
    case tired
    case sad
    case plain
}
