//
//  ManualPresenter.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import SwiftUI
import SafariServices

struct ManualPresenter: UIViewRepresentable {
    @Binding var isPresented: Bool
    var safari: SFSafariViewController?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let viewController = uiView.findTopViewController() else { return }
        
        if isPresented {
            guard let safari = safari, !context.coordinator.isPresenting else { return }
            
            context.coordinator.isPresenting = true
            safari.delegate = context.coordinator
            viewController.present(safari, animated: true)
        } else {
            safari?.dismiss(animated: true)
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
