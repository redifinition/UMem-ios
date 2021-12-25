//
//  PhotoDetailViewModel.swift
//  UMem
//
//  Created by lq on 2021/12/25.
//

import Foundation


class MemoryDetailViewModel:ObservableObject{
    
    var memoryDetailData : MemoryDetailInfo? = nil
    
    // 调用远端api
    func getMemoryDetailInfo(memoryId: Int, completion:@escaping(Int)->()){
        var components = URLComponents(string: "http://47.102.195.143:8080/memory/detailedInto")!
        components.queryItems = [
            URLQueryItem(name: "memoryId", value: String(memoryId))]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let requestUrl = components.url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)

        
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let resultData = data {
                    let response = response as? HTTPURLResponse
                    if let decodedResponse = try? JSONDecoder().decode(MemoryDetailInfo.self, from: resultData){
                        DispatchQueue.main.sync {
                            self.memoryDetailData = decodedResponse
                            print(self.memoryDetailData)
                        }
                        completion(response!.statusCode)
                        return
                    }
                }
                else {
                    print("No data")
                }
            }
        }
        task.resume()
    }
}
