//
//  PhotoFeedRepository.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 01.11.2024.
//

import Foundation

enum PhotoFeedRepositoryError: Error {
    case unknown
    case authorizationRequired
}

final class PhotoFeedRepository: NSObject, NetworkRepository {
    private enum Constants {
        static let getPhotoBaseUrl = "https://api.vk.com"
        static let getPhotoEndpoint = "/method/photos.getAll"
    }

    typealias NetworkRepositoryError = PhotoFeedRepositoryError

    let unknownError: PhotoFeedRepositoryError = .unknown
    let authorizationRequiredError: PhotoFeedRepositoryError = .authorizationRequired

    func getAllPhoto(completion: @escaping (Result<PhotoResponse, PhotoFeedRepositoryError>) -> Void) {
        let query = [
            ServerInteractableQueryItem(name: "owner_id", value: "-128666765"),
            ServerInteractableQueryItem(name: "v", value: "5.199")
        ]

        let parameters = ServerInteractableRequestParameters(
            method: .get,
            query: query
        )

        makeRequest(
            type: PhotoResponse.self,
            url: Constants.getPhotoBaseUrl,
            endpoint: Constants.getPhotoEndpoint,
            parameters: parameters,
            isAuthRequired: true,
            errorMapper: nil,
            completion: completion
        )
    }
}
