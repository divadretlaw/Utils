//
//  Localizable.swift
//  Utils/AppearanceUI
//
//  Created by David Walter on 17.12.22.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        let bundle = Bundle.main.path(forResource: "Appearance", ofType: "strings") != nil ? Bundle.main : Bundle.module
        
        return NSLocalizedString(self, tableName: "Appearance", bundle: bundle, comment: comment)
    }
}
