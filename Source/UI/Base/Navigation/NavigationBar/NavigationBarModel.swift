//
//  NavigationBarModel.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

struct NavigationBarModel {
    static let `default` = Self()

    var centralItemModel: NavigationBarCentralItemModel
    var leftItemModel: NavigationBarSideItemModel
    var rightItemsModels: [NavigationBarSideItemModel]
    var isLargeTitle: Bool

    init(
        centralItemModel: NavigationBarCentralItemModel = NavigationBarCentralItemModel(type: .empty),
        leftItemModel: NavigationBarSideItemModel = NavigationBarSideItemModel(type: .empty),
        rightItemsModels: [NavigationBarSideItemModel] = [],
        isLargeTitle: Bool = false
    ) {
        self.centralItemModel = centralItemModel
        self.leftItemModel = leftItemModel
        self.rightItemsModels = rightItemsModels
        self.isLargeTitle = isLargeTitle
    }
}
