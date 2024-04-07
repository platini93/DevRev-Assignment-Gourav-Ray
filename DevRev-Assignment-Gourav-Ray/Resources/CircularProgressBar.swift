import UIKit

@IBDesignable
class CircularProgressBar: UIView {
    
    private var trackColor: UIColor = .lightGray
    public var progressColor: UIColor = .blue {
        didSet {
            trackColor = progressColor.withAlphaComponent(0.3)
        }
    }
    public var lineWidth: CGFloat = 12.0
    private var progressLabel: UILabel!
    
    var progress: CGFloat = 0.0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsDisplay()
                let labelText = "\(Int((self?.progress ?? 0.0) * 100))%"
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: labelText, attributes: [.font:UIFont.boldSystemFont(ofSize: 20.0)])
                attString.setAttributes([.font:UIFont.boldSystemFont(ofSize: 10.0),.baselineOffset:6], range: NSRange(location:2,length:1))
                self?.progressLabel.attributedText = attString
                if self?.progress ?? 0.0 >= 0.75 {
                    self?.progressColor = ColorConstants.pgGreen
                } else {
                    self?.progressColor = ColorConstants.pgYellow
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        progressLabel = UILabel(frame: bounds)
        progressLabel.textAlignment = .center
        progressLabel.textColor = .white
        progressLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        addSubview(progressLabel)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth
        
        
        let backgroundPath = UIBezierPath(arcCenter: center, radius: radius+4, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        ColorConstants.darkBlue.setFill()
        backgroundPath.fill()
        
        
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackColor.setStroke()
        trackPath.lineWidth = lineWidth
        trackPath.stroke()
        
        
        let endAngle = CGFloat.pi * 2 * progress - CGFloat.pi / 2
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: endAngle, clockwise: true)
        progressColor.setStroke()
        progressPath.lineWidth = lineWidth
        progressPath.lineCapStyle = .round
        progressPath.stroke()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLabel.frame = bounds
    }
    
}

