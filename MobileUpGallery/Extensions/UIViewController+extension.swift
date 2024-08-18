//
//  UIViewController+extension.swift
//  MobileUpGallery
//
//  Created by Natalia on 18.08.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, needsOkAction: Bool = true) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        if needsOkAction {
            let action = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
        guard !needsOkAction else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
