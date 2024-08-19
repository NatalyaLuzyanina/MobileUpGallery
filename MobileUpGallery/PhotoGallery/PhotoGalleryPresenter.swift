//
//  PhotoGalleryPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

protocol PhotoGalleryPresenterProtocol: AnyObject {
    func showDetailPhoto(id: Int)
    func loadData()
}

final class PhotoGalleryPresenter: PhotoGalleryPresenterProtocol {
    
    private let router: PhotoGalleryRouterProtocol
    weak var view: PhotoGalleryViewControllerProtocol?
    
    init(router: PhotoGalleryRouterProtocol) {
        self.router = router
    }
    
    func loadData() {
        NetworkService.shared.loadPhotos { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.updateView(with: response.response.items)
                }
            case .failure(let error):
//                if let mockData = NetworkService.shared.getMockPhotos() {
//                    self?.updateView(with: mockData.response.items)
//                }
                
                self?.view?.showError(
                    title: error.title,
                    message: error.message
                )
            }
        }
    }
    
    func updateView(with photos: [PhotoItem]) {
        let photos: [PhotoModel] = photos.compactMap { item in
            guard let url = item.mediumSize?.url else {
                return nil
            }
            return PhotoModel(id: item.id, url: url)
        }
        let model: PhotoGalleryModel = .init(photos: photos)
        view?.updateView(with: model)
    }
    
    func showDetailPhoto(id: Int) {
        router.showPhoto(id: id)
    }
}
