//
//  Navigatable.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import UIKit

protocol Navigatable {
    var navigationBarModel: NavigationBarModel { get }
    var isNavigationBarHidden: Bool { get }
    var isBackButtonHidden: Bool { get }

    func configureNavigationBar()
}

extension Navigatable where Self: UIViewController {
    func configureNavigationBar() {
        configureNavigationBarCentralItem()
        configureNavigationBarLeftItem()
        configureNavigationBarRightItems()
    }

    func configureNavigationBarVisibility() {
        navigationController?.navigationBar.isHidden = isNavigationBarHidden
        navigationItem.setHidesBackButton(isBackButtonHidden, animated: false)
    }

    private func configureNavigationBarCentralItem() {
        navigationController?.navigationBar.tintColor = R.color.iconPrimary()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = navigationBarModel.isLargeTitle ? .always : .never
        configureToolbarItem()
    }

    private func configureToolbarItem() {
        configureLargeTitleIfNeeded()
    }

    private func configureNavigationBarLeftItem() {
        navigationItem.backButtonDisplayMode = .minimal

        switch navigationBarModel.leftItemModel.type {
        case let .icon(icon):
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: icon,
                style: .plain,
                target: self,
                action: #selector(handleTapOnNavigationBarLeftItem)
            )
        case .back:
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: R.image.back24(),
                style: .plain,
                target: self,
                action: #selector(handleTapOnNavigationBarLeftItem)
            )
        case .empty:
            navigationItem.leftBarButtonItem = .none
            navigationItem.hidesBackButton = true
        case let .customView(view):
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
        case .textButton:
            break
        }

        navigationItem.leftBarButtonItem?.isEnabled = navigationBarModel.leftItemModel.isEnabled
    }

    private func configureNavigationBarRightItems() {
        var rightBarButtonItems: [UIBarButtonItem] = []

        for index in navigationBarModel.rightItemsModels.indices {
            let itemModel = navigationBarModel.rightItemsModels[index]

            switch itemModel.type {
            case .icon(let icon):
                let newBarButtonItem = UIBarButtonItem(
                    image: icon,
                    style: .plain,
                    target: self,
                    action: #selector(handleTapOnNavigationRightItem)
                )
                newBarButtonItem.isEnabled = itemModel.isEnabled
                newBarButtonItem.tag = index
                rightBarButtonItems.append(newBarButtonItem)
            case .empty, .back:
                break
            case let .customView(view):
                let newBarButtonItem = UIBarButtonItem(customView: view)
                newBarButtonItem.isEnabled = itemModel.isEnabled
                rightBarButtonItems.append(newBarButtonItem)
            case .textButton(let title):
                let newBarButtonItem = UIBarButtonItem(
                    title: title,
                    style: .plain,
                    target: self,
                    action: #selector(handleTapOnNavigationRightItem)
                )
                rightBarButtonItems.append(newBarButtonItem)
            }
        }

        navigationItem.rightBarButtonItems = rightBarButtonItems
    }

    private func configureLargeTitleIfNeeded() {
        if case .title(let title) = navigationBarModel.centralItemModel.type {
            navigationItem.title = title
        } else {
            navigationItem.title = nil
        }
    }
}

fileprivate extension UIViewController {
    @objc func handleTapOnNavigationBarLeftItem() {
        guard let self = self as? Navigatable else {
            return
        }

        switch self.navigationBarModel.leftItemModel.type {
        case .icon, .empty, .customView, .textButton:
            break
        case .back:
            navigationController?.popViewController(animated: true)
        }

        self.navigationBarModel.leftItemModel.onTapAction?()
    }

    @objc func handleTapOnNavigationRightItem(_ sender: UITabBarItem) {
        guard let self = self as? Navigatable else {
            return
        }

        self.navigationBarModel.rightItemsModels[sender.tag].onTapAction?()
    }
}
