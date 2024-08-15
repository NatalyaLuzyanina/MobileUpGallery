//
//  LoginRouter.swift
//  MobileUpGallery
//
//  Created by Natalia on 15.08.2024.
//

import Foundation
import UIKit

protocol LoginRouterProtocol {
    func showGallery()
}

final class LoginRouter: Router, LoginRouterProtocol {
    func showGallery() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let windowDelegate = windowScene.delegate as? SceneDelegate {
            let window = windowDelegate.window
            window?.rootViewController = Builder.createGallery()
        }
        
    }
}
