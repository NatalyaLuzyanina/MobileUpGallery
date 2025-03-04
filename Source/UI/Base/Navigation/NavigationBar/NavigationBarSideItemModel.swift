//
//  NavigationBarSideItemModel.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import UIKit

struct NavigationBarSideItemModel {
    enum ItemType {
        case icon(UIImage)
        case textButton(String)
        case back
        case empty
        case customView(UIView)
    }

    let type: ItemType
    let isEnabled: Bool
    let onTapAction: (() -> Void)?

    init(type: ItemType, isEnabled: Bool = true, onTapAction: (() -> Void)? = nil) {
        self.type = type
        self.onTapAction = onTapAction
        self.isEnabled = isEnabled
    }
}
