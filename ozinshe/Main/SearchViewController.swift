//
//  SearchViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 20.12.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchTextField: TextFieldWithPadding!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tableViewToLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewToCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var categories:[Category] = []
    var movies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        downloadCategories()
        
        // Do any additional setup after loading the view.
    }
    
    func configureViews() {
        searchTextField.padding.left = 16
        searchTextField.padding.right = 16
        
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 12
        searchTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 100
        collectionView.collectionViewLayout = layout
        
        // table view
        tableView.dataSource = self
        tableView.delegate = self
        let MovieCellNib = UINib (nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCellNib, forCellReuseIdentifier: "cell")
        
    }
    func downloadMovies() {
        guard let text = searchTextField.text else {return}
        if text.isEmpty {
            //pustoi
            topLabel.text = "Санаттар"
            //скрыть table view
            tableViewToLabelConstraint.priority = .defaultLow
            tableViewToCollectionViewConstraint.priority = .defaultHigh
            
            movies.removeAll()
            tableView.reloadData()
        } else {
            // ищем
            topLabel.text = "Іздеу нәтижелері"
            //показать table view
            tableViewToLabelConstraint.priority = .defaultHigh
            tableViewToCollectionViewConstraint.priority = .defaultLow
            
            let headers: HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
            
            let parameters = [ "search": text ]
            
            //ПОИСК ФИЛЬМОВ
            AF.request(
                Urls.SEARCH_MOVIES_URL,
                method: .get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers).responseData { response in SVProgressHUD.dismiss()
                    if response.response?.statusCode == 200 {
                        let json = JSON(response.data!)
                        if let items = json.array {
                            self.movies.removeAll()
                            self.tableView.reloadData()
                            for item in items {
                                let movie = Movie(json: item)
                                self.movies.append(movie)
                            }
                            self.tableView.reloadData()
                        }
                    } else { // error
                        var resultString = ""
                        if let data = response.data {
                            resultString += String(data: data, encoding: .utf8)!
                        }
                        SVProgressHUD.showError(withStatus: resultString)
                    }
            }
            
        }
    }
    
    func downloadCategories() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [ "Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        AF.request(Urls.CATEGORIES_URL, method: .get, headers: headers).responseData {
            response in
            SVProgressHUD.dismiss()
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                if let items = json.array {
                    for item in items {
                        let category = Category(json: item)
                        self.categories.append(category)
                    }
                    self.collectionView.reloadData()
                } else {
                    var resultString = ""
                    if let data = response.data {
                        resultString = String(data: data, encoding: .utf8)!
                    }
                    SVProgressHUD.showError(withStatus: resultString)
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        searchTextField.text = ""
        clearButton.isHidden = true
        downloadMovies()
        
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    @IBAction func textFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor =  UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.00).cgColor
    }
    @IBAction func editingChanged(_ sender: TextFieldWithPadding) {
        guard let text = sender.text else { return }
        // if let text = sender.text {  // и так тож можно и через guard можно
        clearButton.isHidden = text.isEmpty
        
        downloadMovies()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = categories[indexPath.row].name
        
        let backgroundview = cell.viewWithTag(1001)
        backgroundview!.layer.cornerRadius = 8
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       //экран CategoryTableViewController
        let categoryTableVC = storyboard?.instantiateViewController(withIdentifier: "CategoryTableVC") as! CategoryTableViewController
        
        //передаем id категорий
        categoryTableVC.categoryID = categories[indexPath.row].id
        
        //показываем экран
        navigationController?.show(categoryTableVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieTableViewCell
        cell.setData(movie: movies[indexPath.row])
        return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfoVC = storyboard?.instantiateViewController(identifier: "MovieInfoVC") as! MovieInfoViewController
        movieInfoVC.movie = movies[indexPath.row]
        
        navigationController?.pushViewController(movieInfoVC, animated: true)
    }
    }
  

    
    
    
