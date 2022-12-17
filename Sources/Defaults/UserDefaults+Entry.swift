//
//  UserDefaults+Entry.swift
//  Utils/Defaults
//
//  Created by David Walter on 17.12.22.
//

import Foundation

public extension UserDefaults {
    @propertyWrapper struct Entry<Value> {
        public let key: String
        public let `default`: Value
        
        private let store: UserDefaults
        
        public init(_ key: String, default: Value, store: UserDefaults = .standard) {
            self.key = key
            self.default = `default`
            self.store = store
        }
        
        public var wrappedValue: Value {
            get {
                store.object(forKey: key) as? Value ?? self.default
            }
            set {
                store.set(newValue, forKey: key)
            }
        }
    }
}
