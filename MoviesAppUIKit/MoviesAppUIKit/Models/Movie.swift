//
//  Movie.swift
//  MoviesAppUIKit
//
//  Created by Vivek Tusiyad on 21/08/24.
//

import Foundation

struct MovieResponse: Decodable {
    let Search: [Movie]
}

struct Movie : Decodable {  //Can use Codable also but as we are not creating/sending any movie to server , only getting the data from server so Decodable is also fine.
    
    let title: String
    let year: String
    
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
    }
    
}
