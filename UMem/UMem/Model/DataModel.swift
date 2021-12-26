//
//  DataModel.swift
//  UMem
//
//  Created by Jwy John on 2021/12/26.
//

import Foundation

struct tagData:Decodable{
    let Social: Int
    let Study: Int
    let Travel: Int
    let Sport:Int
    let Love:Int
    let Important:Int
    let Family:Int
    let Record:Int
    let Birthday:Int
    let Diary:Int
    let Default:Int
}


struct StatisticOfMonth:Decodable{
    var tagData:tagData
    var moodNum: [Double]
    var Richness:[Double]
    var memoryNum:[Double]
    var MoodPortionData:[Double]
    
    
}
