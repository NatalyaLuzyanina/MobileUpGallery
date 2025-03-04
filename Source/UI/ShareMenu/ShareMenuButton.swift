//
//  ShareMenuButton.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 01.11.2024.
//

import SwiftUI

struct ShareMenuButton: View {
    let imageForSharing: Image?
    let urlForSharing: URL?
    let previewIcon: Image

    var body: some View {
        if let imageForSharing = imageForSharing {
            ShareLink(
                item: imageForSharing,
                preview: SharePreview(R.string.shareMenu.shareMenuTitle(), image: R.image.mobileUp40.swiftUiImage),
                label: { previewIcon }
            )
        }
        if let urlForSharing = urlForSharing {
            ShareLink(
                item: urlForSharing,
                preview: SharePreview(R.string.shareMenu.shareMenuTitle(), image: R.image.mobileUp40.swiftUiImage),
                label: { previewIcon }
            )
        }
    }
}
