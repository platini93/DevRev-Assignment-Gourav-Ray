import UIKit

class MovieDetailsTop: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var progreesBar: CircularProgressBar!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseDateView: UIView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var genresLbl: UILabel!
    
    var voteAvg:Double = 0.0 {
        didSet {
            self.progreesBar.progress = voteAvg/10
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImage.addBorder()
        progreesBar.lineWidth = 5.0
        posterImage.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
