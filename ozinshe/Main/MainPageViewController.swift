//
//  MainPageViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 11.12.2023.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MovieProtocol {
    
    
    @IBOutlet weak var tableView: UITableView!
    //    var bannerMovies: [BannerMovie] = []
    //    var historyMovies: [Movie] = []
    
    var mainMovies: [MainMovies] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        downloadMainBanners()
        addNavBarImage()
        
        
        // Do any additional setup after loading the view.
    }
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    func addNavBarImage() {
        let image = UIImage(named: "mainLogo")
        let logoImageView = UIImageView(image: image)
        let imageItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = imageItem
    }
    
    func downloadMainBanners() {
        let headers:HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        SVProgressHUD.show()
        
        AF.request(Urls.MAIN_BANNERS_URL, method: .get, headers: headers).responseData { response  in SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                if let movies = json.array {
                    let bannersMovies = MainMovies()
                    bannersMovies.cellType = .mainBanner
                    for movie in movies {
                        let movieItem = BannerMovie(json: movie)
                        bannersMovies.bannerMovies.append(movieItem)
                        
                    }
                    self.mainMovies.append(bannersMovies)
                    self.tableView.reloadData()
                    self.downloadHistory()
                }
                
            } else {
                
            }
        }
    }
    func downloadHistory() {
        let headers:HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        SVProgressHUD.show()
        
        AF.request(Urls.USER_HISTORY_URL, method: .get, headers: headers).responseData { response  in SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                if let movies = json.array {
                    let historyMovies = MainMovies()
                    historyMovies.cellType = .userHistory
                    for movie in movies {
                        let movieItem = Movie(json: movie)
                        historyMovies.movies.append(movieItem)
                        
                    }
                    self.mainMovies.append(historyMovies)
                    self.tableView.reloadData()
                    self.downloadMainMovies()
                }
                
            } else {
                
            }
        }
    }
    
    func downloadMainMovies() {
        let headers:HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        SVProgressHUD.show()
        
        AF.request(Urls.MAIN_MOVIES_URL, method: .get, headers: headers).responseData { response  in SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                if let mainMovies = json.array {
                    for mainMovieItem in mainMovies {
                        let mainMovie = MainMovies(json: mainMovieItem)
                        self.mainMovies.append(mainMovie)
                    }
                    self.tableView.reloadData()
                    self.downloadGenres()
                }
                
            } else {
                
            }
        }
    }
    
    func downloadGenres() {
        let headers:HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        SVProgressHUD.show()
        
        AF.request(Urls.GET_GENRES, method: .get, headers: headers).responseData { response  in SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                
                let json = JSON(response.data!)
                if let genres = json.array {
                    let genres1 = MainMovies()
                    genres1.cellType = .genre
                    for genreJSON in genres {
                        let genreItem = Genre(json: genreJSON)
                        genres1.genres.append(genreItem)
                    }
                    self.mainMovies.append(genres1)
                    self.tableView.reloadData()
                    self.downloadCategoryAges()
                }
                
            } else {
            }
        }
    }
    
    // step 5
    func downloadCategoryAges() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.GET_AGES, method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .ageCategory
                    for item in array {
                        let ageCategory = CategoryAge(json: item)
                        movie.categoryAges.append(ageCategory)
                    }
                        self.mainMovies.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                }
            }
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mainMovies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let mainMovie = mainMovies[indexPath.row]
            
            if mainMovie.cellType == .mainBanner{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainBannerCell") as! MainBannerCell
                cell.setData(movies: mainMovie.bannerMovies)
                cell.delegate = self
                return cell
            }
            if mainMovie.cellType == .userHistory {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryTableViewCell
                cell.setData(movies: mainMovie.movies)
               cell.delegate = self
                return cell
            }
            if mainMovies[indexPath.row].cellType == .genre || mainMovies[indexPath.row].cellType == .ageCategory {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GenreAgeCell") as! GenreAgeTableViewCell
                cell.setData(movies: mainMovies[indexPath.row])

                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
            cell.setData(movies: mainMovie)
            cell.delegate = self
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let mainMovie = mainMovies[indexPath.row]
            if mainMovie.cellType == .mainBanner {
                return 272
            }
            if mainMovie.cellType == .userHistory {
                return 228
            }
            if mainMovie.cellType == .genre || mainMovie.cellType == .ageCategory {
                return 184
            }
            return 296
        }
    
    func movieDidSelect(movie: Movie) {
        let movieInfoVC = storyboard?.instantiateViewController(identifier: "MovieInfoVC") as! MovieInfoViewController
        movieInfoVC.movie = movie
        
        navigationController?.pushViewController(movieInfoVC, animated: true)
    }

    }

