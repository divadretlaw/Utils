//
//  AboutView.swift
//  Utils/AppInfoUI
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI
import AppInfo

public struct AboutView: View {
    let appInfo = AppInfo()
    let additional: [String]
    
    var titleColor = Color.primary
    var additionalColor = Color.primary
    
    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            appIcon
                .resizable()
                .foregroundColor(.accentColor)
                .frame(width: 60, height: 60, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appName)
                    .font(.headline)
                    .foregroundColor(titleColor)
                    .lineLimit(1)
                
                ForEach(additional, id: \.self) { text in
                    Text(text)
                        .font(.subheadline)
                        .foregroundColor(additionalColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .textCase(nil)
    }
    
    var appIcon: Image {
        #if canImport(UIKit)
        if let icon = appInfo.icon {
            return Image(uiImage: icon)
        } else {
            return Image(systemName: "app.dashed")
        }
        #else
        return Image(systemName: "app.dashed")
        #endif
    }
    
    var appName: String {
        [appInfo.name, appInfo.version]
            .compactMap { $0 }
            .joined(separator: " ")
    }
    
    public init(additional: [String] = []) {
        self.additional = additional
    }
    
    public init(additional: String...) {
        self.additional = additional
    }
    
    public func titleColor(_ color: Color) -> Self {
        var view = self
        view.titleColor = color
        return view
    }
    
    public func additionalColor(_ color: Color) -> Self {
        var view = self
        view.additionalColor = color
        return view
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section {
                    Text("Some other info")
                } header: {
                    AboutView(additional: ["by David Walter"])
                        .padding(.vertical)
                }
                
                Section {
                    Text("Some other info")
                } header: {
                    AboutView(additional: "by David Walter", "and others...")
                        .padding(.vertical)
                }
            }
            .navigationTitle("About")
        }
    }
}
