//
//  URLS.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 20.10.2023.
//

import Foundation

class Urls {
    static let BASE_URL = "http://185.100.67.64/core/V1/"

    static let SING_IN_URL = "http://185.100.67.64/auth/V1/signin"
    static let SING_UP_URL = "http://api.ozinshe.com/auth/V1/signup"
    
    static let FAVORITE_URL = BASE_URL + "favorite/"
    static let ADD_Favorite_URL = BASE_URL + "favorite/"
    static let PERSONAL_DATA_URL = BASE_URL + "user/profile/"
    static let CHANGE_PASS_URL = BASE_URL + "user/profile/changePassword"
    static let CATEGORIES_URL = BASE_URL + "categories"
    static let SEARCH_MOVIES_URL = BASE_URL + "movies/search"
    static let MOVIES__BY_CATEGORY_URL = BASE_URL + "movies/page"
    static let MAIN_BANNERS_URL = BASE_URL + "movies_main"
    static let USER_HISTORY_URL = BASE_URL + "history/userHistory"
    static let MAIN_MOVIES_URL = BASE_URL + "movies/main"
    static let GET_GENRES = BASE_URL + "genres"
    static let GET_AGES = BASE_URL + "category-ages"
    static let GET_SEASONS = BASE_URL + "season/"
}
