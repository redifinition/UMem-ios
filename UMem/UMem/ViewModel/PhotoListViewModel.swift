//
//  PhotoListViewModel.swift
//  UMem
//
//  Created by Jwy John on 2021/12/23.
//

import Foundation


class MemoryListViewModel: ObservableObject{
    
    
    
    
    
    var memoryData = [MemoryBasicInfo]()
    
    
    @Published var showListArray:[Bool] = []
    
    //调取远端API获取
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
                            print("得到的data")
                            print(self.memoryData)
                            print(response as Any)
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
    
}




