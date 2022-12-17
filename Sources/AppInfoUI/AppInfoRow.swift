//
//  AppInfoRow.swift
//  Utils/AppInfoUI
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI
import AppInfo

public struct AppInfoRow: View {
    var title: String
    var value: String
    
    public init?(_ title: String, for keyPath: KeyPath<AppInfo, String?>, appInfo: AppInfo = AppInfo()) {
        self.title = title
        guard let value = appInfo.string(keyPath) else { return nil }
        self.value = value
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct AppInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section {
                    AppInfoRow("Version", for: \.version)
                    AppInfoRow("Build", for: \.buildNumber)
                    AppInfoRow("SDK", for: \.sdkVersion)
                } footer: {
                    AboutView(additional: ["by David Walter"])
                        .padding(.vertical)
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}
