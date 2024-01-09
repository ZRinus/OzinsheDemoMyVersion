//
//  BannerMovie.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 30.09.2023.
//

import SwiftyJSON
class BannerMovie {
    var id = 0
    var link = ""
    var movie: Movie = Movie()
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["link"].string {
            self.link = temp
        }
        
        if json["movie"].exists() {
            movie = Movie(json: json["movie"])
        }
    }
}
