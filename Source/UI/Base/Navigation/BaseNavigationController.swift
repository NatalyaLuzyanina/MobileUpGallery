//
//  BaseNavigationController.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import UIKit

// Используем этот базовый класс чтобы включить жест смахивания назад
// Жест смахивания назад отключен реализацией HostingController
final class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    var isBackSwipeEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return isBackSwipeEnabled && viewControllers.count > 1
    }
}
