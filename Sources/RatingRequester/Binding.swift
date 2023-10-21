//
//  Binding.swift
//  Utils/RatingRequester
//
//  Created by David Walter on 26.06.23.
//

import Foundation

struct Binding<Value> {
    var wrappedValue: Value {
        get {
            getter()
        }
        set {
            setter(newValue)
        }
    }
    
    var getter: () -> Value
    var setter: (Value) -> Void
    
    init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        getter = get
        setter = set
    }
    
    init(get: @escaping () -> Value) {
        getter = get
        setter = { _ in }
    }
}
