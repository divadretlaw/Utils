//
//  GridAlternateIconView.swift
//  Utils/AlternateIconUI
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI

struct GridAlternateIconView<Icon>: View where Icon: AlternateIcon {
    @Environment(\.labelsHidden) var isLabelHidden
    @Environment(\.showCheckmark) var showCheckmark
    @Environment(\.maxAppIconSize) var maxAppIconSize
    
    var icons: [Icon]
    let numberOfColumns: Int
    let spacing: CGFloat = 20
    
    @State private var checkmark = UUID()
    
    init(icons: [Icon], columns: Int) {
        self.icons = icons
        self.numberOfColumns = columns
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns(for: proxy.size.width), alignment: .center, spacing: spacing) {
                    ForEach(icons) { item in
                        Button {
                            UIApplication.shared.setAlternateIconName(item.alternateIconName) { error in
                                guard error == nil else {
                                    return
                                }
                                
                                checkmark = UUID()
                            }
                        } label: {
                            VStack {
                                item.icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: maxAppIconSize)
                                    .clipShape(RoundedRectangle(cornerRadius: maxAppIconSize / 5, style: .continuous))
                                    .overlay(alignment: .bottomTrailing) {
                                        if showCheckmark {
                                            Image(systemName: "checkmark.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: maxAppIconSize / 3)
                                                .foregroundStyle(.white, .green)
                                                .opacity(UIApplication.shared.alternateIconName == item.alternateIconName ? 1 : 0)
                                                .id(checkmark)
                                                .offset(x: maxAppIconSize / 10, y: maxAppIconSize / 20)
                                        }
                                    }
                                
                                if !isLabelHidden {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    func columns(for width: CGFloat) -> [GridItem] {
        let columns = CGFloat(numberOfColumns)
        let calculatedWidth = (width - (columns + 1) * spacing) / columns
        
        return Array(repeating: GridItem(.fixed(calculatedWidth), spacing: spacing), count: numberOfColumns)
    }
}

#if DEBUG
struct GridAlternateIconView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlternateIconView(icons: PreviewAlternateIcon.allCases)
                .style(.grid(columns: 3))
                .labelsHidden()
                .maxAppIconSize(80)
                .navigationTitle("App Icon")
        }
        .previewDisplayName("Grid 3x3")
        
        NavigationView {
            AlternateIconView(icons: PreviewAlternateIcon.allCases)
                .style(.grid(columns: 2))
                .maxAppIconSize(120)
                .navigationTitle("App Icon")
        }
        .previewDisplayName("Grid 2x2")
        
        NavigationView {
            AlternateIconView(icons: PreviewAlternateIcon.allCases)
                .style(.grid(columns: 4))
                .labelsHidden()
                .navigationTitle("App Icon")
        }
        .previewDisplayName("Grid 4x4")
    }
}
#endif
