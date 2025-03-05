//
//  Coordinator.swift
//  ai-drawing
//
//  Created by Natalia Luzyanina on 30.10.2024.
//

protocol Coordinator {
    associatedtype RouterType: Router
    var router: RouterType? { get }
}
