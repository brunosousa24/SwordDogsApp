//
//  DogBreedImagesPage.swift
//  DogsApp
//
//  Created by Bruno Sousa on 17/09/2022.
//

import UIKit

class DogBreedImagesPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabeView: UITableView!
    private var _dogBreedListPage : DogBreedListPage?
    private var _dogBreedList : [DogBreed] = []
    private var _dogBreedListShow : [DogBreed] = []
    private var _currentPage : Int = 1
    
    
    fileprivate func setupShowArrays(page: Int) {
        self._dogBreedListShow = Array(self._dogBreedList[0..<(self._dogBreedList.count > page*20 ? page*20 : self._dogBreedList.count)])
        self.tabeView .reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dog Breed Images";
        tabeView.delegate = self
        tabeView.dataSource = self
        _dogBreedListPage = tabBarController?.viewControllers?[1] as? DogBreedListPage
        
        if let data = UserDefaults.standard.data(forKey: "dogBreedList") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let dogBreedList = try decoder.decode([DogBreed].self, from: data)
                self._dogBreedList = dogBreedList
                self.setupShowArrays(page: _currentPage)
                
            } catch {
                print("Unable to Decode Array of DogBreed (\(error))")
            }
        }
        
        APICaller().getBreedsData { dogBreedList, errorMessage in
            if errorMessage != nil {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self._dogBreedList = dogBreedList
            self.setupShowArrays(page: self._currentPage)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dogBreedListShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DogBreedImageTableViewCell
        cell.dogBreedName.text = _dogBreedListShow[indexPath.row]._breedName
        cell.dogBreedUIImageView.loadFrom(URLAddress: _dogBreedListShow[indexPath.row]._breedImageURL)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tabeView.contentSize.height-50-scrollView.frame.size.height) {
            _currentPage+=1
            self.setupShowArrays(page: _currentPage)
        }
    }
    
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
