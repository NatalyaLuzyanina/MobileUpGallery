//
//  ToastViewUsable.swift
//  ai-drawing
//
//  Created by Maria Nesterova on 17.09.2024.
//

import Foundation

protocol ToastViewUsable: AnyObject {
    var isToastViewDisplayed: Bool { get set }
    var toastMessage: String { get set }

    func showToastWithMessage(_ message: String)
}

extension ToastViewUsable {
    func showToastWithMessage(_ message: String) {
        toastMessage = message
        isToastViewDisplayed = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isToastViewDisplayed = false
        }
    }
}
