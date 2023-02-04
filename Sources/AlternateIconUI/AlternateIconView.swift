//
//  AlternateIconView.swift
//  Utils/AlternateIconUI
//
//  Created by David Walter on 17.12.22.
//

#if os(iOS)
import SwiftUI

public struct AlternateIconView<Icon>: View where Icon: AlternateIcon {
    var icons: [Icon]
    
    var maxAppIconSize: CGFloat = 60
    var isLabelHidden = false
    var showCheckmark = true
    var style: AlternateIconViewStyle = .list
    
    @State private var checkmark = UUID()
    
    public init(icons: [Icon]) {
        self.icons = icons
    }
    
    public var body: some View {
        Group {
            switch style {
            case .list:
                ListAlternateIconView(icons: icons)
            case .grid(let columns):
                GridAlternateIconView(icons: icons, columns: max(0, columns))
            }
        }
        .environment(\.labelsHidden, isLabelHidden)
        .environment(\.showCheckmark, showCheckmark)
        .environment(\.maxAppIconSize, maxAppIconSize)
    }
    
    /// Sets the style of the ``AlternateIconView``
    ///
    /// - Parameters style: The ``AlternateIconViewStyle`` to use
    ///
    /// - Returns: A view with the ``AlternateIconViewStyle`` set
    public func style(_ style: AlternateIconViewStyle) -> Self {
        var view = self
        view.style = style
        return view
    }
    
    /// Hide the label on supported styles
    ///
    /// - Parameter value: Whether to hide the labels. Defaults to `true`
    ///
    /// - Returns: A view with the labels hidden
    public func labelsHidden(_ value: Bool = true) -> Self {
        var view = self
        view.isLabelHidden = value
        return view
    }
    
    /// Hide the checkmark on the selected icon
    ///
    /// - Parameter value: Whether to hide the checkmark. Defaults to `true`
    ///
    /// - Returns: A view with the checkmark hidden
    public func hideCheckmark(_ value: Bool = true) -> Self {
        var view = self
        view.showCheckmark = !value
        return view
    }
    
    /// Set the max. size of alternate icons
    ///
    /// - Parameter value: The max. size of the alternate icons
    ///
    /// - Returns: A view with the max. size of the alternate icons set
    public func maxAppIconSize(_ value: CGFloat) -> Self {
        var view = self
        view.maxAppIconSize = value
        return view
    }
}

#if DEBUG
enum PreviewAlternateIcon: String, AlternateIcon {
    case `default`
    case dashed
    case long
    case gift
    
    var id: String { rawValue }
    
    var alternateIconName: String? {
        switch self {
        case .dashed:
            return "Dashed"
        case .long:
            return "Long"
        case .gift:
            return "Gift"
        default:
            return nil
        }
    }
    
    var icon: Image {
        switch self {
        case .dashed:
            return Image(systemName: "app.dashed")
        case .long:
            return Image(systemName: "app.fill")
        case .gift:
            return Image(systemName: "app.gift")
        default:
            return Image(systemName: "app")
        }
    }
    
    var title: String {
        switch self {
        case .dashed:
            return "Dashed"
        case .long:
            return "A very long icon name, that is probably way too long anyway"
        case .gift:
            return "Gift"
        default:
            return "Default"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .dashed:
            return "A dashed variant of the default app icon"
        case .long:
            return "A long subtitle that explains nothing\nalso has a line break\nor two"
        case .gift:
            return "A Christmas themed icon"
        default:
            return "The default app icon"
        }
    }
}

struct AlternateIconView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlternateIconView(icons: PreviewAlternateIcon.allCases)
                .navigationTitle("App Icon")
        }
    }
}
#endif
#endif
