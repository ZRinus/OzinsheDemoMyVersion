//
//  Movie.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 30.09.2023.
//

import Foundation
import SwiftyJSON
//{
//        "id": 120,
//        "movieType": "SERIAL",
//        "name": "Әл-Фараби",
//        "keyWords": "ӘлФараби тарих ғылым",
//        "description": "Оқиға, шамамен, 876-877 жылдарда өрбиді. Бұл уақытта Әл-Фараби 7 жаста болған еді. Әл-Фарабидің әкесі әскербасы болуына байланысты, ұлын да жауынгерлік өнерге баулып, ендігі бек Әл-Фараби болатынын айтады. Арада 4-5 жыл өткенде ол алғашқы жорыққа шығады. Жорықта жүргенде төбе басына телескоп орнатып, аспанды зерттеп отырған қарияны кездестіріп, ғылым турасында біраз мағлұмат алады. Содан соғыс бітіп, елге оралған соң ғылым жолына кететінін әкесіне жеткізеді. Әкесі бірден қарсы болады. Дегенмен, арада біраз уақыт өткен соң ұлының ынтасын көріп, батасын береді. Әрі қарай оқиға сюжеті Әл-Фарабидің ғылым жолындағы сапары мен ізденісіне құрылады. Ғұламаның бастан өткізген қызық оқиғалары суреттеледі.",
//        "year": 2021,
//        "trend": true,
//        "timing": 8,
//        "director": "-",
//        "producer": "Кенжебаева С.Б.",
//        "poster": {
//            "id": 133,
//            "link": "http://api.ozinshe.com/core/public/V1/show/647",
//            "fileId": 647,
//            "movieId": 120
//        },
//        "video": null,
//        "watchCount": 2113,
//        "seasonCount": 1,
//        "seriesCount": 10,
//        "createdDate": "2022-06-16T12:52:19.717+00:00",
//        "lastModifiedDate": "2022-07-14T06:57:07.381+00:00",
//        "screenshots": [
//            {
//                "id": 153,
//                "link": "http://api.ozinshe.com/core/public/V1/show/629",
//                "fileId": 629,
//                "movieId": 120
//            }
//        ],
//        "categoryAges": [
//            {
//                "id": 2,
//                "name": "10-12",
//                "fileId": 257,
//                "link": "http://api.ozinshe.com/core/public/V1/show/257",
//                "movieCount": null
//            },
//            {
//                "id": 1,
//                "name": "8-10",
//                "fileId": 353,
//                "link": "http://api.ozinshe.com/core/public/V1/show/353",
//                "movieCount": null
//            },
//            {
//                "id": 4,
//                "name": "14-16",
//                "fileId": 357,
//                "link": "http://api.ozinshe.com/core/public/V1/show/357",
//                "movieCount": null
//            },
//            {
//                "id": 3,
//                "name": "12-14",
//                "fileId": 356,
//                "link": "http://api.ozinshe.com/core/public/V1/show/356",
//                "movieCount": null
//            }
//        ],
//        "genres": [
//            {
//                "id": 27,
//                "name": "Ғылыми-танымдық",
//                "fileId": 346,
//                "link": "http://api.ozinshe.com/core/public/V1/show/346",
//                "movieCount": null
//            }
//        ],
//        "categories": [
//            {
//                "id": 9,
//                "name": "Мультсериалдар",
//                "fileId": null,
//                "link": null,
//                "movieCount": null
//            },
//            {
//                "id": 1,
//                "name": "ÖZINŞE–де танымал",
//                "fileId": null,
//                "link": "http://api.ozinshe.com/core/public/V1/show/null",
//                "movieCount": null
//            }
//        ],
//        "favorite": true
//    }

struct Movie {
    var id = 0
    var movieType = ""
    var name: String = ""
    var keyWords: String = ""
    var description: String = ""
    var year: Int = 0
    var trend: Bool = false
    var timing: Int = 0
    var director: String = ""
    var producer: String = ""
    var poster_link: String = ""
    var video_link: String = ""
    var watchCount: Int = 0
    var seasonCount: Int = 0
    var seriesCount: Int = 0
    var createdDate: String = ""
    var lastModifiedDate: String = ""
    var screenshots: [Screenshot] = []
    var categoryAges: [Category] = []
    var genres: [Genre] = []
    var categories: [Category] = []
    var favorite: Bool = false
    
    init () {
    }
    
    init (json: JSON) {
        if let temp = json ["id"].int {
            id = temp
        }
        if let temp = json ["movieType"].string {
            movieType = temp
        }
        if let temp = json ["name"].string {
            name = temp
        }
        if let temp = json ["keyWords"].string {
            keyWords = temp
        }
        if let temp = json ["description"].string {
            description = temp
        }
        if let temp = json ["year"].int {
            year = temp
        }
        if let temp = json ["trend"].bool {
            trend = temp
        }
        if let temp = json ["timing"].int {
            timing = temp
        }
        if let temp = json ["director"].string {
            director = temp
        }
        if let temp = json ["producer"].string {
            producer = temp
        }
        if json ["poster"].exists() {
            if let temp = json ["poster"]["link"].string {
                poster_link = temp
            }
        }
        if json ["video"].exists() {
            if let temp = json ["video"]["link"].string {
                video_link = temp
            }
        }
        if let temp = json ["watchCount"].int {
            watchCount = temp
        }
        if let temp = json ["seasonCount"].int {
            seasonCount = temp
        }
        if let temp = json ["seriesCount"].int {
            seriesCount = temp
        }
        if let temp = json ["createdDate"].string {
            createdDate = temp
        }
        if let temp = json ["lastModifiedDate"].string {
            lastModifiedDate = temp
        }
        if let temp = json ["favorite"].bool {
            favorite = temp
        }
        if let items = json ["categories"].array {
            for item in items {
                let category = Category(json: item)
                categories.append(category)
                
            }
            if let items = json ["genres"].array {
                for item in items {
                    let genre = Genre(json: item)
                    genres.append(genre)
                }
                if let items = json ["categoryAges"].array {
                    for item in items {
                        let temp = Category(json: item)
                        categoryAges.append(temp)
                    }
                    if let items = json ["screenshots"].array {
                        for item in items {
                            let screen = Screenshot(json: item)
                            screenshots.append(screen)
                        }
                    }
                }
            }
        }
    }
}
