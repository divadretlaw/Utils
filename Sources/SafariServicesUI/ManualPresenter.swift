//
//  ManualPresenter.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import SwiftUI
import SafariServices

struct ManualPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var safari: SFSafariViewController?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view = UIView(frame: .zero)
        viewController.view.isUserInteractionEnabled = false
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            guard let safari = safari, !context.coordinator.isPresenting else { return }
            context.coordinator.isPresenting = true
            safari.delegate = context.coordinator
            uiViewController.present(safari, animated: true)
        } else {
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        var isPresented: Binding<Bool>
        var isPresenting = false
        
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }
        
        // MARK: - SFSafariViewControllerDelegate
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            isPresented.wrappedValue = false
            isPresenting = false
        }
    }
}
