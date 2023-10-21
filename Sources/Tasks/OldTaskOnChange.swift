//
//  OldTaskOnChange.swift
//  Utils/Tasks
//
//  Created by David Walter on 21.10.23.
//

import SwiftUI

extension View {
    /// Adds an action to perform when the given value changes.
    ///
    /// Use this modifier to trigger a side effect when a value changes, like
    /// the value associated with an ``SwiftUI/Environment`` value or a
    /// ``SwiftUI/Binding``.
    ///
    /// - Parameters:
    ///   - value: The value to check when determining whether to run the
    ///     closure. The value must conform to the `Equatable` protocol.
    ///   - action: A closure to run when the value changes. The closure
    ///     provides a single `newValue` parameter that indicates the changed
    ///     value.
    ///
    /// - Returns: A view that triggers an action in response to a change.
    @available(iOS, deprecated: 17.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(macOS, deprecated: 14.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(tvOS, deprecated: 17.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(watchOS, deprecated: 10.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(visionOS, deprecated: 1.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    public func taskOnChange<V>(
        priority: TaskPriority = .userInitiated,
        of value: V,
        perform action: @Sendable @escaping (_ newValue: V) async -> Void
    ) -> some View where V: Equatable {
        taskOnChange(priority: priority, of: value) { newValue in
            await action(newValue)
        } onError: { _ in
            
        }
    }
    
    /// Adds an action to perform when the given value changes.
    ///
    /// Use this modifier to trigger a side effect when a value changes, like
    /// the value associated with an ``SwiftUI/Environment`` value or a
    /// ``SwiftUI/Binding``.
    ///
    /// - Parameters:
    ///   - value: The value to check when determining whether to run the
    ///     closure. The value must conform to the `Equatable` protocol.
    ///   - action: A closure to run when the value changes. The closure
    ///     provides a single `newValue` parameter that indicates the changed
    ///     value.
    ///
    /// - Returns: A view that triggers an action in response to a change.
    @available(iOS, deprecated: 17.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(macOS, deprecated: 14.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(tvOS, deprecated: 17.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(watchOS, deprecated: 10.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    @available(visionOS, deprecated: 1.0, message: "Use `taskOnChange` with a two or zero parameter action closure instead.")
    public func taskOnChange<V>(
        priority: TaskPriority = .userInitiated,
        of value: V,
        perform action: @Sendable @escaping (_ newValue: V) async throws -> Void,
        onError: @escaping ((Error) -> Void)
    ) -> some View where V: Equatable {
        modifier(TaskOnChangeViewModifier(priority: priority, value: value, action: action, onError: onError))
    }
}

private struct TaskOnChangeViewModifier<V>: ViewModifier where V: Equatable {
    var priority: TaskPriority
    var value: V
    var action: @Sendable (_ newValue: V) async throws -> Void
    var onError: ((Error) -> Void)
    
    @State private var task: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value) { _ in
                task = Task(priority: priority) {
                    do {
                        try await action(value)
                    } catch {
                        onError(error)
                    }
                }
            }
            .onDisappear {
                task?.cancel()
            }
    }
}
