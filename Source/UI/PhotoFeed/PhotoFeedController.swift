//
//  PhotoFeedController.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 31.10.2024.
//

final class PhotoFeedController: HostingController<PhotoFeedView> {
    init(viewModel: PhotoFeedViewModel) {
        super.init(rootView: PhotoFeedView(viewModel: viewModel))

        let rightItemModel = NavigationBarSideItemModel(
            type: .textButton(R.string.photoFeed.photoFeedBarButtonTitle())
        ) {
            viewModel.handleTapOnLogout()
        }

        let title = R.string.photoFeed.photoFeedTitle()
        let centralItemModel = NavigationBarCentralItemModel(type: .title(title))
        navigationBarModel = NavigationBarModel(
            centralItemModel: centralItemModel,
            rightItemsModels: [rightItemModel]
        )
    }
}
