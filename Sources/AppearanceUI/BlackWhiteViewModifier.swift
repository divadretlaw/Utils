//
//  BlackWhiteViewModifier.swift
//  AppearanceUI
//
//  Created by David Walter on 19.05.23.
//

import SwiftUI

struct BlackWhiteViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
                .foregroundColor(.black)
                .clipShape(TriangleTopRight())
            
            content
                .foregroundColor(.white)
                .clipShape(TriangleBottomLeft())
        }
        .padding(5)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white)
                    .clipShape(TriangleTopRight())
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.black)
                    .clipShape(TriangleBottomLeft())
            }
        }
    }
}

struct TriangleTopRight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - 1, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 1))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        return path
    }
}

struct TriangleBottomLeft: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
}

struct BlackWhite_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            
            Image(systemName: "iphone")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .modifier(BlackWhiteViewModifier())
        }
        .previewLayout(.fixed(width: 100, height: 100))
    }
}
