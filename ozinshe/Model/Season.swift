//
//  Season.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 30.09.2023.
//

import SwiftyJSON

struct Season {
    var number: Int = 0
    var videos: [SeasonVideo] = []
    init(json: JSON) {
        if let temp = json["number"].int {
            self.number = temp
        }
        if let videos = json ["videos"].array {
            videos.forEach({
                self.videos.append(SeasonVideo(json: $0)) })
        }
    }
}
struct SeasonVideo {
    var number: Int = 0
    var link = ""
    init (json:JSON) {
        if let temp = json["number"].int {
            self.number = temp
        }
   if let temp = json ["link"].string {
        self.link = temp
    }
    }
}
