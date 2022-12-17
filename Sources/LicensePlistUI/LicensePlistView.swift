//
//  LicensePlistView.swift
//  Utils/LicensePlistUI
//
//  Created by David Walter on 13.02.22.
//

import SwiftUI
import LicensePlist

public struct LicensePlistView: View {
    var data: LicensePlist
    
    public var body: some View {
        List {
            ForEach(data.entries, id: \.self) { entry in
                NavigationLink {
                    LicensePlistEntryView(entry: entry)
                } label: {
                    Text(entry.title)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    public init(data: LicensePlist) {
        self.data = data
    }
}

#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LicensePlistView(data: LicensePlist(entries: [LicensePlist.Entry(title: "Test A", license: "Some license"),
                                                          LicensePlist.Entry(title: "Test B", license: "Some license", source: "https://github.com/test/test")]))
                .navigationBarTitle("Licenses")
        }
    }
}
#endif
