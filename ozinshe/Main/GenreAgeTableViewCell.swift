//
//  GenreAgeTableViewCell.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 16.12.2023.
//

import UIKit

class GenreAgeTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
   
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mainMovie = MainMovies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setData(movies: MainMovies) {
        self.mainMovie = movies
        collectionView.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mainMovie.cellType == .ageCategory {
            return mainMovie.categoryAges.count
        }
        return mainMovie.genres.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //  let genreItem = mainMovie.genres[indexPath.row]
        
        let genreLabel = cell.viewWithTag(1001) as! UILabel
        let imageView = cell.viewWithTag(1000) as! UIImageView
        
        if mainMovie.cellType == .ageCategory {
            imageView.sd_setImage(with: URL(string: mainMovie.categoryAges[indexPath.row].link), placeholderImage: nil)
            genreLabel.text = mainMovie.categoryAges[indexPath.row].name
        } else {
            imageView.sd_setImage(with: URL(string: mainMovie.genres[indexPath.row].link), placeholderImage: nil)
        genreLabel.text = mainMovie.genres[indexPath.row].name
        
    }
        return cell
    }
}
