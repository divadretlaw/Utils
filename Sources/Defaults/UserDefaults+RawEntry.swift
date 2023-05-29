//
//  UserDefaults+RawEntry.swift
//  Utils/Defaults
//
//  Created by David Walter on 17.12.22.
//

import Foundation
import Combine

public extension UserDefaults {
    @propertyWrapper struct RawEntry<T> {
        public let key: UserDefaultsKey
        internal let defaultValue: T
        internal let userDefaults: UserDefaults

        private let subject = PassthroughSubject<T, Error>()
        private var observation: UserDefaultsObservation?
        
        public init(_ key: String, defaultValue: T, defaults: UserDefaults? = nil) {
            let key = UserDefaultsKey(rawValue: key)
            self.key = key
            self.defaultValue = defaultValue
            self.userDefaults = defaults ?? .standard
            
            self.observation = UserDefaultsObservation(key: key) { [subject] _, new in
                guard let value = new as? T else { return }
                subject.send(value)
            }
        }
        
        public static subscript<Parent: ObservableObject>(
            _enclosingInstance instance: Parent,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<Parent, T>,
            storage storageKeyPath: ReferenceWritableKeyPath<Parent, Self>
        ) -> T {
            get {
                instance[keyPath: storageKeyPath].wrappedValue
            }
            set {
                if let objectWillChange = instance.objectWillChange as? ObservableObjectPublisher {
                    objectWillChange.send()
                }
                
                instance[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }

        public var wrappedValue: T {
            get {
                userDefaults.object(forKey: key.rawValue) as? T ?? defaultValue
            }
            set {
                userDefaults.set(newValue, forKey: key.rawValue)
            }
        }
        
        public var projectedValue: AnyPublisher<T, Error> {
            subject.eraseToAnyPublisher()
        }
    }
}
