//
//  DogBreedImagesPage.swift
//  DogsApp
//
//  Created by Bruno Sousa on 17/09/2022.
//

import UIKit

class DogBreedImagesPage: UIViewController {
    
    private var _dogBreedListPage : DogBreedListPage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dog Breed Images";
        _dogBreedListPage = tabBarController?.viewControllers?[1] as? DogBreedListPage
        
        APICaller().getBreedsData { dogBreedList in
            
        }
    }
    
}
