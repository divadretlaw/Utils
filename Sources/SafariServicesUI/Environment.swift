//
//  Environment.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 06.01.23.
//

#if os(iOS)
import Foundation
import SwiftUI
import SafariServices

// MARK: - Keys

struct SFConfigurationKey: EnvironmentKey {
    static var defaultValue: SFSafariViewController.Configuration? { nil }
}

struct SFPreferredBarTintColorKey: EnvironmentKey {
    static var defaultValue: UIColor? { nil }
}

struct SFPreferredControlTintColorKey: EnvironmentKey {
    static var defaultValue: UIColor? { nil }
}

struct SFDismissButtonStyleKey: EnvironmentKey {
    static var defaultValue: SFSafariViewController.DismissButtonStyle { .done }
}

// MARK: - Values

public extension EnvironmentValues {
    var safariConfiguration: SFSafariViewController.Configuration? {
        get {
            self[SFConfigurationKey.self]
        }
        set {
            self[SFConfigurationKey.self] = newValue
        }
    }
    
    var safariPreferredBarTintColor: UIColor? {
        get {
            self[SFPreferredBarTintColorKey.self]
        }
        set {
            self[SFPreferredBarTintColorKey.self] = newValue
        }
    }
    
    var safariPreferredControlTintColor: UIColor? {
        get {
            self[SFPreferredControlTintColorKey.self]
        }
        set {
            self[SFPreferredControlTintColorKey.self] = newValue
        }
    }
    
    var safariDismissButtonStyle: SFSafariViewController.DismissButtonStyle {
        get {
            self[SFDismissButtonStyleKey.self]
        }
        set {
            self[SFDismissButtonStyleKey.self] = newValue
        }
    }
}
#endif
