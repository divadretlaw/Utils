//
//  TaskOnChange.swift
//  Utils/Tasks
//
//  Created by David Walter on 21.10.23.
//

import SwiftUI
import Combine

extension View {
    /// Adds an action to perform when this view detects data emitted by the given publisher.
    ///
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to.
    ///   - action: The action to perform when an event is emitted by
    ///     `publisher`. The event emitted by publisher is passed as a
    ///     parameter to `action`.
    ///
    /// - Returns: A view that triggers `action` when `publisher` emits an
    ///   event.
    public func taskOnReceive<P>(
        priority: TaskPriority = .userInitiated,
        _ publisher: P,
        perform action: @escaping (P.Output) async -> Void
    ) -> some View where P: Publisher, P.Failure == Never {
        taskOnReceive(priority: priority, publisher) { output in
            await action(output)
        } onError: { _ in
            
        }
    }
    
    /// Adds an action to perform when this view detects data emitted by the given publisher.
    ///
    /// - Parameters:
    ///   - publisher: The publisher to subscribe to.
    ///   - action: The action to perform when an event is emitted by
    ///     `publisher`. The event emitted by publisher is passed as a
    ///     parameter to `action`.
    ///
    /// - Returns: A view that triggers `action` when `publisher` emits an
    ///   event.
    public func taskOnReceive<P>(
        priority: TaskPriority = .userInitiated,
        _ publisher: P,
        perform action: @escaping (P.Output) async throws -> Void,
        onError: @escaping ((Error) -> Void)
    ) -> some View where P: Publisher, P.Failure == Never {
        modifier(TaskOnReceiveViewModifier(priority: priority, publisher: publisher, action: action, onError: onError))
    }
}

private struct TaskOnReceiveViewModifier<P>: ViewModifier where P: Publisher, P.Failure == Never {
    var priority: TaskPriority
    var publisher: P
    var action: (P.Output) async throws -> Void
    var onError: ((Error) -> Void)
    
    @State private var task: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .onReceive(publisher) { output in
                task = Task(priority: priority) {
                    do {
                        try await action(output)
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
