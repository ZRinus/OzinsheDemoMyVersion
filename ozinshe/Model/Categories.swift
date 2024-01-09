//
//  Categories.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 30.09.2023.
//

import Foundation
import SwiftyJSON

class Category {
    var name: String
    var id: Int
    init (json: JSON) {
        name = json["name"].stringValue
        id = json["id"].intValue
    }
}
