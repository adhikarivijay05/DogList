//
//  DogResultViewModel.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import Foundation

protocol DogApiViewModelDelegate: class {
    func reloadData()
    func showError(message: String)
    func isLoading(status:Bool)
}

class DogResultViewModel {
    enum SortByLifeSpan: CaseIterable {
        case ascending
        case descending
    }
    
    var items: [DogModel] = []
    
    weak var delegate: DogApiViewModelDelegate?
    
    // MARK: - To sort data (ascending OR descending) based on LifeSpan
    
    func sort(by SortByLifeSpan: SortByLifeSpan) {
        items.sort { firstDog, secondDog in
            let firstDogLifeSpan = firstDog.lifeSpan
            let secondDogLifeSpan = secondDog.lifeSpan
            switch SortByLifeSpan {
            case .ascending:
                return firstDogLifeSpan < secondDogLifeSpan
            case .descending:
                return firstDogLifeSpan > secondDogLifeSpan
            }
        }
        delegate?.reloadData()
    }
    
    // MARK: - To Fetch Data from Netwrok Manager

    func fetchItems() {
        self.delegate?.isLoading(status: true)
        let networkManager = NetworkManager()
        networkManager.request { result in
            self.delegate?.isLoading(status: false)
            switch result {
            case let .success(dogs):
                self.items = dogs
                self.delegate?.reloadData()
            case let .failure(error):
                self.delegate?.showError(message: error.displayError)
            }
        }
    }
}
