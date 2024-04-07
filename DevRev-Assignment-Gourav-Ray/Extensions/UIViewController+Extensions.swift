import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    //Loader
    func showActivityIndicator(progressLabel:String = "") {
        MBProgressHUD.appearance().animationType = .fade
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
        progressHUD.label.numberOfLines = 2
        
    }
    
    func hideActivityIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if actions.isEmpty {
                // If no actions provided, add a default "OK" action
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
            } else {
                // Add custom actions if provided
                for action in actions {
                    alertController.addAction(action)
                }
            }
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func convertDateFormat(dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd, yyyy"
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func truncateStringIfNeeded(_ input: String) -> String {
        if input.count > 450 {
            let endIndex = input.index(input.startIndex, offsetBy: 450)
            return String(input.prefix(upTo: endIndex))
        }
        return input
    }
    
    func executeAfter(delay: TimeInterval, execute: @escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+delay, execute: {
            execute()
        })
    }
}

extension UIView {
    func addBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = ColorConstants.darkBlue.cgColor
        self.layer.cornerRadius = 20.0
    }
}

extension UICollectionView {
    func addBackgroundLabel(withText text:String) {
        let label = UILabel()
        label.center = self.center 
        label.frame.size = CGSize(width: UIScreen.main.bounds.size.width*0.7, height: 30.0)
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = .lightGray
        self.backgroundView = label
    }
}

/// LogsManager
class LogsManager {
    private init() {}
    static func consoleLog(message: String) {
        if AppConstants.Logs.enabled.value {
            print(message)
        }
    }
    static func consoleLog(_ data: Any) {
        if AppConstants.Logs.enabled.value {
            print(data)
        }
    }
}
