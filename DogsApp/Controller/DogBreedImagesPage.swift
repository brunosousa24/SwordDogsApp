//
//  DogBreedImagesPage.swift
//  DogsApp
//
//  Created by Bruno Sousa on 17/09/2022.
//

import UIKit

class DogBreedImagesPage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dog Breed Images";
        
        APICaller().getBreedsData { dogBreedList in
            
        }
    }
    
}
