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
        presentScreen(vc)
    }
}
