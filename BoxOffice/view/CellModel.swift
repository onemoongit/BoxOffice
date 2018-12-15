//
//  CellModel.swift
//  BoxOffice
//
//  Created by Hyeontae on 06/12/2018.
//  Copyright © 2018 onemoon. All rights reserved.
//

import UIKit

class MovieDatasCell: UITableViewCell{
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieAge: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieId: UILabel!
}

class MovieCollectionDataCell: UICollectionViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieAge: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieId: UILabel!
}

class FiveStars: UIView {
    @IBOutlet var starImages: [UIImageView]!
    
    func fillStarWithImage(_ inputRating: Double) {
        let preImageName: String = "ic_star_large_"
        let halfRating: Double = inputRating/2.0
        for order in 0...4 {
            let rating = halfRating - Double(order)
            if ( rating < 0.5 ){
                self.starImages[order].image = UIImage(named: "\(preImageName)empty")
            } else if ( 0.5 <= rating && rating < 1 ) {
                self.starImages[order].image = UIImage(named: "\(preImageName)half")
            } else {
                self.starImages[order].image = UIImage(named: "\(preImageName)full")
            }
        }
        
    }
}

class MovieDetailInformationCell: UITableViewCell {
    @IBOutlet weak var mainPosterImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainGradeImage: UIImageView!
    @IBOutlet weak var mainDateLabel: UILabel!
    @IBOutlet weak var mainGenreLabel: UILabel!
    @IBOutlet weak var leftInfoReservationRateLabel: UILabel!
    @IBOutlet weak var midInfoUserRatingLabel: UILabel!
    @IBOutlet weak var mainStarsView: UIView!
    @IBOutlet weak var rightInfoAudienceLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
}

class MovieCommentCell: UITableViewCell {
    @IBOutlet weak var writer: UILabel!
    @IBOutlet var starImages: [UIImageView]!
    @IBOutlet weak var timeString: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    func fillStarWithImageInt(_ inputRating: Int) {
        let preImageName: String = "ic_star_large_"
        for order in 0...4 {
            let temp: Int = inputRating - order*2
            if temp > 1 {
                self.starImages[order].image = UIImage(named: "\(preImageName)full")
            } else if temp == 1 {
                self.starImages[order].image = UIImage(named: "\(preImageName)half")
            } else {
                self.starImages[order].image = UIImage(named: "\(preImageName)empty")
            }
        }
    }
}

// hexcode Color
// 따로 빼자
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
