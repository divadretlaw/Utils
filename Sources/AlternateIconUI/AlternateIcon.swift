//
//  AlternateIcon.swift
//  Utils/AlternateIconUI
//
//  Created by David Walter on 17.12.22.
//

import Foundation
import SwiftUI

/// Conform to ``AlternateIcon`` in order to display all available alternate icons in ``AlternateIconView``
public protocol AlternateIcon: Identifiable, CaseIterable, Equatable {
    /// The default app icon
    static var `default`: Self { get }
    
    /// The name of the icon in the XCAssets. Return `nil` for the default icon
    var alternateIconName: String? { get }
    
    /// An image representing the alternate app icon
    var icon: Image { get }
    /// A title for the alternate app icon
    var title: String { get }
    /// An optional subtitle for the alternate app icon
    var subtitle: String? { get }
}
