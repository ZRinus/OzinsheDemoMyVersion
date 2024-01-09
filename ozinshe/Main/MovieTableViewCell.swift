//
//  MovieTableViewCell.swift
//  ozinshe
//
//  Created by Rinat Zaripov on 11.12.2023.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var playView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.layer.cornerRadius = 8
        playView.layer.cornerRadius = 8
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(movie: Movie) {
        posterImage.sd_setImage(with: URL(string: movie.poster_link))
        
        nameLabel.text = movie.name
        yearLabel.text = "\(movie.year)"
        
    }
}
