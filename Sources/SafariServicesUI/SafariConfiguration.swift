//
//  SafariConfiguration.swift
//  SafariServicesUI
//
//  Created by David Walter on 04.07.23.
//

import Foundation
import UIKit
import SwiftUI
import SafariServices

#if os(iOS)
public struct SafariConfiguration {
    public var configuration: SFSafariViewController.Configuration
    public var preferredBarTintColor: UIColor?
    public var preferredControlTintColor: UIColor?
    public var dismissButtonStyle: SFSafariViewController.DismissButtonStyle
    public var modalPresentationStyle: UIModalPresentationStyle
    public var overrideUserInterfaceStyle: UIUserInterfaceStyle
    
    init() {
        self.configuration = SFSafariViewController.Configuration()
        self.preferredBarTintColor = nil
        self.preferredControlTintColor = .tintColor
        self.dismissButtonStyle = .done
        self.modalPresentationStyle = .automatic
        self.overrideUserInterfaceStyle = .unspecified
    }
    
    func userInterfaceStyle(with colorScheme: ColorScheme) -> UIUserInterfaceStyle {
        switch overrideUserInterfaceStyle {
        case .unspecified:
            return colorScheme.userInterfaceStyle
        default:
            return overrideUserInterfaceStyle
        }
    }
}

extension ColorScheme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .unspecified
        }
    }
}
#endif
