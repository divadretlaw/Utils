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
    
    private var isAppStore: Bool {
        guard let host = host?.lowercased() else { return false }
        guard ["apps.apple.com", "itunes.apple.com"].contains(host) else { return false }
        guard lastPathComponent.hasPrefix("id") else { return false }
        return Int(lastPathComponent.dropFirst(2)) != nil
    }
    
    private var isMapsLink: Bool {
        guard let host = host?.lowercased() else { return false }
        guard "maps.apple.com" == host else { return false }
        return query != nil
    }
}
