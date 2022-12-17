//
//  Defaults.swift
//  Utils/Defaults
//
//  Created by David Walter on 17.12.22.
//

import Foundation

public extension UserDefaults {
    func value<Value>(forKey key: String, default: Value) -> Value {
        guard let value = self.object(forKey: key) as? Value else {
            self.set(`default`, forKey: key)
            return `default`
        }
        return value
    }
}
