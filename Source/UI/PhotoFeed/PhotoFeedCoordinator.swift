//
//  PhotoFeedCoordinator.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

final class PhotoFeedCoordinator {
    weak var router: (NavigationRouter & RootRouter)?

    func openLoginScreen() {
        let controller = LoginFactory.createLoginViewController()
        router?.updateRootViewController(viewController: controller)
    }

    func openDetailPhotoScreen(with model: PhotoFeedModel) {
        let controller = DetailPhotoFactory.createDetailPhotoController(with: model)
        controller.hidesBottomBarWhenPushed = true
        router?.push(controller: controller, animated: true)
    }
}
