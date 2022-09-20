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
    
    fileprivate func setText(label : UILabel , text : String,  addedText : String) {
        if text != "" {
            label.text = addedText+text
        } else {
            label.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        if let dogBreed = _dogBreed {
            self.title = dogBreed._breedName
            setText(label: dogBreedName, text: dogBreed._breedName, addedText: "Name : ")
            setText(label: dogBreedCategory, text: dogBreed._breedGroup, addedText: "Group : ")
            setText(label: dogBreedOrigin, text: dogBreed._breedOrigin, addedText: "Origin : ")
            setText(label: dogBreedTemperament, text: dogBreed._breedTemperament, addedText: "Temperament : ")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
