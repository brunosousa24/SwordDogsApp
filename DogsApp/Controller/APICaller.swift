//
//  ApiCaller.swift
//  DogsApp
//
//  Created by Bruno Sousa on 18/09/2022.
//

import Foundation
import UIKit


class APICaller {
    
    func getBreedsData(completion: @escaping ([DogBreed] , String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.thedogapi.com/v1/breeds")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("live_wx5mFpDS9CZglgVfDTSgNruAp4Lijmu3w9Vec9Y52SQUQhWydJe7BphQQvmsbg9G", forHTTPHeaderField: "x-api-key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if response != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!)
                    var dogBreedList : [DogBreed] = []
                    for dogBreedDict in (json as! [[String: Any]]){
                        var breedName = ""
                        var breedGroup = ""
                        var breedTemperament = ""
                        var breedImageURL = ""
                        var breedOrigin = ""
                        if dogBreedDict["name"] != nil {
                            breedName = dogBreedDict["name"]! as! String
                        }
                        if dogBreedDict["breed_group"] != nil {
                            breedGroup = dogBreedDict["breed_group"]! as! String
                        }
                        if dogBreedDict["temperament"] != nil {
                            breedTemperament = dogBreedDict["temperament"]! as! String
                        }
                        if dogBreedDict["origin"] != nil {
                            breedOrigin = dogBreedDict["origin"]! as! String
                        }
                        if dogBreedDict["image"] != nil {
                            if (dogBreedDict["image"] as! [String: Any])["url"] != nil {
                                breedImageURL = (dogBreedDict["image"] as! [String: Any])["url"]! as! String
                            }
                        }
                        let dogBreed = DogBreed(_breedName: breedName, _breedImageURL: breedImageURL, _breedGroup: breedGroup, _breedOrigin: breedOrigin, _breedTemperament: breedTemperament)
                        dogBreedList.append(dogBreed);
                    }
                    DispatchQueue.main.async {
                        completion(dogBreedList , nil)
                    }
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()
                        
                        // Encode Note
                        let data = try encoder.encode(dogBreedList)
                        
                        // Write/Set Data
                        UserDefaults.standard.set(data, forKey: "dogBreedList")
                        
                    } catch {
                        print("Unable to Encode Array of DogBreed (\(error))")
                    }
                } catch {
                    print("error")
                }
            } else {
                DispatchQueue.main.async {
                    completion([] , "Network Error")
                }
            }
        })
        
        task.resume()
    }
    
}
