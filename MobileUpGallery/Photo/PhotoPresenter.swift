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
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func loadData() {
        let photo = NetworkService.shared.fetchPhoto(with: id)
      
        guard
            let url = photo?.largeSize?.url,
            let dateString = photo?.date.formatToTextString() 
        else {
            // show error
            return
        }
        let model = DetailPhotoModel(date: dateString, imageUrl: url)
        view?.updateView(with: model)
    }
    
   
}
