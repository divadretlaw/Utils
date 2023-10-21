//
//  AppearanceManagerViewModifier.swift
//  Utils/AppearanceUI
//
//  Created by David Walter on 21.10.23.
//

import SwiftUI
import Appearance

public extension View {
    func setupAppearanceManager() -> some View {
        setupAppearanceManager {
            AppearanceManager()
        } onAppear: { appearanceManager in
            appearanceManager.apply()
        }
    }
    
    func setupAppearanceManager(onAppear: ((AppearanceManager) -> Void)? = nil) -> some View {
        setupAppearanceManager {
            AppearanceManager()
        } onAppear: { appearanceManager in
            onAppear?(appearanceManager)
        }
    }
    
    func setupAppearanceManager(build: () -> AppearanceManager, onAppear: ((AppearanceManager) -> Void)? = nil) -> some View {
        modifier(AppearanceManagerViewModifier(appearanceManager: build(), onAppear: onAppear))
    }
}

private struct AppearanceManagerViewModifier: ViewModifier {
    let appearanceManager: AppearanceManager
    var onAppear: ((AppearanceManager) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .environmentObject(appearanceManager)
            .onAppear {
                onAppear?(appearanceManager)
            }
    }
}
