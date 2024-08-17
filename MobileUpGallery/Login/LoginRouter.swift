//
//  LoginRouter.swift
//  MobileUpGallery
//
//  Created by Natalia on 14.08.2024.
//

import UIKit

protocol LoginRouterProtocol {
    func showGallery()
}

final class LoginRouter: Router, LoginRouterProtocol {
    
    func showGallery() {
        let vc = Builder.createGallery()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let windowDelegate = windowScene.delegate as? SceneDelegate {
            let window = windowDelegate.window
            window?.rootViewController = vc
        }
    }
}
