//
//  AppDelegate.swift
//  MobileUpGallery
//
//  Created by Natalia Luzyanina on 29.10.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AppearanceService.setup()
        return true
    }
}
