//
//  BannerCell.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 11.12.2023.
//

import UIKit
import SDWebImage

class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 12
        categoryView.layer.cornerRadius = 8
        
    }
    func setData(movie: BannerMovie) {
        titleLabel.text = movie.movie.name
        descriptionLabel.text = movie.movie.description
        categoryLabel.text = movie.movie.categories.first?.name
        imageView.sd_setImage(with: URL(string: movie.link)!)
    }
}
