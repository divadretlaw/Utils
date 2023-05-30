//
//  API.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import SwiftUI
import SafariServices

public extension View {
    func openURL(handler: @escaping (URL) -> OpenURLAction.Result) -> some View {
        environment(\.openURL, OpenURLAction(handler: handler))
    }
}

#if os(iOS)
import WindowSceneReader

public extension View {
    func openURL(handler: @escaping (URL, UIWindowScene) -> OpenURLAction.Result) -> some View {
        modifier(WindowSceneOpenURL(handler: handler))
    }
}

struct WindowSceneOpenURL: ViewModifier {
    var handler: (URL, UIWindowScene) -> OpenURLAction.Result
    
    func body(content: Content) -> some View {
        WindowSceneReader { windowScene in
            content
                .environment(\.openURL, OpenURLAction(handler: { url in
                    handler(url, windowScene)
                }))
        }
    }
}
#endif
