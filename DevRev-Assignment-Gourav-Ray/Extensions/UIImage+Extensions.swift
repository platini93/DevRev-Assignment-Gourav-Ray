import UIKit

extension UIImage {
    static func verticalGradientImage(colors: [UIColor], size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor } as CFArray
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil) else { return nil }
        
        let startPoint = CGPoint(x: size.width / 2, y: 0)
        let endPoint = CGPoint(x: size.width / 2, y: size.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


