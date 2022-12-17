//
//  AppearanceTests.swift
//  Utils
//
//  Created by David Walter on 17.12.22.
//

import XCTest
@testable import Appearance

final class AppearanceTests: XCTestCase {
    var manager: AppearanceManager!
    var device: MockDevice = .init()
    
    override func setUp() async throws {
        try await super.setUp()
        
        self.manager = AppearanceManager(userDefaults: UserDefaults(suiteName: "AppearanceTests") ?? .standard)
            .overrideBrightnessCheck {
                self.device.brightness
            }
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        UserDefaults.standard.removeSuite(named: "AppearanceTests")
    }
    
    func testSystem() throws {
        manager.mode = .system
        
        XCTAssertTrue(manager.userInterfaceStyle == .unspecified)
        XCTAssertTrue(manager.colorScheme == nil)
    }
    
    func testManual() throws {
        manager.mode = .manual
        
        manager.manualUserInterfaceStyle = .dark
        
        XCTAssertTrue(manager.userInterfaceStyle == .dark)
        XCTAssertTrue(manager.colorScheme == .dark)
        
        manager.manualUserInterfaceStyle = .light
        
        XCTAssertTrue(manager.userInterfaceStyle == .light)
        XCTAssertTrue(manager.colorScheme == .light)
    }
    
    func testScheduled() throws {
        manager.mode = .scheduled
    }
    
    func testBrightness() throws {
        manager.mode = .brightness
        
        device.brightness = 1
        
        XCTAssertTrue(manager.userInterfaceStyle == .light)
        XCTAssertTrue(manager.colorScheme == .light)
        
        device.brightness = 0.5
        
        XCTAssertTrue(manager.userInterfaceStyle == .light)
        XCTAssertTrue(manager.colorScheme == .light)
        
        device.brightness = 0.25
        
        XCTAssertTrue(manager.userInterfaceStyle == .dark)
        XCTAssertTrue(manager.colorScheme == .dark)
        
        device.brightness = 0.1
        
        XCTAssertTrue(manager.userInterfaceStyle == .dark)
        XCTAssertTrue(manager.colorScheme == .dark)
    }
}
