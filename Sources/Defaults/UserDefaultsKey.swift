//
//  UserDefaultsKey.swift
//  Utils/Defaults
//
//  Created by David Walter on 29.05.23.
//

import Foundation

public struct UserDefaultsKey: RawRepresentable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// swiftlint:disable:next no_grouping_extension
extension UserDefaultsKey: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.rawValue = stringLiteral
    }
}
