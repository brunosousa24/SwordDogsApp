//
//  DogBreedImagesPage.swift
//  DogsApp
//
//  Created by Bruno Sousa on 17/09/2022.
//

import UIKit
import JHUD

class DogBreedImagesPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabeView: UITableView!
    private var _dogBreedList : [DogBreed] = []
    private var _dogBreedListShow : [DogBreed] = []
    private var _currentPage : Int = 1
    
    
    fileprivate func setupShowArrays(page: Int) {
        let beforeCount = self._dogBreedListShow.count
        self._dogBreedListShow = Array(self._dogBreedList[0..<(self._dogBreedList.count > page*20 ? page*20 : self._dogBreedList.count)])
        let afterCount = self._dogBreedListShow.count
        if afterCount != beforeCount {
            self.tabeView .reloadData()
        }
    }
    
    override func viewDidLoad() {
        let jhud = JHUD(frame: self.view.bounds)
        jhud.messageLabel.text = "Loading"
        jhud.show(at: self.view, hudType: JHUDLoadingType(rawValue: 1)!)
        self.tabBarController?.view.isUserInteractionEnabled = false
        super.viewDidLoad()
        self.title = "Dog Breed Images";
        tabeView.delegate = self
        tabeView.dataSource = self
        APICaller().getBreedsData { dogBreedList, errorMessage in
            if errorMessage != nil {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                if let data = UserDefaults.standard.data(forKey: "dogBreedList") {
                    do {
                        let decoder = JSONDecoder()
                        let dogBreedList = try decoder.decode([DogBreed].self, from: data)
                        self._dogBreedList = dogBreedList
                    } catch {
                        print("Unable to Decode Array of DogBreed (\(error))")
                    }
                }
                
            } else {
                self._dogBreedList = dogBreedList
            }
            jhud.hide()
            self.tabBarController?.view.isUserInteractionEnabled = true
            self.setupShowArrays(page: self._currentPage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dogBreedListShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogBreedImageTableViewCell") as! DogBreedImageTableViewCell
        cell.dogBreedName.text = _dogBreedListShow[indexPath.row]._breedName
        cell.dogBreedUIImageView.loadFrom(URLAddress: _dogBreedListShow[indexPath.row]._breedImageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self .performSegue(withIdentifier: "fromImageListToDetailsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromImageListToDetailsSegue" {
            if let viewController = segue.destination as? DogBreedDetailsPage {
                if let indexPath = tabeView.indexPathForSelectedRow {
                    viewController._dogBreed = _dogBreedListShow[indexPath.row]
                }
            }
        }
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
