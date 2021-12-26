//
//  StatisticsViewModel.swift
//  UMem
//
//  Created by Jwy John on 2021/12/26.
//

import Foundation

class StatisticViewModel:ObservableObject{
    
    var statistics :StatisticOfMonth? = nil
    
    
    func getStatisticsOfAMonth(completion:@escaping(Int)->()){
        let url = URL(string: "http://47.102.195.143:8080/memory/statistic/monthly/num")
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
                    if let decodedResponse = try? JSONDecoder().decode(StatisticOfMonth.self, from: resultData){
                        
                        DispatchQueue.main.sync {
                            
                            
                            self.statistics = decodedResponse
                            print(self.statistics)
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
