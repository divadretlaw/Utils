//
//  Environment.swift
//  Utils/AlternateIconUI
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI

struct LabelsHiddenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool { false }
}

extension EnvironmentValues {
    var labelsHidden: Bool {
        get {
            self[LabelsHiddenEnvironmentKey.self]
        }
        set {
            self[LabelsHiddenEnvironmentKey.self] = newValue
        }
    }
}

struct ShowCheckmarkEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool { true }
}

extension EnvironmentValues {
    var showCheckmark: Bool {
        get {
            self[ShowCheckmarkEnvironmentKey.self]
        }
        set {
            self[ShowCheckmarkEnvironmentKey.self] = newValue
        }
    }
}

struct MaxAppIconSizeEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat { 60 }
}

extension EnvironmentValues {
    var maxAppIconSize: CGFloat {
        get {
            self[MaxAppIconSizeEnvironmentKey.self]
        }
        set {
            self[MaxAppIconSizeEnvironmentKey.self] = newValue
        }
    }
}
