//
//  UserDefaultsStorage.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

final class UserDefaultsStorage {
    
    static let shared = UserDefaultsStorage()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case photosResponse
    }
    
    func set<T: Encodable>(_ value: T, forKey key: Key) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(value)
            userDefaults.set(data, forKey: key.rawValue)
        } catch {
            print("Error encoding \(key.rawValue): \(error)")
        }
    }
    
    func get<T: Decodable>(_ key: Key) -> T? {
        if let data = userDefaults.data(forKey: key.rawValue) {
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: data)
                return value
            } catch {
                print("Error decoding \(key.rawValue): \(error)")
                return nil
            }
        }
        return nil
    }
}
