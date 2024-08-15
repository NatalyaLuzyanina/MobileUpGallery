//
//  WelcomePresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import Foundation

protocol WelcomePresenterProtocol: AnyObject {
    func startLogin()
}

final class WelcomePresenter: WelcomePresenterProtocol {
    
    private let router: WelcomeRouterProtocol
    
    init(router: WelcomeRouterProtocol) {
        self.router = router
    }
    
    func startLogin() {
        router.showLoginWebView()
    }

}
