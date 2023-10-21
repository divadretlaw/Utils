//
//  API.swift
//  Utils/RatingRequester
//
//  Created by David Walter on 27.06.23.
//

import SwiftUI

public extension View {
    /// Ask for a rating
    /// 
    /// - Parameter perform: Callback to configure the ``RatingRequester``
    func askForRating(perform: @escaping (RatingRequester) async -> Void) -> some View {
        modifier(RatingRequesterViewModifier(perform: perform))
    }
}

private struct RatingRequesterViewModifier: ViewModifier {
    var perform: (RatingRequester) async -> Void
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.ratingRequester) private var ratingRequester
    
    @State private var ratingTask: UUID?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { scenePhase in
                switch scenePhase {
                case .active:
                    ratingTask = UUID()
                default:
                    ratingTask = nil
                }
            }
            .task(id: ratingTask) {
                guard ratingTask != nil else {
                    return
                }
                
                await perform(ratingRequester)
            }
    }
}

private struct RatingRequesterEnvironmentKey: EnvironmentKey {
    static var defaultValue: RatingRequester {
        RatingRequester.shared
    }
}

public extension EnvironmentValues {
    var ratingRequester: RatingRequester {
        get { self[RatingRequesterEnvironmentKey.self] }
        set { self[RatingRequesterEnvironmentKey.self] = newValue }
    }
}
