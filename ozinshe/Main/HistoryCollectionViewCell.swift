//
//  HistoryCollectionViewCell.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 16.12.2023.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastPartLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 12
        
    }
    func setData(movie: Movie) {
        titleLabel.text = movie.name
        lastPartLabel.text = movie.categories.first?.name ?? ""
        imageView.sd_setImage(with: URL(string: movie.poster_link)!)
    }
}
