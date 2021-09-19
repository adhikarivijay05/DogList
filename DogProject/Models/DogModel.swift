//
//  DogModel.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import Foundation

struct DogModel: Equatable {
    enum LifeSpanYear {
        typealias MinimumLifeSpan = Int
        typealias MaximumLifeSpan = Int
        
        case range(MinimumLifeSpan, MaximumLifeSpan)
        case fixedLifeSpan(Int)
        
        var averageLife: Int {
            switch self {
            case let .range(MinimumLifeSpan, MaximumLifeSpan): return (MinimumLifeSpan + MaximumLifeSpan) / 2
            case let .fixedLifeSpan(value): return value
            }
        }
    }
    
    let name: String
    let lifeSpan: LifeSpanYear
    let imageURL: URL
}

extension DogModel.LifeSpanYear: Equatable, Comparable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.averageLife == rhs.averageLife
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.averageLife > rhs.averageLife
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.averageLife < rhs.averageLife
    }
}

enum DogApiError: Error {
    case dataError
    case missingLifeSpan
}

extension DogModel {
    init(response: DogApiResponseModel) throws {
        guard let breed = response.breeds.first,
              let imageURL = URL(string: response.url)
        else { throw DogApiError.dataError }
        
        name = breed.name
        self.imageURL = imageURL
        print(breed.lifeSpan)
        lifeSpan = try LifeSpanYear(response: breed.lifeSpan)
        print(lifeSpan)
    }
}

/*
 Extension to check if Age is having range (a - b years) or ficed life ( x years)
 Pass response and cehck if it contains "years"
 create array using components seprated by space
 IF array have index of "-" --> get minimum and maximum age range and set LifeSpanYear == fixed
 If "-" is missing in lifeSpanArray then get first item and set LifeSpanYear == fixed
 */

extension DogModel.LifeSpanYear {
    init(response: String) throws {
        guard response.lowercased().hasSuffix("years") else {
            throw DogApiError.missingLifeSpan
        }
        let lifeSpanArray = response.components(separatedBy: " ")
        
        if let ageSperatorIndex = lifeSpanArray.firstIndex(of: "-"), ageSperatorIndex + 1 < lifeSpanArray.count {
            let minimumAge = lifeSpanArray.first ?? ""
            let maximumAge = lifeSpanArray[ageSperatorIndex + 1]
            
            guard let minAge = Int(minimumAge), let maxAge = Int(maximumAge) else {
                throw DogApiError.missingLifeSpan
            }
            self = .range(minAge, maxAge)
        } else {
            let yearsString = lifeSpanArray.first ?? ""
            guard let years = Int(yearsString) else {
                throw DogApiError.missingLifeSpan
            }
            self = .fixedLifeSpan(years)
        }
    }
}

