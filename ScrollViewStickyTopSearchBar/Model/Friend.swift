//
//  Friend.swift
//  ScrollViewStickyTopSearchBar
//
//  Created by Maxim Macari on 19/3/21.
//

import SwiftUI

struct Friend: Identifiable, Decodable {
    var id = UUID().uuidString
    var firstName: String
    let latitude, longitude: Double
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case latitude, longitude, image
    }
}



