//
//  AppInfo.swift
//  Utils/AppInfo
//
//  Created by David Walter on 17.12.22.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public struct AppInfo {
    var bundle: Bundle
    
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    public var name: String? {
        bundle.string(for: .appName)
    }
    
    #if canImport(UIKit)
    public var icon: UIImage? {
        bundle.appIcon
    }
    #endif
    
    public var version: String? {
        bundle.string(for: .version)
    }
    
    public var buildNumber: String? {
        bundle.string(for: .buildNumber)
    }
    
    public var sdkVersion: String? {
        bundle.string(for: .sdkVersion)
    }
    
    // MARK: - static
    
    public static var name: String? {
        AppInfo().name
    }
    
    #if canImport(UIKit)
    public static var icon: UIImage? {
        AppInfo().icon
    }
    #endif
    
    public static var version: String? {
        AppInfo().version
    }
    
    public static var buildNumber: String? {
        AppInfo().buildNumber
    }
    
    public static var sdkVersion: String? {
        AppInfo().sdkVersion
    }
}

public extension AppInfo {
    func string(_ keyPath: KeyPath<AppInfo, String?>) -> String? {
        self[keyPath: keyPath]
    }
}

enum InfoPlistKey: Hashable {
    case version
    case buildNumber
    case appName
    case sdkVersion
    case custom(key: String)
    
    var rawValue: String {
        switch self {
        case .version:
            return "CFBundleShortVersionString"
        case .buildNumber:
            return "CFBundleVersion"
        case .appName:
            return "CFBundleName"
        case .sdkVersion:
            return "DTSDKName"
        case let .custom(key):
            return key
        }
    }
}
