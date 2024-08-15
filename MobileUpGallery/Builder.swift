//
//  Builder.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import UIKit

final class Builder {
    
    static func createWelcome() -> UIViewController {
        let router = WelcomeRouter()
        let presenter = WelcomePresenter(router: router)
        let view = WelcomeViewController(presenter: presenter)
        router.controller = view
        return view
    }
    
    static func createWebView() -> UIViewController {
        let router = LoginRouter()
        let presenter = LoginWebViewPresenter(router: router)
        let view = LoginWebViewController(presenter: presenter)
        presenter.view = view
        router.controller = view
        return view
    }
    
    static func createGallery() -> UIViewController {
        UIViewController()
    }
    
    
}
