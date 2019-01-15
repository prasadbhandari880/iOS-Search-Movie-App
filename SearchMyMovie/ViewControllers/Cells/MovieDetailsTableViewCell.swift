//
//  MovieDetailsTableViewCell.swift
//  SearchMyMovie
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieDescriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model:MovieDetailModel){
        if let name = model.movieName{
            self.movieNameLbl.text = name
        }
        if let date = model.movieReleaseDate{
            self.releaseDateLbl.text = date
        }
        if let des = model.movieDescription{
            self.movieDescriptionLbl.text = des
        }
        if let imgUrl = model.moviePosterUrl{
            weak var weakSelf = self
            MovieNetworkManager.sharedInstance.downloadAndCacheImage(url: imgUrl, OnCompletion: {image in
                weakSelf?.posterView.image = image
                weakSelf?.reloadInputViews()
            })
        }
    }
    
    override func prepareForReuse() {
        self.posterView.image = nil
    }
}
