//
//  ImageLoadingRepository.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 01.11.2024.
//

import Foundation
import Kingfisher

final class ImageLoadingRepository {
    func loadImage(url: URL, completion: @escaping (Data?) -> Void) {
        KingfisherManager.shared.retrieveImage(
            with: url,
            options: nil,
            progressBlock: nil,
            completionHandler: {
                guard case .success(let successResult) = $0, let imageData = successResult.data() else {
                    return completion(nil)
                }
                completion(imageData)
            }
        )
    }
}
