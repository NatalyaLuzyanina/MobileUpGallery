//
//  Router.swift
//  MobileUpGallery
//
//  Created by Natalia on 14.08.2024.
//

import UIKit

class Router {
    weak var controller: UIViewController?
    
    func pushScreen(_ vc: UIViewController) {
        guard let controller else {
            return
        }
        if let navController = controller.navigationController {
            navController.pushViewController(vc, animated: true)
        } else {
            presentScreen(vc)
        }
    }
    
    func presentScreen(_ vc: UIViewController) {
        if let window = controller?.view.window {
            window.rootViewController = vc
        }
    }
}
