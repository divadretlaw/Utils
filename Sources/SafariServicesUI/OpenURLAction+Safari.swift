//
//  OpenURLAction+Safari.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 30.05.23.
//

import SwiftUI
import SafariServices

#if os(iOS)
public extension OpenURLAction.Result {
    static func safari(_ url: URL) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        let window = scene?.windows.first { $0.isKeyWindow }
        
        guard let rootViewController = window?.rootViewController else {
            return .systemAction
        }
        
        let safari = SFSafariViewController(url: url)
        if window?.traitCollection.horizontalSizeClass == .regular {
            safari.modalPresentationStyle = .pageSheet
        }
        rootViewController.present(safari, animated: true)
        return .handled
    }
    
    static func safari(_ url: URL, configure: (inout SafariConfiguration) -> Void) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = scene?.windows.first { $0.isKeyWindow }
        
        guard let rootViewController = window?.rootViewController else {
            return .systemAction
        }
        
        var config = SafariConfiguration()
        configure(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        if config.modalPresentationStyle == .automatic, window?.traitCollection.horizontalSizeClass == .regular {
            safari.modalPresentationStyle = .pageSheet
        } else {
            safari.modalPresentationStyle = .automatic
        }
        rootViewController.present(safari, animated: true)
        return .handled
    }
    
    @MainActor
    static func safariWindow(_ url: URL, windowScene: UIWindowScene?) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        guard let windowScene = windowScene else {
            return .safari(url)
        }
        
        let safari = SFSafariViewController(url: url)
        
        SafariManager.shared.present(safari, on: windowScene)
        
        return .handled
    }
    
    @MainActor
    static func safariWindow(_ url: URL, windowScene: UIWindowScene?, configure: (inout SafariConfiguration) -> Void) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        guard let windowScene = windowScene else {
            return .safari(url)
        }
        
        var config = SafariConfiguration()
        configure(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        safari.overrideUserInterfaceStyle = config.overrideUserInterfaceStyle
        
        SafariManager.shared.present(safari, on: windowScene)
        
        return .handled
    }
}
#endif
