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
        
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
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
    
    static func safari(_ url: URL, configure: (inout OpenURLAction.SafariConfiguration) -> Void) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = scene?.windows.first { $0.isKeyWindow }
        
        guard let rootViewController = window?.rootViewController else {
            return .systemAction
        }
        
        var config = OpenURLAction.SafariConfiguration()
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
        
        OpenURLAction.SafariManager.shared.present(safari, on: windowScene)
        
        return .handled
    }
    
    @MainActor
    static func safariWindow(_ url: URL, windowScene: UIWindowScene?, configure: (inout OpenURLAction.SafariConfiguration) -> Void) -> Self {
        guard url.supportsSafari else {
            return .systemAction
        }
        
        guard let windowScene = windowScene else {
            return .safari(url)
        }
        
        var config = OpenURLAction.SafariConfiguration()
        configure(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        safari.overrideUserInterfaceStyle = config.overrideUserInterfaceStyle
        
        OpenURLAction.SafariManager.shared.present(safari, on: windowScene)
        
        return .handled
    }
}

extension OpenURLAction {
    public struct SafariConfiguration {
        public var configuration: SFSafariViewController.Configuration = SFSafariViewController.Configuration()
        public var preferredBarTintColor: UIColor? = nil
        public var preferredControlTintColor: UIColor? = .tintColor
        public var dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done
        public var modalPresentationStyle: UIModalPresentationStyle = .automatic
        public var overrideUserInterfaceStyle: UIUserInterfaceStyle = .unspecified
    }
}

extension OpenURLAction {
    private class SafariManager: NSObject, ObservableObject, SFSafariViewControllerDelegate {
        static var shared = SafariManager()
        
        private var windows: [SFSafariViewController: UIWindow] = [:]
        
        @MainActor
        public func present(_ safari: SFSafariViewController, on windowScene: UIWindowScene) {
            safari.delegate = self
            windowScene.windows.forEach { $0.endEditing(true) }
            let (window, viewController) = setup(windowScene: windowScene)
            windows[safari] = window
            viewController.present(safari, animated: true)
        }
        
        private func setup(windowScene: UIWindowScene) -> (UIWindow, UIViewController) {
            let window = UIWindow(windowScene: windowScene)
            
            let viewController = UIViewController()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            return (window, viewController)
        }
        
        internal func safariViewControllerDidFinish(_ safari: SFSafariViewController) {
            let window = safari.view.window
            window?.resignKey()
            window?.isHidden = false
            windows[safari] = nil
        }
    }
}
#endif
