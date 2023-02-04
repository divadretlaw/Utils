//
//  ListAlternateIconView.swift
//  Utils/AlternateIconUI
//
//  Created by David Walter on 17.12.22.
//

#if os(iOS)
import SwiftUI

struct ListAlternateIconView<Icon>: View where Icon: AlternateIcon {
    @Environment(\.showCheckmark) var showCheckmark
    @Environment(\.maxAppIconSize) var maxAppIconSize
    
    var icons: [Icon]
    
    @State private var checkmark = UUID()
    
    init(icons: [Icon]) {
        self.icons = icons
    }
    
    var body: some View {
        List {
            ForEach(icons) { item in
                Button {
                    UIApplication.shared.setAlternateIconName(item.alternateIconName) { error in
                        guard error == nil else {
                            return
                        }
                        
                        checkmark = UUID()
                    }
                } label: {
                    HStack(spacing: 0) {
                        item.icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: maxAppIconSize, height: maxAppIconSize, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: maxAppIconSize / 5, style: .continuous))
                            .padding(.trailing, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            item.subtitle.map {
                                Text($0)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        if showCheckmark {
                            Image(systemName: "checkmark")
                                .font(.body.weight(.bold))
                                .opacity(UIApplication.shared.alternateIconName == item.alternateIconName ? 1 : 0)
                                .id(checkmark)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.grouped)
    }
}

#if DEBUG
struct ListAlternateIconView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlternateIconView(icons: PreviewAlternateIcon.allCases)
                .style(.list)
                .navigationTitle("App Icon")
        }
    }
}
#endif
#endif
