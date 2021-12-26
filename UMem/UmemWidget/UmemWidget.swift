//
//  UmemWidget.swift
//  UmemWidget
//
//  Created by Jwy John on 2021/12/26.
//

import WidgetKit
import SwiftUI
import Intents



struct Provider: IntentTimelineProvider {
    
    @State var memoryTitle :String = "www生日快乐"
    @State var memoryImageUrl : String = "http://tongjigohome.oss-cn-shanghai.aliyuncs.com/10001photo39123715.png?Expires=4794049237&OSSAccessKeyId=LTAI5t9L46CRZ9pYLUUdSS8b&Signature=RNnrH1rY8Vc37U%2FXypDXa1%2BB0vo%3D"
    @State var memoryDate : String = "2021-12-26"
    @State var Title:String = "Your latest Memory"
    @ObservedObject var model = MemoryViewModel()
    
    func placeholder(in context: Context) -> SimpleEntry {

       return SimpleEntry(date: Date(), MemoryTitle: memoryTitle, MemoryImageUrl: memoryImageUrl, memoryDate: memoryDate, title: "Your latest Memory", configuration: ConfigurationIntent())


    }
    

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {

        model.getMemoryListofUser(){response in
            if response == 200{
                self.memoryTitle = model.memoryData[0].memoryTitle
                self.memoryImageUrl =  model.memoryData[0].photoUrlList[0]
                self.memoryDate = model.memoryData[0].memoryDate
                let entry = SimpleEntry(date: Date(), MemoryTitle: model.memoryData[0].memoryTitle, MemoryImageUrl: model.memoryData[0].photoUrlList[0], memoryDate: model.memoryData[0].memoryDate, title: "Your latest Memory", configuration: ConfigurationIntent())
                print("到达这里")
                completion(entry)
            }
        }


    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                model.getMemoryListofUser(){response in
                if response == 200{
                    print("获取到data")
                    self.memoryTitle = model.memoryData[0].memoryTitle
                    self.memoryImageUrl =  model.memoryData[0].photoUrlList[0]
                    self.memoryDate = model.memoryData[0].memoryDate
                    print(model.memoryData[0].memoryDate)

                }
            }
            let entry = SimpleEntry(date: entryDate, MemoryTitle: memoryTitle, MemoryImageUrl: memoryImageUrl, memoryDate: memoryDate, title: "Your latest Memory", configuration: ConfigurationIntent())
            entries.append(entry)

        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let MemoryTitle: String
    let MemoryImageUrl: String
    let memoryDate: String
    let title: String
    let configuration: ConfigurationIntent
}

struct UmemWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack{
            AsyncImage(url: URL(string: entry.MemoryImageUrl)){ image in
                image.resizable()
            }placeholder: {
                ProgressView()
            }
        Text(entry.MemoryTitle)
            .font(.title)
                .fontWeight(.bold)
        }

    }
}

@main
struct UmemWidget: Widget {
    let kind: String = "UmemWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            UmemWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct UmemWidget_Previews: PreviewProvider {
    static var previews: some View {
        UmemWidgetEntryView(entry:  SimpleEntry(date: Date(), MemoryTitle: "23432", MemoryImageUrl: "3432", memoryDate: "200233", title: "Your latest Memory", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



//
//  model.swift
//  UMem
//
//  Created by Jwy John on 2021/12/26.
//

import Foundation

class MemoryViewModel: ObservableObject{
    
    
    
    
    
    var memoryData = [MemoryBasicInfo]()
    
    
    @Published var showListArray:[Bool] = []
    
    
    //调取远端API获取
    //获取回忆列表
    func getMemoryListofUser(completion:@escaping(Int)->()){
        let url = URL(string: "http://47.102.195.143:8080/memory/basicinfo")
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            do {
                if let resultData = data {
                    let response = response as? HTTPURLResponse
                    // 3.
                    //                                    let decodedData = try JSONDecoder().decode([Todo].self, from: todoData)
                    if let decodedResponse = try? JSONDecoder().decode(ResponseData.self, from: resultData){
                        
                        DispatchQueue.main.sync {
                            
                            self.memoryData = decodedResponse.memoryResult
                            
                            for i in 0..<self.memoryData.count{
                                if self.memoryData[i].tagList.count > 1{
                                    self.memoryData[i].tagList.remove(at: 0)
                                }
                            }
                            for _ in 0..<self.memoryData.count{
                                self.showListArray.append(true)
                            }
                            
                            completion(response!.statusCode)
                            return
                        }
                    }
                } else {
                    print("No data")
                }
            } catch let jsonErr as NSError{
                print("Json decode failed:\(jsonErr.localizedDescription)")
            }
            //                if let error = error {
            //                    print("Error took place \(error)")
            //                    return
            //                }
            //                guard let data = data else {return}
            //                let response = response as? HTTPURLResponse
            //                print(data)
            
            
        }
        task.resume()
    }
    
    
    
    struct MemoryBasicInfo: Decodable{
        let memoryTitle : String
        let photoUrlList: [String]
        let mood: String
        var tagList: [String]
        let memoryDate: String
        let memoryId : Int
    }


    struct ResponseData: Decodable{
        
       var memoryResult: [MemoryBasicInfo]
    }
    
}




