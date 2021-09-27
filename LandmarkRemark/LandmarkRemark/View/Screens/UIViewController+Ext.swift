//
//  UIViewController+Ext.swift
//  LandmarkRemark
//
//  Created by Arvin on 24/9/21.
//

import UIKit

extension UIViewController {
    /**
     * Property to represent navigation bar height for view controllers.
     */
    var topBarHeight: CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        
        if #available(iOS 13.0, *) {
            top += UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        
        return top
    }
    
    /**
     * Show alert using the passed title and message.
     *
     * - Parameters:
     *      - title: Title of the alert
     *      - message: Information message showing the reason for the alert
     *      - buttonTitle: Title of the button to dismiss the alert
     */
    func presentAlert(withTitle title: String, andMessage message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: buttonTitle, style: .cancel)
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        }
    }
}
