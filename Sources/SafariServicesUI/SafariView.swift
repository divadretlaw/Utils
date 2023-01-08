//
//  SafariView.swift
//  Utils/SafariServicesUI
//
//  Created by David Walter on 06.01.23.
//

import SwiftUI
import SafariServices

struct SafariView: ViewModifier {
    var url: URL
    @Binding var isPresented: Bool
    var customize: (SFSafariViewController) -> Void
    var configuration: (() -> SFSafariViewController.Configuration)?
    
    @Environment(\.openURL) var openURL
    @Environment(\.safariConfiguration) var safariConfiguration
    @Environment(\.safariPreferredBarTintColor) var safariPreferredBarTintColor
    @Environment(\.safariPreferredControlTintColor) var safariPreferredControlTintColor
    @Environment(\.safariDismissButtonStyle) var safariDismissButtonStyle
    
    @State private var safari: SFSafariViewController?
    
    func body(content: Content) -> some View {
        content
            .background {
                ManualPresenter(isPresented: $isPresented, safari: safari)
            }
            .onChange(of: isPresented) { _ in
                showSafari()
            }
            .onAppear {
                showSafari()
            }
    }
    
    func showSafari() {
        guard url.supportsSafari else {
            return openURL(url)
        }
        
        guard isPresented else { return }
        
        let safari: SFSafariViewController
        
        if let configuration = configuration?() ?? safariConfiguration {
            safari = SFSafariViewController(url: url, configuration: configuration)
        } else {
            safari = SFSafariViewController(url: url)
        }
        
        safari.preferredBarTintColor = safariPreferredBarTintColor
        safari.preferredControlTintColor = safariPreferredControlTintColor
        safari.dismissButtonStyle = safariDismissButtonStyle
        
        customize(safari)
        
        self.safari = safari
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        Wrapper()
    }
    
    struct Wrapper: View {
        @State private var showLink = false
        
        var body: some View {
            List {
                Button {
                    showLink = true
                } label: {
                    Text("Open Link")
                }
            }
            .safari(url: URL(string: "https://davidwalter.at")!, isPresented: $showLink)
        }
    }
}
