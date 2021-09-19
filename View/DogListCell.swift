//
//  DogListCell.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import UIKit
import Kingfisher

class DogListCell: UITableViewCell {
    
    @IBOutlet weak var lifeSpanLbl: UILabel!
    @IBOutlet weak var dogNameLbl: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureDogCell(with dog: DogModel) {
        dogNameLbl.text = dog.name
        lifeSpanLbl.text = dog.lifeSpan.numberOfYears
        dogImage.setDogImage(imageUrl: dog.imageURL)
    }
}

// MARK: - get LifeSpan of Dog

extension DogModel.LifeSpanYear {
    var numberOfYears: String {
        switch self {
        case let .fixedLifeSpan(value):
            return ("\(value) years")
        case let .range(minAge, maxAge):
            return ("\(minAge) - \(maxAge) years")
        }
    }
}

// MARK: - get Image from kingFisher

extension UIImageView {
    func setDogImage(imageUrl: URL?, completion: ((Result<Void, Error>) -> Void)? = nil) {
        guard let dogPosterUrl = imageUrl else {
            kf.cancelDownloadTask()
            return
        }
        kf.indicatorType = .activity
        kf.setImage(with: dogPosterUrl, placeholder: UIImage(systemName: "alarm.fill")) { result in
            switch result {
            case .success: completion?(.success(()))
            case let .failure(error): completion?(.failure(error))
            }
        }
    }
}
