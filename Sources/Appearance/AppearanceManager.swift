//
//  AppearanceManager.swift
//  Utils/Appearance
//
//  Created by David Walter on 17.12.22.
//

#if canImport(UIKit)
import Foundation
import Defaults
import SwiftUI
import UIKit

/// Handles the appearance of the application
public class AppearanceManager: ObservableObject {
    /// The currently selected ``AppearanceMode``
    @Published public var mode: AppearanceMode {
        didSet {
            userDefaults.mode = mode
            apply()
        }
    }
    
    private var userDefaults: UserDefaults
    
    /// Initialize a ``AppearanceManager``
    ///
    /// - Parameter userDefaults: The `UserDefaults` to use to store the configuration
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
        self.mode = userDefaults.mode
        
        self.manualUserInterfaceStyle = userDefaults.manualUserInterfaceStyle
        
        self.scheduleLight = Date.today.addingTimeInterval(userDefaults.scheduleLight)
        self.scheduleDark = Date.today.addingTimeInterval(userDefaults.scheduleDark)
        
        self.brightnessCheck = Self.defaultBrightnessCheck
        self.brightnessThreshold = userDefaults.brightnessThreshold
        
        _ = NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: self, queue: nil) { _ in
            self.apply()
        }
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(brightnessDidChange),
                                               name: UIScreen.brightnessDidChangeNotification,
                                               object: nil)
        #endif
        
        apply()
    }
    
    /// The current `UIUserInterfaceStyle`
    public var userInterfaceStyle: UIUserInterfaceStyle {
        switch mode {
        case .system:
            return .unspecified
        case .manual:
            return manualUserInterfaceStyle
        #if !targetEnvironment(macCatalyst)
        case .brightness:
            switch brightnessCheck() {
            case 0...brightnessThreshold:
                return .dark
            default:
                return .light
            }
        #endif
        case .scheduled:
            switch Date() {
            case Date.today.addingTimeInterval(userDefaults.scheduleLight)...Date.today.addingTimeInterval(userDefaults.scheduleDark):
                return .light
            default:
                return .dark
            }
        }
    }
    
    /// The current`ColorScheme`
    public var colorScheme: ColorScheme? {
        userInterfaceStyle.colorScheme
    }
    
    /// Apply the appearance based on configuration
    public func apply() {
        setupTimer()
        
        UIApplication.shared.connectedScenes.forEach { scene in
            if let windowScene = scene as? UIWindowScene {
                windowScene.windows.forEach { window in
                    UIView.transition(with: window, duration: 0.3) { [userInterfaceStyle] in
                        window.overrideUserInterfaceStyle = userInterfaceStyle
                    }
                }
            }
        }
    }
    
    // MARK: - Manual
    
    /// The `UIUserInterfaceStyle` for ``AppearanceMode/manual``
    @Published public var manualUserInterfaceStyle: UIUserInterfaceStyle {
        didSet {
            userDefaults.manualUserInterfaceStyle = manualUserInterfaceStyle
            apply()
        }
    }
    
    // MARK: - Scheduled
    
    private var lightTimer: Timer?
    private var darkTimer: Timer?
    
    /// Start light mode at hour & minute of date. Used for ``AppearanceMode/scheduled``
    @Published public var scheduleLight: Date {
        didSet {
            userDefaults.scheduleLight = scheduleLight.secondsSinceMidnight
            apply()
        }
    }
    
    /// Start dark mode at hour & minute of date. Used for ``AppearanceMode/scheduled``
    @Published public var scheduleDark: Date {
        didSet {
            userDefaults.scheduleDark = scheduleDark.secondsSinceMidnight
            apply()
        }
    }
    
    func setupTimer() {
        self.lightTimer?.invalidate()
        self.darkTimer?.invalidate()
        
        guard mode == .scheduled else {
            self.lightTimer = nil
            self.darkTimer = nil
            return
        }
        
        let lightTimer = Timer(fireAt: Date.today.addingTimeInterval(userDefaults.scheduleLight),
                               interval: 0,
                               target: self,
                               selector: #selector(scheduleDidChange),
                               userInfo: nil,
                               repeats: false)
        
        let darkTimer = Timer(fireAt: Date.today.addingTimeInterval(userDefaults.scheduleDark),
                              interval: 0,
                              target: self,
                              selector: #selector(scheduleDidChange),
                              userInfo: nil,
                              repeats: false)
        
        RunLoop.main.add(lightTimer, forMode: .common)
        RunLoop.main.add(darkTimer, forMode: .common)
        
        self.lightTimer = lightTimer
        self.darkTimer = darkTimer
    }
    
    @objc func scheduleDidChange() {
        guard mode == .scheduled else { return }
        apply()
    }
    
    // MARK: - Brightness
    
    var brightnessCheck: () -> CGFloat
    
    static var defaultBrightnessCheck: () -> CGFloat = {
        UIScreen.main.brightness
    }
    
    /// Override the brightness check with your own implementation
    ///
    /// - Parameter callback: Called whenever a brightnes check is performed. `nil` will use the default implemenetion
    ///
    /// - Returns: `AppearanageManager` with a custom brightness check
    @discardableResult public func overrideBrightnessCheck(callback: (() -> CGFloat)?) -> Self {
        self.brightnessCheck = callback ?? Self.defaultBrightnessCheck
        return self
    }
    
    /// The brightness threshold for ``AppearanceMode/brightness``
    @Published public var brightnessThreshold: Double {
        didSet {
            userDefaults.brightnessThreshold = brightnessThreshold
        }
    }
    
    #if !targetEnvironment(macCatalyst)
    @objc func brightnessDidChange() {
        guard mode == .brightness else { return }
        apply()
    }
    #endif
}
#endif
