//
//  Configuration.swift
//  RatingRequester
//
//  Created by David Walter on 27.06.23.
//

import Foundation

public extension RatingRequester {
    struct Configuration {
        internal var timeIntervalSinceFirstLaunch: TimeInterval?
        internal var timeIntervalSinceLastRequest: TimeInterval?
        internal var totalAppSessions: Int?
        internal var recentAppSessions: Int?
        internal var significantEvents: Int?
        internal var requiresNewVersion: Bool
        internal var delay: UInt64
        
        public init() {
            self.timeIntervalSinceFirstLaunch = nil
            self.timeIntervalSinceLastRequest = nil
            self.totalAppSessions = nil
            self.recentAppSessions = nil
            self.significantEvents = nil
            self.requiresNewVersion = true
            self.delay = 0
        }
        
        public func timeIntervalSinceFirstLaunch(_ value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceFirstLaunch = value
            return config
        }
        
        public func daysSinceFirstLaunch(_ value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceFirstLaunch = value * 86_400 // 24 hours in seconds
            return config
        }
        
        public func timeIntervalSinceLastRequest(_ value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceLastRequest = value
            return config
        }
        
        public func daysSinceLastRequest(_ value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceLastRequest = value * 86_400 // 24 hours in seconds
            return config
        }
        
        public func totalAppSessions(_ value: Int) -> Self {
            var config = self
            config.totalAppSessions = value
            return config
        }
        
        public func significantEvents(_ value: Int) -> Self {
            var config = self
            config.significantEvents = value
            return config
        }
        
        public func requiresNewVersion(_ value: Bool) -> Self {
            var config = self
            config.requiresNewVersion = value
            return config
        }
        
        public func delay(seconds: Double) -> Self {
            var config = self
            config.delay = UInt64(seconds * 1_000_000_000)
            return config
        }
    }
}
