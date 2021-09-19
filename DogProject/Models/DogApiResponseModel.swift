//
//  DogApiResponseModel.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import Foundation

struct DogApiResponseModel: Decodable {
    let breeds: [Breed]
    let id: String
    let url: String
}

struct Breed: Decodable {
    let name: String
    let lifeSpan: String
    enum CodingKeys: String, CodingKey {
        case name
        case lifeSpan = "life_span"
    }
}

