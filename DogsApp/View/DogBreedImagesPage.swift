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
        
        if let data = UserDefaults.standard.data(forKey: "dogBreedList") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let dogBreedList = try decoder.decode([DogBreed].self, from: data)
                print(dogBreedList)

            } catch {
                print("Unable to Decode Array of DogBreed (\(error))")
            }
        }
        
        APICaller().getBreedsData { dogBreedList in
            print(dogBreedList)
        }
    }
    
}
