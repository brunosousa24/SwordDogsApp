//
//  DogBreedImagesPage.swift
//  DogsApp
//
//  Created by Bruno Sousa on 17/09/2022.
//

import UIKit
import JHUD

class DogBreedImagesPage: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var tabeView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var _dogBreedList : [DogBreed] = []
    private var _dogBreedListShow : [DogBreed] = []
    private var _currentPage : Int = 1
    
    
    fileprivate func setupShowArrays(page: Int) {
        let beforeCount = self._dogBreedListShow.count
        self._dogBreedListShow = Array(self._dogBreedList[0..<(self._dogBreedList.count > page*20 ? page*20 : self._dogBreedList.count)])
        let afterCount = self._dogBreedListShow.count
        if afterCount != beforeCount || _currentPage == 1{
            if !tabeView.isHidden {
                tabeView .reloadData()
            }
            if !collectionView.isHidden {
                collectionView.reloadData()
            }
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
        tabeView.isHidden = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.register(DogBreedImageCollectionViewCell.nib(), forCellWithReuseIdentifier: DogBreedImageCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        collectionView.collectionViewLayout = layout
        
        let changeView = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(changeViewTapped))
        navigationItem.rightBarButtonItems = [changeView]
        
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
    
    @objc func changeViewTapped() {
        tabeView.setContentOffset(.zero, animated: false)
        collectionView.setContentOffset(.zero, animated: false)
        self.navigationItem.rightBarButtonItems?[0].isEnabled = true
        navigationItem.rightBarButtonItems?[0].title = navigationItem.rightBarButtonItems?[0].title == "Grid" ? "Table" : "Grid"
        tabeView.isHidden = !tabeView.isHidden
        collectionView.isHidden = !collectionView.isHidden
        _currentPage = 1;
        setupShowArrays(page: _currentPage)
    }
    
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dogBreedListShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogBreedImageTableViewCell") as! DogBreedImageTableViewCell
        cell.dogBreedName.text = _dogBreedListShow[indexPath.row]._breedName
        if _dogBreedListShow[indexPath.row]._breedImage != nil {
            cell.dogBreedUIImageView.image = _dogBreedListShow[indexPath.row]._breedImage
        } else {
            APICaller().getImage(from: URL(string: _dogBreedListShow[indexPath.row]._breedImageURL)!) { image in
                self._dogBreedList[indexPath.row]._breedImage = image
                if let cell = tableView.cellForRow(at: indexPath) {
                    (cell as! DogBreedImageTableViewCell).dogBreedUIImageView.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self .performSegue(withIdentifier: "fromImageListToDetailsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _dogBreedListShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogBreedImageCollectionViewCell.identifier, for: indexPath) as! DogBreedImageCollectionViewCell
        cell.dogBreedName.text = _dogBreedListShow[indexPath.row]._breedName
        if _dogBreedListShow[indexPath.row]._breedImage != nil {
            cell.dogBreedUIImageView.image = _dogBreedListShow[indexPath.row]._breedImage
        } else {
            APICaller().getImage(from: URL(string: _dogBreedListShow[indexPath.row]._breedImageURL)!) { image in
                self._dogBreedList[indexPath.row]._breedImage = image
                if let cell = collectionView.cellForItem(at: indexPath) {
                    (cell as! DogBreedImageCollectionViewCell).dogBreedUIImageView.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self .performSegue(withIdentifier: "fromImageListToDetailsSegue", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromImageListToDetailsSegue" {
            if let viewController = segue.destination as? DogBreedDetailsPage {
                if let indexPath = tabeView.indexPathForSelectedRow {
                    viewController._dogBreed = _dogBreedListShow[indexPath.row]
                } else if let indexPaths = collectionView.indexPathsForSelectedItems {
                    viewController._dogBreed = _dogBreedListShow[indexPaths[0].row]
                }
            }
        }
    }
    
    // MARK: - Pagination Handling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false
        let position = scrollView.contentOffset.y
        if !tabeView.isHidden && position > (tabeView.contentSize.height-50-scrollView.frame.size.height) {
            _currentPage+=1
            self.setupShowArrays(page: _currentPage)
        }
        if !collectionView.isHidden && position > (collectionView.contentSize.height-50-scrollView.frame.size.height) {
            _currentPage+=1
            self.setupShowArrays(page: _currentPage)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.navigationItem.rightBarButtonItems?[0].isEnabled = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
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
