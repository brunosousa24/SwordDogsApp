//
//  DogBreedImageCollectionViewCell.swift
//  DogsApp
//
//  Created by Bruno Sousa on 19/09/2022.
//

import UIKit

class DogBreedImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogBreedUIImageView: UIImageView!
    @IBOutlet weak var dogBreedName: UILabel!
    
    static let identifier = "dogBreedImageCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib.init(nibName: "DogBreedImageCollectionViewCell", bundle: nil)
    }

}
