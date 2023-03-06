//
//  UserDefaultsManager.swift
//  movies
//
//  Created by Oleksandr Khalypa on 02.03.2023.
//

import Foundation

protocol UserDefaultsManagerAnyKey {
    var rawValue: String { get }
}

protocol UserDefaultsCodable {
    func encode(to defaults: UserDefaults, with key: String)
    static func decode(from defaults: UserDefaults, with key: String) -> Self?
}

class UserDefaultsManager {
    
    enum StringKey: String, UserDefaultsManagerAnyKey, CaseIterable {
        case organic
        case campaign
    }
    
    static let shared = UserDefaultsManager(UserDefaults.standard)
    
    private let defaults: UserDefaults
    
    init(_ defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    // MARK: String
    
    subscript(_ key: StringKey) -> String? {
        get {
            return self.defaults.string(forKey: key.rawValue)
        }
        set {
            if let newValue = newValue {
                self.defaults.set(newValue, forKey: key.rawValue)
            } else {
                self.defaults.removeObject(forKey: key.rawValue)
            }
        }
    }
    
    subscript(_ key: StringKey, default default: @autoclosure () -> String) -> String {
        return self.defaults.string(forKey: key.rawValue) ?? `default`()
    }

}
