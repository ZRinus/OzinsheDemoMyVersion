//
//  HistoryTableViewCell.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 11.12.2023.
//

import UIKit

class HistoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [Movie] = []
    var delegate: MovieProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // titleLabel.text = "HISTORY_TITLE".localized()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HistoryCollectionViewCell
        cell.setData(movie: movies[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.movieDidSelect(movie: movies[indexPath.row])
    }
}
