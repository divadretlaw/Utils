//
//  MFMailView.swift
//  Utils/MFMailUI
//
//  Created by David Walter on 11.06.20.
//

import SwiftUI
#if canImport(MessageUI)
import MessageUI

struct MFMailView: UIViewControllerRepresentable {
    var options: MFMailViewOptions?
    
    @Binding var isPresented: Bool
    var completionHandler: (Result<MFMailComposeResult, Error>) -> Void
    
    init(
        isPresented: Binding<Bool>,
        options: MFMailViewOptions? = nil,
        completionHandler: @escaping (Result<MFMailComposeResult, Error>) -> Void
    ) {
        self.options = options
        self._isPresented = isPresented
        self.completionHandler = completionHandler
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MFMailView>) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        
        if let options = options {
            mail.setToRecipients(options.toRecipients)
            mail.setCcRecipients(options.ccRecipients)
            mail.setBccRecipients(options.bccRecipients)
            
            if let subject = options.subject {
                mail.setSubject(subject)
            }
            
            if let messageBody = options.messageBody {
                mail.setMessageBody(messageBody, isHTML: options.isHTML)
            }
        }
        
        return mail
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented, completionHandler: completionHandler)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isPresented: Bool
        var completionHandler: (Result<MFMailComposeResult, Error>) -> Void

        init(isPresented: Binding<Bool>, completionHandler: @escaping (Result<MFMailComposeResult, Error>) -> Void) {
            self._isPresented = isPresented
            self.completionHandler = completionHandler
        }
        
        // MARK: MFMailComposeViewControllerDelegate
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?) {
            defer {
                self.isPresented = false
            }
            
            if let error = error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(result))
            }
        }
    }
}
#endif
