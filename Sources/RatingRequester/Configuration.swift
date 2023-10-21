//
//  Configuration.swift
//  Utils/RatingRequester
//
//  Created by David Walter on 27.06.23.
//

import Foundation

public extension RatingRequester {
    /// The configuration for ``RatingRequester``
    struct Configuration {
        internal var timeIntervalSinceFirstLaunch: TimeInterval?
        internal var timeIntervalSinceLastRequest: TimeInterval?
        internal var totalAppSessions: Int?
        internal var recentAppSessions: Int?
        internal var significantEvents: Int?
        internal var requiresNewVersion: Bool
        internal var delay: UInt64
        
        /// Create an empty configuration
        public init() {
            self.timeIntervalSinceFirstLaunch = nil
            self.timeIntervalSinceLastRequest = nil
            self.totalAppSessions = nil
            self.recentAppSessions = nil
            self.significantEvents = nil
            self.requiresNewVersion = true
            self.delay = 0
        }
        
        
        /// Set the minimum time since first launch
        /// - Parameter value: The time interval in seconds
        public func timeSinceFirstLaunch(seconds value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceFirstLaunch = value
            return config
        }
        
        /// Set the minimum time since first launch
        /// - Parameter value: The time interval in days
        public func timeSinceFirstLaunch(days value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceFirstLaunch = value * 86_400 // 24 hours in seconds
            return config
        }
        
        /// Set the minimum time since last request
        /// - Parameter value: The time interval in seconds
        public func timeSinceLastRequest(seconds value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceLastRequest = value
            return config
        }
        
        /// Set the minimum time since last request
        /// - Parameter value: The time interval in days
        public func timeSinceLastRequest(days value: TimeInterval) -> Self {
            var config = self
            config.timeIntervalSinceLastRequest = value * 86_400 // 24 hours in seconds
            return config
        }
        
        /// Set the minimum app sessions
        /// - Parameter value: The number of total app sessions
        public func totalAppSessions(_ value: Int) -> Self {
            var config = self
            config.totalAppSessions = value
            return config
        }
        
        /// Set the minimum recent app sessions
        /// - Parameter value: The number of recent app sessions
        public func recentAppSessions(_ value: Int) -> Self {
            var config = self
            config.recentAppSessions = value
            return config
        }
        
        /// Set the minimum significant events
        /// - Parameter value: The number of significant events
        public func significantEvents(_ value: Int) -> Self {
            var config = self
            config.significantEvents = value
            return config
        }
        
        /// Whehter it should only appear
        /// - Parameter value: The number of recetnt app sessions
        public func requiresNewVersion(_ value: Bool) -> Self {
            var config = self
            config.requiresNewVersion = value
            return config
        }
        
        /// Delay the appearance of the request
        /// - Parameter seconds: The delay in seconds
        public func delay(seconds: Double) -> Self {
            var config = self
            config.delay = UInt64(seconds * 1_000_000_000)
            return config
        }
    }
}
