//
//  MFMailViewExtensions.swift
//  Utils/MFMailUI
//
//  Created by David Walter on 25.12.20.
//

import SwiftUI
#if canImport(MessageUI)
import MessageUI

extension View {
    public func mailSheet(
        isPresented: Binding<Bool>,
        options: MFMailViewOptions? = nil,
        completionHandler: @escaping (Result<MFMailComposeResult, Error>) -> Void,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        sheet(isPresented: isPresented, onDismiss: onDismiss) {
            MFMailView(isPresented: isPresented, options: options, completionHandler: completionHandler)
        }
    }
}

#if DEBUG
struct MFMailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .mailSheet(isPresented: .constant(false), options: nil) { result in
                print(result)
            }
    }
}
#endif
#endif
