//
//  UserDefaultsObservation.swift
//  Utils/Defaults
//
//  Created by David Walter on 29.05.23.
//

import Foundation

public final class UserDefaultsObservation: NSObject {
    public let key: UserDefaultsKey
    private var onChange: (Any, Any) -> Void

    public init(key: UserDefaultsKey, onChange: @escaping (Any, Any) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key.rawValue, options: [.old, .new], context: nil)
    }
    
    // swiftlint:disable:next block_based_kvo
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.oldKey] as Any, change[.newKey] as Any)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
    }
}
