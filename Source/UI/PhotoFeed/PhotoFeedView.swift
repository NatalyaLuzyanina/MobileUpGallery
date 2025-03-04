//
//  PhotoFeedView.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

import SwiftUI

struct PhotoFeedItem {
    let id: Int
    let imageUrl: URL
}

struct PhotoFeedView: View {
    @ObservedObject var viewModel: PhotoFeedViewModel

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    PhotoGridView(
                        gridItemSize: (geometry.size.width - 24) / 2,
                        items: viewModel.items,
                        itemTapHandler: viewModel.handleTapOnItem
                    )
                }
            }
            ToastView(isPresented: $viewModel.isToastViewDisplayed, message: viewModel.toastMessage)
        }
    }
}

struct PhotoGridView: View {
    let gridItemSize: CGFloat
    let items: [PhotoFeedItem]
    let itemTapHandler: (Int) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
            ForEach(items, id: \.id) { item in
                BaseImageView(imageUrl: item.imageUrl)
                    .scaledToFill()
                    .frame(width: gridItemSize, height: gridItemSize)
                    .clipped()
                    .onTapGesture { itemTapHandler(item.id) }
            }
        }
        .padding(8)
    }
}

struct PhotoFeedView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoFeedView(
            viewModel: PhotoFeedViewModel(
                coordinator: PhotoFeedCoordinator()
            )
        )
    }
}
