//
//  UserDefaults+CodableEntry.swift
//  Utils/Defaults
//
//  Created by David Walter on 17.12.22.
//

import Foundation
import Combine

public extension UserDefaults {
    @propertyWrapper struct CodableEntry<T> where T: Codable {
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
                guard let data = new as? Data else { return }
                guard let value = try? JSONDecoder().decode(T.self, from: data) else { return }
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
                guard let data = self.userDefaults.object(forKey: key.rawValue) as? Data else {
                    return defaultValue
                }

                let value = try? JSONDecoder().decode(T.self, from: data)
                return value ?? defaultValue
            }
            set {
                let data = try? JSONEncoder().encode(newValue)
                
                self.userDefaults.set(data, forKey: key.rawValue)
                self.subject.send(newValue)
            }
        }
        
        public var projectedValue: AnyPublisher<T, Error> {
            subject.eraseToAnyPublisher()
        }
    }
}
