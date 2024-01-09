//
//  TabBarViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 20.12.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabImages()

        // Do any additional setup after loading the view.
    }
    func setTabImages() {
        let homeselectedimage = UIImage(named: "HomeSelected")!.withRenderingMode(.alwaysOriginal)
        let searchselectedimage = UIImage(named: "SearchSelected")!.withRenderingMode(.alwaysOriginal)
        let favoriteselectedimage = UIImage(named: "FavoriteSelected")!.withRenderingMode(.alwaysOriginal)
        let profileselectedimage = UIImage(named: "ProfileSelected")!.withRenderingMode(.alwaysOriginal)
        tabBar.items?[0].selectedImage = homeselectedimage
        tabBar.items?[1].selectedImage = searchselectedimage
        tabBar.items?[2].selectedImage = favoriteselectedimage
        tabBar.items?[3].selectedImage = profileselectedimage
        
    }

}

