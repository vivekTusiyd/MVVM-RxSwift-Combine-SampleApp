//
//  String+Extensions.swift
//  MoviesAppUIKit
//
//  Created by Vivek Tusiyad on 21/08/24.
//

import Foundation


extension String {
    
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
