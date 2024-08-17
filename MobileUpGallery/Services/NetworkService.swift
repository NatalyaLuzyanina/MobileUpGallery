//
//  NetworkService.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
   
    func loadPhotos(completion: @escaping (Result<PhotoResponse, Error>) -> Void) {
        if let path = Bundle.main.path(forResource: "mockPhotos", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let items = try JSONDecoder().decode(PhotoResponse.self, from: data)
                    
                    UserDefaultsStorage.shared.set(items, forKey: .photosResponse)
                    completion(.success(items))
                } catch {
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchPhoto(with id: Int) -> Photo? {
        guard let photos: PhotoResponse = UserDefaultsStorage.shared.get(.photosResponse) else {
            return nil
        }
        let photo = photos.photos.first(where: { $0.id == id })
        return photo
    }

    
}
