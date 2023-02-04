//
//  SafariOpenURL.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 06.01.23.
//

#if os(iOS)
import SwiftUI
import SafariServices
#if canImport(StoreKit)
import StoreKit
#endif

public enum SafariOpenURLAction {
    case safari
    case fallback(OpenURLAction.Result)
}

struct OpenLinkHandler: ViewModifier {
    var action: (URL) -> SafariOpenURLAction
    var fallback: (URL) -> OpenURLAction.Result
    
    @Environment(\.safariConfiguration) var safariConfiguration
    @Environment(\.safariPreferredBarTintColor) var safariPreferredBarTintColor
    @Environment(\.safariPreferredControlTintColor) var safariPreferredControlTintColor
    @Environment(\.safariDismissButtonStyle) var safariDismissButtonStyle
    
    @State private var viewController: UIViewController?
    
    func body(content: Content) -> some View {
        content
            .background {
                Presenter(viewController: viewController)
            }
            .environment(\.openURL, OpenURLAction { url in
                switch action(url) {
                case .safari:
                    return openSafari(with: url)
                case .fallback(let result):
                    return result
                }
            })
    }
    
    func openSafari(with url: URL) -> OpenURLAction.Result {
        #if canImport(StoreKit)
        if let id = url.appStoreId {
            let storeProductViewController = SKStoreProductViewController()
            storeProductViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: id]) { _, error in
                if error != nil {
                    UIApplication.shared.open(url)
                } else {
                    self.viewController = storeProductViewController
                }
            }
            return .handled
        }
        #endif
        
        guard url.supportsSafari else {
            return fallback(url)
        }
        
        let safari: SFSafariViewController
        
        if let configuration = safariConfiguration {
            safari = SFSafariViewController(url: url, configuration: configuration)
        } else {
            safari = SFSafariViewController(url: url)
        }
        
        safari.preferredBarTintColor = safariPreferredBarTintColor
        safari.preferredControlTintColor = safariPreferredControlTintColor
        safari.dismissButtonStyle = safariDismissButtonStyle
        
        self.viewController = safari
        return .handled
    }
}

struct OpenLinkHandler_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Link(destination: URL(string: "https://davidwalter.at")!) {
                Text("Open")
            }
            
            Link(destination: URL(string: "https://apps.apple.com/us/app/untilsince/id1393742286")!) {
                Text("App")
            }
        }
        .safariOpenURL()
    }
}
#endif
