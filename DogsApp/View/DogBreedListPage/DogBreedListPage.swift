//
//  DogBreedListPage.swift
//  DogsApp
//
//  Created by Bruno Sousa on 18/09/2022.
//

import UIKit

class DogBreedListPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tabeView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    private var _dogBreedList : [DogBreed] = []
    private var _dogBreedFilteredList : [DogBreed] = []
    private var _dogBreedFilteredShowList : [DogBreed] = []
    private var _currentPage : Int = 1
    
    fileprivate func setupShowArrays(page: Int) {
        let beforeCount = self._dogBreedFilteredShowList.count
        self._dogBreedFilteredShowList = Array(self._dogBreedFilteredList[0..<(self._dogBreedFilteredList.count > page*20 ? page*20 : self._dogBreedFilteredList.count)])
        let afterCount = self._dogBreedFilteredShowList.count
        if afterCount != beforeCount {
            self.tabeView .reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dog Breeds List";
        
        tabeView.delegate = self
        tabeView.dataSource = self
        mySearchBar.delegate = self
        if let data = UserDefaults.standard.data(forKey: "dogBreedList") {
            do {
                let decoder = JSONDecoder()
                let dogBreedList = try decoder.decode([DogBreed].self, from: data)
                self._dogBreedList = dogBreedList
            } catch {
                print("Unable to Decode Array of DogBreed (\(error))")
            }
        }
        _dogBreedFilteredList = _dogBreedList
        setupShowArrays(page: _currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dogBreedFilteredShowList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogBreedListTableViewCell") as! DogBreedListTableViewCell
        cell.dogBreedName.text = _dogBreedFilteredShowList[indexPath.row]._breedName
        cell.dogBreedCategory.text = _dogBreedFilteredShowList[indexPath.row]._breedGroup != "" ? "Group | " + _dogBreedFilteredShowList[indexPath.row]._breedGroup : ""
        cell.dogBreedOrigin.text = _dogBreedFilteredShowList[indexPath.row]._breedOrigin != "" ? "Origin | " + _dogBreedFilteredShowList[indexPath.row]._breedOrigin : ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self .performSegue(withIdentifier: "fromBreedListToDetailsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromBreedListToDetailsSegue" {
            if let viewController = segue.destination as? DogBreedDetailsPage {
                if let indexPath = tabeView.indexPathForSelectedRow {
                    viewController._dogBreed = _dogBreedFilteredShowList[indexPath.row]
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        let position = scrollView.contentOffset.y
        if position > (tabeView.contentSize.height-50-scrollView.frame.size.height) {
            _currentPage+=1
            self.setupShowArrays(page: _currentPage)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        _currentPage = 1
        if searchText.count == 0 {
            _dogBreedFilteredList = _dogBreedList
        } else {
            _dogBreedFilteredList = []
            for dogBreed in _dogBreedList {
                if dogBreed._breedName.lowercased().contains(searchText.lowercased()) {
                    _dogBreedFilteredList.append(dogBreed)
                }
            }
        }
        setupShowArrays(page: _currentPage)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}
