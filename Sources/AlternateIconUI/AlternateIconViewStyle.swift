//
//  AlternateIconViewStyle.swift
//  Utils/AlternateIconUI
//
//  Created by David Walter on 17.12.22.
//

import Foundation
import SwiftUI

/// The style of the ``AlternateIconView``
public enum AlternateIconViewStyle {
    /// Display alternate icons in a `List`
    case list
    /// Display alternate icons in a grid with n columns
    case grid(columns: Int)
}
