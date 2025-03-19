//
//  UserDefaultsHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 19.03.25.
//

import Foundation

final class UserDefaultsHelper {
    private init() {}
    static let defaults = UserDefaults.standard
    
    // MARK: Setters
    
    static func setObject(key: UserDefaultsKey, value: AnyObject) {
        defaults.setValue(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    static func setString(key: UserDefaultsKey, value: String) {
        defaults.setValue(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    static func setInteger(key: UserDefaultsKey, value: Int) {
        defaults.setValue(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    static func setDouble(key: UserDefaultsKey, value: Double) {
        defaults.setValue(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    static func setFloat(key: UserDefaultsKey, value: Float) {
        defaults.setValue(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    static func setBool(key: UserDefaultsKey, value: Bool) {
        defaults.setValue(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    
    // MARK: Getters
    
    static func getObject(key: UserDefaultsKey) -> AnyObject? {
        return defaults.object(forKey: key.rawValue) as AnyObject?
    }
    
    static func getString(key: UserDefaultsKey) -> String? {
        return defaults.string(forKey: key.rawValue)
    }
    
    static func getInteger(key: UserDefaultsKey) -> Int {
        return defaults.integer(forKey: key.rawValue)
    }
    
    static func getDouble(key: UserDefaultsKey) -> Double {
        return defaults.double(forKey: key.rawValue)
    }
    
    static func getFloat(key: UserDefaultsKey) -> Float {
        return defaults.float(forKey: key.rawValue)
    }
    
    static func getBool(key: UserDefaultsKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
    
    // MARK: Remover
    
    static func remove(key: UserDefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
