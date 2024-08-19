//
//  NetworkService.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Alamofire
import Foundation

final class NetworkService {
    
    private let api = APIManager.shared
    
    static let shared = NetworkService()
    private init() {}
    
    func loadPhotos(completion: @escaping (Result<PhotoResponse, ErrorModel>) -> Void) {
        let url = APIManager.shared.createUrl(
            for: .getPhoto,
            queryItems: [.ownerId: api.ownerId]
        )
        let accessToken = KeychainStorage.shared.getToken()?.accessToken
        guard let url = url, let accessToken = accessToken else { return }
        
        let headers: HTTPHeaders = [.authorization("Bearer \(accessToken)")]
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: PhotoResponse.self) { response in
                switch response.result {
                case .success(let response):
                    UserDefaultsStorage.shared.set(response, forKey: .photosResponse)
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(.loadingError))
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    func loadVideos(completion: @escaping (Result<VideoResponse, ErrorModel>) -> Void) {
        let url = APIManager.shared.createUrl(
            for: .getVideo,
            queryItems: [.ownerId: api.ownerId]
        )
        let accessToken = KeychainStorage.shared.getToken()?.accessToken
        guard let url = url, let accessToken = accessToken else { return }
        
        let headers: HTTPHeaders = [.authorization(accessToken)]
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: VideoResponse.self) { response in
                switch response.result {
                case .success(let response):
                    UserDefaultsStorage.shared.set(response, forKey: .photosResponse)
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(.loadingError))
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    func getMockPhotos() -> PhotoResponse? {
        guard
            let path = Bundle.main.path(forResource: "mockPhotos", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        else { return nil }
        let items = try? JSONDecoder().decode(PhotoResponse.self, from: data)
        UserDefaultsStorage.shared.set(items, forKey: .photosResponse)
        return items
    }
    
    func getMockVideos() -> VideoResponse? {
        guard
            let path = Bundle.main.path(forResource: "mockVideo", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        else { return nil }
        let items = try? JSONDecoder().decode(VideoResponse.self, from: data)
        UserDefaultsStorage.shared.set(items, forKey: .videoResponse)
        return items
    }
}
