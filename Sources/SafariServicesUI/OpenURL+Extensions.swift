//
//  API.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import SwiftUI
import SafariServices

public extension View {
    /// Registers a handler to invoke when a view wants to open a url.
    func openURL(handler: @escaping (URL) -> OpenURLAction.Result) -> some View {
        environment(\.openURL, OpenURLAction(handler: handler))
    }
}

#if os(iOS)
import WindowSceneReader

public extension View {
    /// Registers a handler to invoke when a view wants to open a url.
    func openURL(handler: @escaping (URL, UIWindowScene?) -> OpenURLAction.Result) -> some View {
        modifier(WindowSceneOpenURL(handler: handler))
    }
}

struct WindowSceneOpenURL: ViewModifier {
    var handler: (URL, UIWindowScene?) -> OpenURLAction.Result
    
    @State private var windowScene: UIWindowScene?
    
    func body(content: Content) -> some View {
        content
            .readWindow { window in
                windowScene = window.windowScene
            }
            .openURL { url in
                handler(url, windowScene)
            }
    }
}
#endif
