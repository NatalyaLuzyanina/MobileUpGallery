//
//  KeychainStorage.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation
import KeychainSwift

final class KeychainStorage {
    
    static let shared = KeychainStorage()
    private init() {}
    
    private let keychain = KeychainSwift()
    
    enum KeyType: String {
        case accessToken
    }
    
    func save(token: AccessTokenModel, key: KeyType) {
        do {
            let data = try JSONEncoder().encode(token)
            keychain.set(data, forKey: key.rawValue)
        } catch let error {
            print("Keychain saving error - \(error)")
        }
    }
    
    func getToken() ->  AccessTokenModel? {
        var token: AccessTokenModel?
        do {
            guard let data = keychain.getData(KeyType.accessToken.rawValue) else { return nil }
            token = try JSONDecoder().decode(AccessTokenModel.self, from: data)
        } catch let error {
            print("Keychain decoding error - \(error)")
        }
        return token
    }
    
    func clear() {
        keychain.clear()
    }
}
