//
//  SafariManager.swift
//  SafariServicesUI
//
//  Created by David Walter on 04.07.23.
//

import SwiftUI
import SafariServices
import UIKit
import Combine

#if os(iOS)
class SafariManager: NSObject, ObservableObject, SFSafariViewControllerDelegate {
    static var shared = SafariManager()
    
    var safariDidFinish = PassthroughSubject<SFSafariViewController, Never>()
    private var windows: [SFSafariViewController: UIWindow] = [:]
    
    @MainActor
    @discardableResult
    func present(_ safari: SFSafariViewController, on windowScene: UIWindowScene, userInterfaceStyle: UIUserInterfaceStyle = .unspecified) -> SFSafariViewController {
        safari.delegate = self
        windowScene.windows.forEach { $0.endEditing(true) }
        let (window, viewController) = setup(windowScene: windowScene, userInterfaceStyle: userInterfaceStyle)
        windows[safari] = window
        viewController.present(safari, animated: true)
        return safari
    }
    
    private func setup(windowScene: UIWindowScene, userInterfaceStyle: UIUserInterfaceStyle) -> (UIWindow, UIViewController) {
        let window = UIWindow(windowScene: windowScene)
        
        let viewController = UIViewController()
        window.overrideUserInterfaceStyle = userInterfaceStyle
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        return (window, viewController)
    }
    
    internal func safariViewControllerDidFinish(_ safari: SFSafariViewController) {
        let window = safari.view.window
        window?.resignKey()
        window?.isHidden = false
        windows[safari] = nil
        safariDidFinish.send(safari)
    }
}
#endif
