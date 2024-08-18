//
//  ErrorModel.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

enum ErrorModel: Error {
    case authError
    case loadingError
    case logoutError
    
    var title: String {
        switch self {
        case .loadingError:
            Strings.Error.loadingError
        case .authError:
            Strings.Error.authError
        case .logoutError:
            Strings.Error.logoutError
        }
    }
    
    var message: String {
        switch self {
        case .loadingError, .logoutError:
            Strings.Error.tryLater
        case .authError:
            Strings.Error.tryAgain
        }
    }
}
