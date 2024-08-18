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
    
   
    func loadPhotos(completion: @escaping (Result<PhotoResponse, ErrorModel>) -> Void) {
        if let path = Bundle.main.path(forResource: "mockPhotos", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let items = try JSONDecoder().decode(PhotoResponse.self, from: data)
                    
                    UserDefaultsStorage.shared.set(items, forKey: .photosResponse)
                    completion(.success(items))
                } catch {
                    completion(.failure(.loadingError))
                    print(error.localizedDescription)
                }
            } catch {
                completion(.failure(.loadingError))
                print(error.localizedDescription)
            }
        }
    }
    
    func loadVideos(completion: @escaping (Result<VideoResponseData, ErrorModel>) -> Void) {
        if let path = Bundle.main.path(forResource: "mockVideo", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let items = try JSONDecoder().decode(VideoResponse.self, from: data)
                
                UserDefaultsStorage.shared.set(items, forKey: .videoResponse)
                completion(.success(items.response))
            } catch {
                completion(.failure(.loadingError))
                print(error.localizedDescription)
            }
        }
    }
    

    
    
}
