//
//  RatingRequester.swift
//  RatingRequester
//
//  Created by David Walter on 26.06.23.
//

import Foundation
import StoreKit
#if os(iOS)
import UIKit
#endif
import AppInfo

public final class RatingRequester {
    public static var shared: RatingRequester = .init()
    
    internal var configuration: Configuration?
    
    private var firstLaunchDate: Binding<Date>?
    private var lastRequestDate: Binding<Date>?
    private var numberOfSignificantEvents: Binding<Int>?
    private var numberOfTotalAppSessions: Binding<Int>?
    private var numberOfRecentAppSessions: Binding<Int>?
    private var lastRequestVersion: Binding<String?>?
    
    init() {
        self.configuration = nil
    }
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    @discardableResult public func setConfiguration(_ configuration: Configuration) -> Self {
        self.configuration = configuration
        return self
    }
    
    private func checkConfiguration() -> Bool {
        guard let configuration else { return false }
        
        let evaluatedConfig: [String: Bool] = [
            "timeIntervalSinceFirstLaunch": {
                guard let timeInterval = configuration.timeIntervalSinceFirstLaunch else { return true }
                guard let firstLaunchDate else { return false }
                return Date.now.timeIntervalSince(firstLaunchDate.wrappedValue) > timeInterval
            }(),
            "timeIntervalSinceLastRequest": {
                guard let timeInterval = configuration.timeIntervalSinceLastRequest else { return true }
                guard let lastRequestDate else { return false }
                return Date.now.timeIntervalSince(lastRequestDate.wrappedValue) > timeInterval
            }(),
            "totalAppSessions": {
                guard let minimumTotalAppSessions = configuration.totalAppSessions else { return true }
                guard let numberOfTotalAppSessions else { return false }
                return numberOfTotalAppSessions.wrappedValue > minimumTotalAppSessions
            }(),
            "recentAppSessions": {
                guard let minimumRecentAppSessions = configuration.recentAppSessions else { return true }
                guard let numberOfRecentAppSessions else { return false }
                return numberOfRecentAppSessions.wrappedValue > minimumRecentAppSessions
            }(),
            "numberOfSignificantEvents": {
                guard let minimumSignificantEvents = configuration.significantEvents else { return true }
                guard let numberOfSignificantEvents else { return false }
                return numberOfSignificantEvents.wrappedValue > minimumSignificantEvents
            }(),
            "lastRequestVersion": {
                guard configuration.requiresNewVersion else { return true }
                return AppInfo.version != lastRequestVersion?.wrappedValue
            }()
        ]
        return !evaluatedConfig.values.contains(false)
    }
    
    private func reset() {
        numberOfRecentAppSessions?.wrappedValue = 0
        lastRequestDate?.wrappedValue = .now
        lastRequestVersion?.wrappedValue = AppInfo.version
    }
    
    #if os(iOS)
    public func requestReview(in windowScene: UIWindowScene) async {
        guard checkConfiguration() else { return }
        do {
            if let delay = configuration?.delay {
                try await Task.sleep(nanoseconds: delay)
            }
            await SKStoreReviewController.requestReview(in: windowScene)
            reset()
        } catch {
            // cancelled
        }
    }
    #else
    public func requestReview() async {
        guard checkConfiguration() else { return }
        do {
            if let delay = configuration?.delay {
                try await Task.sleep(nanoseconds: delay)
            }
            await SKStoreReviewController.requestReview()
            reset()
        } catch {
            // cancelled
        }
    }
    #endif
    
    // MARK: First App Launch Date
    
    public func firstLaunchDate(callback: @escaping () -> Date) -> Self {
        self.firstLaunchDate = Binding(get: callback)
        return self
    }
    
    // MARK: Last Request Date
    
    public func lastRequestDate(key: String, userDefaults: UserDefaults = .standard) -> Self {
        lastRequestDate = Binding {
            Date(timeIntervalSince1970: userDefaults.double(forKey: key))
        } set: { value in
            userDefaults.set(value.timeIntervalSince1970, forKey: key)
        }
        return self
    }
    
    public func lastRequestDate(get: @escaping () -> Date, set: @escaping (Date) -> Void) -> Self {
        lastRequestDate = Binding(get: get, set: set)
        return self
    }
    
    // MARK: Number of Total App Sessions
    
    public func numberOfTotalAppSessions(key: String, userDefaults: UserDefaults = .standard) -> Self {
        numberOfTotalAppSessions = Binding {
            userDefaults.integer(forKey: key)
        }
        return self
    }
    
    public func numberOfTotalAppSessions(get: @escaping () -> Int) -> Self {
        numberOfTotalAppSessions = Binding(get: get)
        return self
    }
    
    // MARK: Number of Recent App Sessions
    
    public func addRecentAppSession() {
        numberOfRecentAppSessions?.wrappedValue += 1
    }
    
    public func numberOfRecentAppSessions(key: String, userDefaults: UserDefaults = .standard) -> Self {
        numberOfRecentAppSessions = Binding {
            userDefaults.integer(forKey: key)
        } set: { value in
            userDefaults.set(value, forKey: key)
        }
        return self
    }
    
    public func numberOfRecentAppSessions(get: @escaping () -> Int, set: @escaping (Int) -> Void) -> Self {
        numberOfRecentAppSessions = Binding(get: get, set: set)
        return self
    }
    
    // MARK: Significant Events
    
    public func addSignificantEvent() {
        numberOfSignificantEvents?.wrappedValue += 1
    }
    
    public func numberOfSignificantEvents(key: String, userDefaults: UserDefaults = .standard) -> Self {
        numberOfSignificantEvents = Binding {
            userDefaults.integer(forKey: key)
        } set: { value in
            userDefaults.set(value, forKey: key)
        }
        return self
    }
    
    public func numberOfSignificantEvents(get: @escaping () -> Int, set: @escaping (Int) -> Void) -> Self {
        numberOfSignificantEvents = Binding(get: get, set: set)
        return self
    }
    
    // MARK: Last Request Version
    
    public func lastRequestVersion(key: String, userDefaults: UserDefaults = .standard) -> Self {
        lastRequestVersion = Binding {
            userDefaults.string(forKey: key)
        } set: { value in
            userDefaults.set(value, forKey: key)
        }
        return self
    }
    
    public func lastRequestVersion(get: @escaping () -> String?, set: @escaping (String?) -> Void) -> Self {
        lastRequestVersion = Binding(get: get, set: set)
        return self
    }
}
