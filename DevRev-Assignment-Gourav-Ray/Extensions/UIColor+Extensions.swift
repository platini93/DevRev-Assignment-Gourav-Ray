import UIKit
import NetworkFramework

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        if Scanner(string: hexSanitized).scanHexInt64(&rgb) {
            let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgb & 0x0000FF) / 255.0

            self.init(red: red, green: green, blue: blue, alpha: alpha)
            return
        }

        self.init(red: 0, green: 0, blue: 0, alpha: alpha)
    }
}



