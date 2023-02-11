//
//  AppearanceManager+Environment.swift
//  Utils/AppearanceUI
//
//  Created by David Walter on 11.02.23.
//

#if canImport(UIKit)
import SwiftUI
import Appearance

extension AppearanceManager {
    static var shared: AppearanceManager = AppearanceManager()
}

struct AppearanceManagerEnvironmentKey: EnvironmentKey {
    static var defaultValue: AppearanceManager {
        AppearanceManager.shared
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
#endif
