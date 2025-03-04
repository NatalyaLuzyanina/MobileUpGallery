//
//  NavigationBarCentralItemModel.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

struct NavigationBarCentralItemModel {
    enum ItemType {
        case title(String)
        case empty
    }

    let type: ItemType
    var onTapAction: (() -> Void)?
}
