//
//  Builder.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import UIKit

final class Builder {
    
    static func createLogin() -> UIViewController {
        let router = LoginRouter()
        let presenter = LoginPresenter(router: router)
        let view = LoginViewController(presenter: presenter)
        router.controller = view
        return view
    }
    
    static func createGallery() -> UIViewController {
        GalleryContainerViewController()
    }
    
    
}
