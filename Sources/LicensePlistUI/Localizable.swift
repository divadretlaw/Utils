//
//  Localizable.swift
//  Utils/LicensePlistUI
//
//  Created by David Walter on 17.12.22.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        let bundle = Bundle.main.path(forResource: "LicensePlist", ofType: "strings") != nil ? Bundle.main : Bundle.module
        return NSLocalizedString(self, tableName: "LicensePlist", bundle: bundle, comment: comment)
    }
}
