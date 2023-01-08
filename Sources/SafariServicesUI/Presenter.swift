//
//  Presenter.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import SwiftUI
import SafariServices

struct Presenter: UIViewControllerRepresentable {
    var safari: SFSafariViewController?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view = UIView(frame: .zero)
        viewController.view.isUserInteractionEnabled = false
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let safari = safari else { return }
        uiViewController.present(safari, animated: true)
    }
}
