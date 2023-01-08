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
        return ["https", "http"].contains(scheme.lowercased())
    }
}
