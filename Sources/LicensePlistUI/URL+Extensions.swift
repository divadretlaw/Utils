//
//  URL+Extensions.swift
//  Utils/LicensePlistUI
//
//  Created by David Walter on 17.12.22.
//

import Foundation

extension URL {
    func cleanString(percentEncoded: Bool = true) -> String {
        if #available(iOS 16.0, *) {
            guard let host = self.host(percentEncoded: percentEncoded) else { return absoluteString }
            return "\(host)\(path(percentEncoded: percentEncoded))"
        } else {
            guard let host = self.host else { return absoluteString }
            return "\(host)\(path)"
        }
    }
}
