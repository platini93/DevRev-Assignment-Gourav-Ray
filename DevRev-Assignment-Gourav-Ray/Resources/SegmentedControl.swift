import UIKit

class SegmentedControl: UISegmentedControl {
    private(set) lazy var radius:CGFloat = bounds.height / 2
    private var segmentInset: CGFloat = 0.1{
        didSet{
            if segmentInset == 0{
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.backgroundColor = .white
        self.layer.borderColor = ColorConstants.darkBlue.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView
        {
            selectedImageView.backgroundColor = ColorConstants.darkBlue
            selectedImageView.image = nil
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = self.radius + 3
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
}
