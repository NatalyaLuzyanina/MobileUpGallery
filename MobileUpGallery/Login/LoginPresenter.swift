//
//  LoginPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import Foundation

protocol LoginPresenterProtocol: AnyObject {
    func startLogin()
}

final class LoginPresenter: LoginPresenterProtocol {
    
    weak var view: LoginViewControllerProtocol?
    private let router: LoginRouterProtocol
    
    init(router: LoginRouterProtocol) {
        self.router = router
    }
    
    func startLogin() {
        AuthService.shared.startAuthSession(completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.router.showGallery()
            case .failure(let error):
                self?.view?.showError(error)
            }
        })
    }

}
