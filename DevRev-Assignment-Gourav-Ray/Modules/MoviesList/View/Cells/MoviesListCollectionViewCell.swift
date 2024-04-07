//
//  MoviesListCollectionViewCell.swift
//  DevRev-assignment-Gourav_Ray
//
//  Created by Gourav Ray on 04/04/24.
//

import UIKit

class MoviesListCollectionViewCell: UICollectionViewCell {
    
    var voteAvg:Double = 0.0 {
        didSet {
            self.ratingView.progress = voteAvg/10
        }
    }
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingView: CircularProgressBar!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var lblStack: UIStackView!
    @IBOutlet weak var releaseDataLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.addBorder()
        ratingView.lineWidth = 5.0
    }
}
