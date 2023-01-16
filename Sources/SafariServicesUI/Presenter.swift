//
//  Presenter.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import SwiftUI
import SafariServices

struct Presenter: UIViewRepresentable {
    var safari: SFSafariViewController?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let safari = safari, let viewController = uiView.findTopViewController() else { return }
        viewController.present(safari, animated: true)
    }
}
