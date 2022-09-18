//
//  ApiCaller.swift
//  DogsApp
//
//  Created by Bruno Sousa on 18/09/2022.
//

import Foundation


class APICaller {
    
    func getBreedsData(completion: ([DogBreed]) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.thedogapi.com/v1/breeds")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("live_wx5mFpDS9CZglgVfDTSgNruAp4Lijmu3w9Vec9Y52SQUQhWydJe7BphQQvmsbg9G", forHTTPHeaderField: "x-api-key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!)
                print(json)
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
}
