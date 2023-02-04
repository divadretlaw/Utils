//
//  Bundle+Extensions.swift
//  Utils/AppInfo
//
//  Created by David Walter on 17.12.22.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension Bundle {
    func string(for key: InfoPlistKey) -> String? {
        value(for: key) as? String
    }
    
    func value(for key: InfoPlistKey) -> Any? {
        self.infoDictionary?[key.rawValue]
    }
    
    #if canImport(UIKit)
    var appIcon: UIImage? {
        guard let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let highestResolution = iconFiles.last else {
            return nil
        }
        
        return UIImage(named: highestResolution)
    }
    #endif
}
