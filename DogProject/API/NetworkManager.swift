//
//  NetworkManager.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import Foundation

class NetworkManager {
    let session = URLSession(configuration: .default)
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private var dogApiRequestUrl:String? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.thedogapi.com"
        urlComponents.path = "/v1/images/search"
        urlComponents.queryItems = [URLQueryItem(name: "limit", value: "50")]
        return urlComponents.url?.absoluteString
    }
    
    func request(completionHandler: @escaping (Result<[DogModel], DogErrorModel>) -> Void) {
        
        guard let urlString = dogApiRequestUrl, let url = URL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        session.dataTask(with: url) { (data, response , error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {                    
                    let response = try self.decoder.decode([DogApiResponseModel].self, from: data)
                    let dogs = response.compactMap { try? DogModel(response: $0) }
                    completionHandler(.success(dogs))
                } catch {
                    completionHandler(.failure(.decoding(error)))
                }
            }
        }.resume()
    }
}
