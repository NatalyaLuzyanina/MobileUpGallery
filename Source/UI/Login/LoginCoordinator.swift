//
//  LoginCoordinator.swift
//  mobileUpGallery
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

final class LoginCoordinator<RouterType: RootRouter> {
    weak var router: RouterType?

    func openRootTabBarController() {
        let controller = RootTabBarFactory.createRootTabBarController()
        router?.updateRootViewController(viewController: controller)
    }
}
