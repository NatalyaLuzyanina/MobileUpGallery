//
//  PhotoFeedFactory.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

enum PhotoFeedFactory {
    static func createPhotoFeedNavigationController() -> BaseNavigationController {
        let coordinator = PhotoFeedCoordinator()
        let viewModel = PhotoFeedViewModel(coordinator: coordinator)
        let controller = PhotoFeedController(viewModel: viewModel)
        coordinator.router = controller
        return BaseNavigationController(rootViewController: controller)
    }
}
