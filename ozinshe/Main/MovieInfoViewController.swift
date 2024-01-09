//
//  MainInfoViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 16.12.2023.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD
import SwiftyJSON

class MovieInfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var produserLabel: UILabel!
    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var seasonsButton: UIButton!
    @IBOutlet weak var seasonsImage: UIImageView!
    @IBOutlet weak var screenshotsLabelToLineConstraint: NSLayoutConstraint!
    @IBOutlet weak var screenshotsLabelToLableConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullDescriptionButton: UIButton!
    @IBOutlet weak var descriptionGradientView: GradientView!
    @IBOutlet weak var screenshotColllectionView: UICollectionView!
    var movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setData()
       
    }
    
    
    func configureViews() {
        //zakrutit ugli backgroundView
        backgroundView?.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true // chtob za predel ne vihodil
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        screenshotColllectionView.dataSource = self
        screenshotColllectionView.delegate = self
        renderFavoriteButton()
    }
        
        func renderFavoriteButton() {
        //zakrasit favorite esli dobavleno
        if movie.favorite {
        //zakrasit favoriteSelected nazvanie v Assets!!!
        favoriteButton.setImage(UIImage(named: "favoriteSelected"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "save"), for: .normal)
        }
        
    }
    func setData() {
        // pokazat kontent
        posterImageView.sd_setImage(with: URL(string: movie.poster_link))
        titleLabel.text = movie.name
        subtitleLabel.text = "\(movie.year)•\(movie.genres.first?.name ?? "")"
        discriptionLabel.text = movie.description
        directorLabel.text = movie.director
        produserLabel.text = movie.producer
        
        //ogranichit kolichestvo strok y Label
        discriptionLabel.numberOfLines = 4
        if discriptionLabel.maxNumberOfLines < 5 {
            fullDescriptionButton.isHidden = true
            descriptionGradientView.isHidden = true
        }
        
        // skrit knopky sezonov y filma
        if movie.movieType == "MOVIE" {
            seasonsLabel.isHidden = true
            seasonsButton.isHidden = true
            seasonsImage.isHidden = true
            screenshotsLabelToLineConstraint.priority = .defaultHigh
            screenshotsLabelToLableConstraint.priority = .defaultLow
        } else {
            seasonsButton.setTitle("\(movie.seasonCount) сезон, \(movie.seriesCount) серия", for: .normal)
        }
    }
    
    @IBAction func showDescription(_ sender: Any) {
        if discriptionLabel.numberOfLines == 4 {
            //pokazat
            discriptionLabel.numberOfLines = 0
            fullDescriptionButton.setTitle("Zhasiry", for: .normal)
            descriptionGradientView.isHidden = true
        }else{
            //skrit
            discriptionLabel.numberOfLines = 4
            fullDescriptionButton.setTitle("Zhasiry", for: .normal)
            descriptionGradientView.isHidden = false
        }
    }
    
    @IBAction func playButton(_ sender: Any) {
        if movie.movieType == "MOVIE" {
            //otkryt player dlya filma
            let playerVC = storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerVC.videoId = movie.video_link
            
            navigationController?.pushViewController(playerVC, animated: true)
        } else {
            //otkrit vibor sezonov serii
            let seasonsVC = storyboard?.instantiateViewController(withIdentifier: "SeasonsViewController") as! SeasonsViewController
            seasonsVC.movie = movie
            navigationController?.pushViewController(seasonsVC, animated: true)
        }
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        var method = HTTPMethod.post
        if movie.favorite {
            method = .delete
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        let parameters: [String: Any] = [
            "movieId": movie.id]
        SVProgressHUD.show()
        AF.request(Urls.ADD_Favorite_URL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            if (200..<300).contains (response.response?.statusCode ?? -1) {
                self.movie.favorite.toggle()
                self.renderFavoriteButton()
            } else {
                //oshibka
                SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
            }
            
        }
    }
    
    @IBAction func shareMovie(_ sender: Any) {
        let items: [Any] = [posterImageView.image ?? UIImage(named: "Avatar")!,
                            movie.name, ]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present (ac, animated: true)
    }
    

@objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movie.screenshots.count
 
}
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    let imageView = Cell.viewWithTag(1000) as! UIImageView
    imageView.layer.cornerRadius = 8
    imageView.sd_setImage(with: URL(string: movie.screenshots[indexPath.row].link))
    return Cell
}
}
