//
//  SeasonsViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 16.12.2023.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Alamofire
import SwiftyJSON

class SeasonsViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource, UICollectionViewDelegate, UITableViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var movie = Movie()
    var seasons: [Season] = []
    var currentSeason = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        downloadSeason()
        
        // Do any additional setup after loading the view.
    }
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    func downloadSeason() {
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        SVProgressHUD.show()
        AF.request(Urls.GET_SEASONS + "\(movie.id)", method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                if let data = response.data {
                    let json = JSON (data)
                    if let seasons = json.array {
                        seasons.forEach({self.seasons.append(Season(json: $0))
                        })
                        self.collectionView.reloadData()
                        self.tableView.reloadData()
                    } else {
                        // oshibka
                    }
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            }
            
        }
    }
    
    // MARK:  - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seasons.count == 0 {
            return 0
        }
        return seasons[currentSeason].videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label = cell.viewWithTag(200) as? UILabel
        label?.text = "\(seasons[currentSeason].videos[indexPath.row].number) - bolim"
       // label?.text = "\(seasons[currentSeason].number) sezon"
        let imageView = cell.viewWithTag(100)  as? UIImageView
        imageView?.layer.cornerRadius = 12
        imageView?.sd_setImage(with: URL(string: "https://i.ytimg.com/vi/\(seasons[currentSeason].videos[indexPath.row].link)/hq720.jpg"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label = cell.viewWithTag(1000) as? UILabel
       label?.text = "\(seasons[currentSeason].number) sezon"
       // label?.text = "\(indexPath.row + 1)сезон"
        let backView = cell.viewWithTag(1001)!

                backView.layer.cornerRadius = 8

                if currentSeason == indexPath.row {
                    label?.textColor = UIColor(displayP3Red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
                    backView.backgroundColor = UIColor(displayP3Red: 151/255, green: 83/255, blue: 240/255, alpha: 1)
                } else {
                    label?.textColor = UIColor(displayP3Red: 55/255, green: 65/255, blue: 81/255, alpha: 1)
                    backView.backgroundColor = UIColor(displayP3Red: 243/255, green: 244/255, blue: 246/255, alpha: 1)
                }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
