//
//  SwiftUIView.swift
//  Utils/LicensePlistUI
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI
import LicensePlist

struct LicensePlistEntryView: View {
    var entry: LicensePlist.Entry
    
    var body: some View {
        List {
            Section {
                if let source = entry.source {
                    if let url = URL(string: source) {
                        Link(destination: url) {
                            row(for: source)
                        }
                    } else {
                        row(for: source)
                    }
                }
            } footer: {
                Text(entry.license)
                    .multilineTextAlignment(.leading)
            }
        }
        .navigationTitle(entry.title)
    }
    
    @ViewBuilder
    func row(for source: String) -> some View {
        if #available(iOS 16.0, *) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    Text("licenseplist.source".localized())
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Group {
                        if let url = URL(string: source) {
                            Text(url.cleanString(percentEncoded: false))
                        } else {
                            Text(source)
                                .foregroundColor(.secondary)
                        }
                    }
                    .multilineTextAlignment(.trailing)
                }
                
                VStack(alignment: .leading) {
                    Text("licenseplist.source".localized())
                        .foregroundColor(.primary)
                    
                    Group {
                        if let url = URL(string: source) {
                            Text(url.cleanString(percentEncoded: false))
                        } else {
                            Text(source)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        } else {
            HStack {
                Text("licenseplist.source".localized())
                    .foregroundColor(.primary)
                
                Spacer()
                
                Group {
                    if let url = URL(string: source) {
                        Text(url.cleanString(percentEncoded: false))
                    } else {
                        Text(source)
                            .foregroundColor(.secondary)
                    }
                }
                .multilineTextAlignment(.trailing)
            }
        }
    }
}

struct LicensePlistEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LicensePlistEntryView(entry: LicensePlist.Entry(title: "Test B", license: "Some license", source: "https://github.com/test/test"))
        }
    }
}
