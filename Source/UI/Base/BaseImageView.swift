//
//  BaseImageView.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

import Kingfisher
import SwiftUI

struct BaseImageView: View {
    let imageUrl: URL?

    var body: some View {
        KFImage.url(imageUrl)
            .placeholder { R.image.picture24.swiftUiImage }
            .resizable()
            .cacheOriginalImage(true)
            .fade(duration: 0.3)
    }
}
