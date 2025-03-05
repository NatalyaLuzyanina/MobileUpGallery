//
//  PhotoFeedViewModel.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

import SwiftUI

final class PhotoFeedViewModel: ObservableObject, ToastViewUsable {
    @Published var items: [PhotoFeedItem] = []
    @Published var isToastViewDisplayed = false
    @Published var toastMessage = ""

    private let coordinator: PhotoFeedCoordinator
    private let authRepository = AuthRepository()
    private let feedRepository = PhotoFeedRepository()
    private var photoModels: [PhotoFeedModel] = []

    init(coordinator: PhotoFeedCoordinator) {
        self.coordinator = coordinator
        loadPhotos()
    }

    func handleTapOnItem(id: Int) {
        if let item = photoModels.first(where: { $0.id == id }) {
            coordinator.openDetailPhotoScreen(with: item)
        }
    }

    func loadPhotos() {
        feedRepository.getAllPhoto { [weak self] in
            switch $0 {
            case .success(let value):
                self?.photoModels = value.response.items
                self?.updatePhotoItems()
            case .failure:
                self?.showToastWithMessage(R.string.photoFeed.photoFeedError())
            }
        }
    }

    func handleTapOnLogout() {
        authRepository.logout { [weak self] in
            switch $0 {
            case .success:
                self?.coordinator.openLoginScreen()
            case .failure:
                self?.showToastWithMessage(R.string.photoFeed.photoFeedError())
            }
        }
    }

    private func updatePhotoItems() {
        let items: [PhotoFeedItem] = photoModels.compactMap { item in
            guard let urlString = item.sizes.max(by: { $0.width < $1.width })?.url,
                  let url = URL(string: urlString) else {
                return nil
            }
            return PhotoFeedItem(id: item.id, imageUrl: url)
        }
        self.items = items
    }
}
