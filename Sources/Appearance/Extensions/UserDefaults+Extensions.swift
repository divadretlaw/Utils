//
//  UserDefaults+Extensions.swift
//  Utils/Appearance
//
//  Created by David Walter on 17.12.22.
//

import Foundation
import Defaults
import UIKit

extension UserDefaults {
    var mode: AppearanceMode {
        get {
            AppearanceMode(rawValue: self.integer(forKey: "Utils:AppearanceManager-mode")) ?? .system
        }
        set {
            self.set(newValue.rawValue, forKey: "Utils:AppearanceManager-mode")
        }
    }
    
    var manualUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            UIUserInterfaceStyle(rawValue: self.integer(forKey: "Utils:AppearanceManager-manual")) ?? UITraitCollection.current.userInterfaceStyle
        }
        set {
            self.set(newValue.rawValue, forKey: "Utils:AppearanceManager-manual")
        }
    }
    
    var scheduleLight: TimeInterval {
        get {
            self.value(forKey: "Utils:AppearanceManager-scheduleLight", default: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: .today)?.timeIntervalSince(.today) ?? 0)
        }
        set {
            self.set(newValue, forKey: "Utils:AppearanceManager-scheduleLight")
        }
    }
    
    var scheduleDark: TimeInterval {
        get {
            self.value(forKey: "Utils:AppearanceManager-scheduleDark", default: Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: .today)?.timeIntervalSince(.today) ?? 0)
        }
        set {
            self.set(newValue, forKey: "Utils:AppearanceManager-scheduleDark")
        }
    }
    
    var brightnessThreshold: Double {
        get {
            self.value(forKey: "Utils:AppearanceManager-brightnessThreshold", default: 0.25)
        }
        set {
            self.set(newValue, forKey: "Utils:AppearanceManager-brightnessThreshold")
        }
    }
}
