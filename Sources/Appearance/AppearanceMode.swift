//
//  AppearanceMode.swift
//  Utils/Appearance
//
//  Created by David Walter on 17.12.22.
//

import Foundation

/// Supported modes for appearance determination
public enum AppearanceMode: Int, CaseIterable, Identifiable, CustomStringConvertible {
    /// Use the system appearance
    case system
    /// Manually choose the appearance
    case manual
    /// Apply the appearance based on a schedule
    case scheduled
    #if !targetEnvironment(macCatalyst)
    /// Apply the appearance based on screen brightness
    case brightness
    #endif
    
    // MARK: Identifiable
    
    public var id: Int { rawValue }
    
    // MARK: CustomStringConvertible
    
    public var description: String {
        switch self {
        case .system:
            return "system"
        case .manual:
            return "manual"
        case .scheduled:
            return "scheduled"
        #if !targetEnvironment(macCatalyst)
        case .brightness:
            return "brightness"
        #endif
        }
    }
}
