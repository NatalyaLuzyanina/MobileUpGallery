//
//  ErrorModel.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case responseError
    case internetError
    case authError
}
