//
//  DogErrorModel.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import Foundation

enum DogErrorModel: Error {
    case networkError(Error)
    case decoding(Error)
    case invalidURL
    case noData

    var displayError: String {
        switch self {
        case let .networkError(networkError):
            return networkError.localizedDescription
        case .invalidURL:
            return NSLocalizedString("somethingWrong", comment: "URL is not Correct")
        case .decoding:
            return NSLocalizedString("datadecodingIssue", comment: "Response is not as expected")
        case .noData:
            return NSLocalizedString("noDataReturned", comment: "Data issue")
        }
    }
}
