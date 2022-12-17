//
//  UserDefaultEntry.swift
//  Utils/UserDefaultsBrowser
//
//  Created by David Walter on 17.12.22.
//

import Foundation

struct UserDefaultsEntry: Identifiable, Comparable {
    let key: String
    let value: Any
    
    var isSimpleType: Bool {
        switch value {
        case is Bool, is Date, is Double, is Float, is Int, is String:
            return true
        default:
            return false
        }
    }
    
    var valueDescription: String {
        if isSimpleType {
            return String(reflecting: value)
        } else {
            return String(reflecting: type(of: value))
        }
    }
    
    // MARK: - Identifiable
    
    var id: String { key }

    // MARK: - Comparable
    
    static func < (lhs: UserDefaultsEntry, rhs: UserDefaultsEntry) -> Bool {
        lhs.key < rhs.key
    }
    
    static func == (lhs: UserDefaultsEntry, rhs: UserDefaultsEntry) -> Bool {
        lhs.id == rhs.id
    }
}
