//
//  UIUserInterfaceStyle+Extensions.swift
//  Utils/Appearance
//
//  Created by David Walter on 17.12.22.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit

extension UIUserInterfaceStyle {
    var colorScheme: ColorScheme? {
        switch self {
        case .unspecified:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return nil
        }
    }
}
#endif
