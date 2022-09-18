//
//  DogBreedDetailsPage.swift
//  DogsApp
//
//  Created by Bruno Sousa on 18/09/2022.
//

import UIKit

class DogBreedDetailsPage: UIViewController {
    var _dogBreed : DogBreed?
    @IBOutlet weak var dogBreedName: UILabel!
    @IBOutlet weak var dogBreedCategory: UILabel!
    @IBOutlet weak var dogBreedOrigin: UILabel!
    @IBOutlet weak var dogBreedTemperament: UILabel!
    
    override func viewDidLoad() {
        if let dogBreed = _dogBreed {
            self.title = dogBreed._breedName
            dogBreedName.text = dogBreed._breedName
            dogBreedCategory.text = dogBreed._breedGroup
            dogBreedOrigin.text = dogBreed._breedOrigin
            dogBreedTemperament.text = dogBreed._breedTemperament
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
