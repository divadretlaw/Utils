//
//  URL+Extensions.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import Foundation

extension URL {
    var supportsSafari: Bool {
        guard let scheme = scheme else { return false }
        guard ["https", "http"].contains(scheme.lowercased()) else { return false }
        return !isDefaultAppLink
    }
    
    var isDefaultAppLink: Bool {
        isAppStore || isMapsLink
    }
    
    var isAppStore: Bool {
        appStoreId != nil
    }
    
    var appStoreId: Int? {
        guard let host = internalHost()?.lowercased() else { return nil }
        guard ["apps.apple.com", "itunes.apple.com"].contains(host) else { return nil }
        guard lastPathComponent.hasPrefix("id") else { return nil }
        return Int(lastPathComponent.dropFirst(2))
    }
    
    var isMapsLink: Bool {
        guard let host = internalHost()?.lowercased() else { return false }
        guard "maps.apple.com" == host else { return false }
        return query != nil
    }
}

extension URL {
    internal func internalHost() -> String? {
        if #available(iOS 16.0, *) {
            return host(percentEncoded: false)
        } else {
            return host
        }
    }
}
