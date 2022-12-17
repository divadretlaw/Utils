//
//  Appearance+Environment.swift
//  Utils/Appearance
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI

struct AppearanceManagerEnvironmentKey: EnvironmentKey {
    static var defaultValue: AppearanceManager {
        AppearanceManager()
    }
}

public extension EnvironmentValues {
    var appearanceManager: AppearanceManager {
        get {
            self[AppearanceManagerEnvironmentKey.self]
        }
        set {
            self[AppearanceManagerEnvironmentKey.self] = newValue
        }
    }
}
