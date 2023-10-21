//
//  NewTaskOnChange.swift
//  Utils/Tasks
//
//  Created by David Walter on 21.10.23.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func taskOnChange<V>(
        priority: TaskPriority = .userInitiated,
        of value: V,
        initial: Bool = false,
        _ action: @Sendable @escaping (_ oldValue: V, _ newValue: V) async -> Void
    ) -> some View where V: Equatable {
        taskOnChange(priority: priority, of: value, initial: initial) { oldValue, newValue in
            await action(oldValue, newValue)
        } onError: { _ in
            
        }
    }
    
    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.

    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func taskOnChange<V>(
        priority: TaskPriority = .userInitiated,
        of value: V,
        initial: Bool = false,
        _ action: @Sendable @escaping () async -> Void
    ) -> some View where V: Equatable {
        taskOnChange(priority: priority, of: value, initial: initial) { _, _ in
            await action()
        }
    }
    
    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///   - oldValue: The old value that failed the comparison check (or the
    ///     initial value when requested).
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func taskOnChange<V>(
        priority: TaskPriority = .userInitiated,
        of value: V,
        initial: Bool = false,
        _ action: @Sendable @escaping (_ oldValue: V, _ newValue: V) async throws -> Void,
        onError: @escaping (Error) -> Void
    ) -> some View where V: Equatable {
        modifier(TaskOnChangeViewModifier(priority: priority, value: value, initial: initial, action: action, onError: onError))
    }
    
    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a
    /// value changing, such as an `Environment` key or a `Binding`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - initial: Whether the action should be run when this view initially
    ///     appears.
    ///   - action: A closure to run when the value changes.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    public func taskOnChange<V>(
        priority: TaskPriority = .userInitiated,
        of value: V,
        initial: Bool = false,
        _ action: @Sendable @escaping () async throws -> Void,
        onError: @escaping (Error) -> Void
    ) -> some View where V: Equatable {
        taskOnChange(priority: priority, of: value, initial: initial) { _, _ in
            try await action()
        } onError: { error in
            onError(error)
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
private struct TaskOnChangeViewModifier<V>: ViewModifier where V: Equatable {
    var priority: TaskPriority
    var value: V
    var initial: Bool
    var action: @Sendable (_ oldValue: V, _ newValue: V) async throws -> Void
    var onError: ((Error) -> Void)
    
    @State private var task: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value, initial: initial) { oldValue, newValue in
                task = Task(priority: priority) {
                    do {
                        try await action(oldValue, newValue)
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
