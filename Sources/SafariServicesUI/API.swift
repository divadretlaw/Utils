//
//  API.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

#if os(iOS)
import SwiftUI
import SafariServices

public extension View {
    /// Open URL with `SFSafariViewController`
    ///
    /// - Parameters:
    ///     - safari: Whether to use `SFSafariViewController` for the given `URL`.
    ///     Return `.fallback` to use a fallback when not using Safari.
    ///     - fallback: Optional fallback to handle the url if `safari` couldn't be used
    /// - Returns: The view with a `SFSafariViewController` handling openened URLs
    func safariOpenURL(
        perform: @escaping (URL) -> SafariOpenURLAction = { _ in .safari },
        fallback: @escaping (URL) -> OpenURLAction.Result = { _ in .systemAction }
    ) -> some View {
        modifier(OpenLinkHandler(action: perform, fallback: fallback))
    }
    
    /// Present a URL with `SFSafariViewController`
    ///
    /// - Parameters:
    ///     - url: The `URL` to present
    ///     - isPresented: A binding to a Boolean value that determines whether
    ///     to present the `SFSafariViewController` that you create in the modifier's
    ///     - customize: Customize the created `SFSafariViewController`
    ///     - configuration: Optionally provide a `SFSafariViewController.Configuration`
    func safari(
        url: URL,
        isPresented: Binding<Bool>,
        customize: @escaping (SFSafariViewController) -> Void = { _ in },
        configuration: (() -> SFSafariViewController.Configuration)? = nil
    ) -> some View {
        modifier(SafariView(url: url, isPresented: isPresented, customize: customize, configuration: configuration))
    }
}
#endif
