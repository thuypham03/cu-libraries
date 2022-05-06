//
//  LoginManager.swift
//  CULibraries
//
//  Created by 过仲懿 on 4/28/22.
//

import Foundation

struct LoginManager {
    enum Field: String {
        case username = "username"
        case password = "password"
    }
    
    static private let standard = UserDefaults.standard
    
    static private func save(value: Any?, key: Field) {
        LoginManager.standard.set(value, forKey: key.rawValue)
    }

    static private func load(key: Field) -> Any? {
        LoginManager.standard.value(forKey: key.rawValue)
    }
    
    static var username: String? {
        get {load(key:.username) as? String}
        set {save(value:newValue, key: .username)}
    }
    
    static var password: String? {
        get {load(key:.password) as? String}
        set {save(value:newValue, key: .password)}
    }
    
    static var login: Bool {
        guard let _ = username, let _ = password else { return false }
        return true
    }
}
