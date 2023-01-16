//
//  UIView+Extensions.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 16.01.23.
//

import UIKit

extension UIView {
    func findTopViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder.topViewController()
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findTopViewController()
        } else {
            return nil
        }
    }
}

extension UIViewController {
    func topViewController() -> UIViewController? {
        if let nvc = self as? UINavigationController {
            return nvc.visibleViewController?.topViewController()
        } else if let tbc = self as? UITabBarController, let selected = tbc.selectedViewController {
            return selected.topViewController()
        } else if let presented = self.presentedViewController {
            return presented.topViewController()
        }
        return self
    }
}
