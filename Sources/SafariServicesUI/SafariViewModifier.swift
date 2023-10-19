//
//  SafariViewModifier.swift
//  SafariServicesUI
//
//  Created by David Walter on 04.07.23.
//

import SwiftUI
import SafariServices
import WindowSceneReader

#if os(iOS)
public extension View {
    /// Presents a `SFSafariViewController` using the given url
    /// - Parameters:
    ///   - url: The `URL` to load
    func safari(url: Binding<URL?>) -> some View {
        modifier(SafariViewModifier(url: url, configure: nil))
    }
    
    /// Presents a `SFSafariViewController` using the given url
    /// - Parameters:
    ///   - url: The `URL` to load
    ///   - configure: Callback to configure the presentation of `SFSafariViewController`
    func safari(url: Binding<URL?>, configure: @escaping (inout SafariConfiguration) -> Void) -> some View {
        modifier(SafariViewModifier(url: url, configure: configure))
    }
}

struct SafariViewModifier: ViewModifier {
    @Binding var url: URL?
    var configure: ((inout SafariConfiguration) -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var safariManager = SafariManager.shared
    
    @State private var presentingSafari: SFSafariViewController?
    
    func body(content: Content) -> some View {
        content
            .background {
                WindowSceneReader { windowScene in
                    Color.clear
                        .onChange(of: url) { url in
                            guard let url else { return }
                            showSafari(with: url, on: windowScene)
                        }
                        .onAppear {
                            guard let url else { return }
                            showSafari(with: url, on: windowScene)
                        }
                        .onReceive(safariManager.safariDidFinish) { safari in
                            if safari == presentingSafari {
                                url = nil
                            }
                        }
                }
            }
    }
    
    @MainActor
    func showSafari(with url: URL, on windowScene: UIWindowScene) {
        var config = SafariConfiguration()
        configure?(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        safari.overrideUserInterfaceStyle = config.userInterfaceStyle(with: colorScheme)
        
        presentingSafari = safariManager.present(safari, on: windowScene, userInterfaceStyle: config.userInterfaceStyle(with: colorScheme))
    }
}

struct SafariViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        @State private var url: URL?
        
        var body: some View {
            NavigationView {
                List {
                    Button {
                        url = URL(string: "https://davidwalter.at")
                    } label: {
                        Text("Show Safari")
                    }
                }
                .navigationTitle("Preview")
                .safari(url: $url) { configuration in
                    configuration.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
}
#endif
