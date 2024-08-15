//
//  WelcomeRouter.swift
//  MobileUpGallery
//
//  Created by Natalia on 14.08.2024.
//

import Foundation

protocol WelcomeRouterProtocol {
    func showLoginWebView()
}

final class WelcomeRouter: Router, WelcomeRouterProtocol {
    
    func showLoginWebView() {
        presentScreen(Builder.createWebView())
    }
}
