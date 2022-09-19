//
//  DogBreed.swift
//  DogsApp
//
//  Created by Bruno Sousa on 18/09/2022.
//

import Foundation
import UIKit

struct DogBreed : Codable {
    let _breedName: String
    let _breedImageURL: String
    let _breedGroup: String
    let _breedOrigin: String
    let _breedTemperament: String
    var _breedImage: UIImage?
    
    private enum CodingKeys: String, CodingKey {
            case _breedName, _breedImageURL, _breedGroup, _breedOrigin, _breedTemperament
        }
}
