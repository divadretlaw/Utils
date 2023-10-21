//
//  MFMailView.Options.swift
//  Utils/MFMailUI
//
//  Created by David Walter on 25.12.20.
//

import Foundation

/// <#Description#>
public struct MFMailViewOptions {
    let toRecipients: [String]?
    let ccRecipients: [String]?
    let bccRecipients: [String]?
    let subject: String?
    let messageBody: String?
    let isHTML: Bool
    
    public init(
        toRecipients: [String]? = nil,
        ccRecipients: [String]? = nil,
        bccRecipients: [String]? = nil,
        subject: String? = nil,
        messageBody: String? = nil,
        isHTML: Bool = false
    ) {
        self.toRecipients = toRecipients
        self.ccRecipients = ccRecipients
        self.bccRecipients = bccRecipients
        self.subject = subject
        self.messageBody = messageBody
        self.isHTML = isHTML
    }
}
