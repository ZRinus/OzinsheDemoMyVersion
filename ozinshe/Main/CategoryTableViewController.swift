//
//  CategoryTableViewController.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 20.12.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CategoryTableViewController: UITableViewController {
    var movies: [Movie] = []
    var categoryID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let MovieCellNin = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCellNin, forCellReuseIdentifier: "cell")
        
        downloadMovies()
    }
    func downloadMovies() {
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(Storage.sharedInstance.accessToken)"]
        
        let parameters = [ "categoryId": categoryID ]
        
        //ПОИСК ФИЛЬМОВ
        AF.request(
            Urls.MOVIES__BY_CATEGORY_URL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers).responseData { response in
                SVProgressHUD.dismiss()
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    if let items = json["content"].array {
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
    

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell

        // Configure the cell...
        cell.setData(movie: movies[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfoVC = storyboard?.instantiateViewController(identifier: "MovieInfoVC") as! MovieInfoViewController
        movieInfoVC.movie = movies[indexPath.row]
        
        navigationController?.pushViewController(movieInfoVC, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
