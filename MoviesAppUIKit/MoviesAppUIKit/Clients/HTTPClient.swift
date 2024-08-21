//
//  HTTPClient.swift
//  MoviesAppUIKit
//
//  Created by Vivek Tusiyad on 21/08/24.
//

import Foundation
import Combine


enum NetworkError: Error {
    case badUrl
}
class HTTPClient {
    
    private let APIKey = "5a308067"
    
    func fetchMovies(_ searchText: String) -> AnyPublisher<[Movie], Error> {
        
        guard let encodeSearch = searchText.urlEncoded, let url = URL(string: "https://www.omdbapi.com/?s=\(encodeSearch)&page=2&apikey=\(APIKey)") else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.Search)  //search key in MovieResponse
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie],Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

