//
//  PhotoPresenter.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

protocol PhotoPresenterProtocol {
    func loadData()
}

final class PhotoPresenter: PhotoPresenterProtocol {
    
    weak var view: PhotoViewControllerProtocol?
    private let storage =  UserDefaultsStorage.shared
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func loadData() {
        guard
            let photos: PhotoResponse = storage.get(.photosResponse),
            let photo = photos.photos.first(where: { $0.id == id }),
            let url = photo.largeSize?.url
        else {
            view?.showError(.loadingError)
            return
        }
       
        let dateString = photo.date.formatToTextString()
        let model = DetailPhotoModel(date: dateString, imageUrl: url)
        view?.updateView(with: model)
    }
    
   
}
