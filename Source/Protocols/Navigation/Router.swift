//
//  Router.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

import UIKit

protocol Router: AnyObject {}

protocol PresentationRouter: Router {
    func present(controller: UIViewController, completion: (() -> Void)?)
    func dismiss()
}

protocol NavigationRouter: Router {
    func push(controller: UIViewController, animated: Bool)
    func popToRoot(isAnimated: Bool)
    func pop()
}

protocol RootRouter: Router {
    func updateRootViewController(viewController: UIViewController)
}
