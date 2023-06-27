//
//  TaskButton.swift
//  Utils/TaskButton
//
//  Created by David Walter on 21.01.23.
//

import SwiftUI

public struct TaskButton<Label>: View  where Label: View {
    var role: ButtonRole?
    var mode: TaskButtonMode = .disabled
    var priority: TaskPriority?
    var action: @Sendable () async throws -> Void
    var label: (Bool) -> Label
    var error: ((Error) -> Void)?
    
    @State private var isRunning = false
    @State private var task: Task<(), Never>?
    
    /// Creates a button with a specified role that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The async action to perform when the user interacts with the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    ///   - error: Callback in case an error occurs within the button's `action`. A value of
    ///     `nil` means the error is silently ignored.
    public init(
        role: ButtonRole? = nil,
        action: @MainActor @Sendable @escaping () async throws -> Void,
        @ViewBuilder label: @escaping () -> Label,
        error: ((Error) -> Void)? = nil
    ) {
        self.role = role
        self.action = action
        self.label = { _ in label() }
        self.error = error
    }
    
    /// Creates a button with a specified role that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The async action to perform when the user interacts with the button.
    ///   - label: A view that describes the purpose of the button's `action`.
    ///   - error: Callback in case an error occurs within the button's `action`. A value of
    ///     `nil` means the error is silently ignored.
    public init(
        role: ButtonRole? = nil,
        mode: TaskButtonMode = .disabled,
        action: @MainActor @Sendable @escaping () async throws -> Void,
        @ViewBuilder label: @escaping (_ isRunning: Bool) -> Label,
        error: ((Error) -> Void)? = nil
    ) {
        self.role = role
        self.mode = mode
        self.action = action
        self.label = label
        self.error = error
    }
    
    public var body: some View {
        Button(role: role) {
            if self.isRunning {
                print("TaskButton is running. Cancelling.")
                self.task?.cancel()
                
                switch mode {
                case .disabled:
                    print("TaskButton was disabled.")
                    return
                case .cancel:
                    self.isRunning = false
                    return
                case .cancelAndRetry:
                    break
                }
            }
            
            self.isRunning = true
            self.task = Task(priority: priority) {
                do {
                    print("Start TaskButton action.")
                    try await action()
                } catch {
                    self.error?(error)
                }
                guard !Task.isCancelled else { return }
                print("Start TaskButton action done.")
                self.isRunning = false
            }
        } label: {
            label(isRunning)
        }
        .animation(.default, value: isRunning)
        .disabled(isDisabled)
        .onDisappear {
            task?.cancel()
        }
    }
    
    private var isDisabled: Bool {
        switch mode {
        case .disabled:
            return isRunning
        case .cancel:
            return false
        case .cancelAndRetry:
            return false
        }
    }
    
    /// The priority of the task. Pass `nil` to use the priority from `Task.currentPriority`.
    func taskPriority(_ priority: TaskPriority?) -> Self {
        var button = self
        button.priority = priority
        return button
    }
    
    /// The mode of the task button. Defaults to ``TaskButtonMode/disabled``.
    func taskButtonMode(_ mode: TaskButtonMode) -> Self {
        var button = self
        button.mode = mode
        return button
    }
}

/// A value that describes the mode of the ``TaskButton``.
///
/// A task button mode defines the running behavior once the button's action is triggered.
public enum TaskButtonMode {
    /// Disables ``TaskButton`` during action
    case disabled
    /// Cancels Task when ``TaskButton`` action is triggered again and stops
    case cancel
    /// Cancels Task when ``TaskButton`` action is triggered again and triggers action again
    case cancelAndRetry
}

struct TaskButton_Previews: PreviewProvider {
    static var previews: some View {
        TaskButton {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } label: { isRunning in
            if isRunning {
                Text("Running...")
            } else {
                Text("Test")
            }
        }
        .previewDisplayName("Default")
        
        TaskButton {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } label: {
            Text("Test")
        } error: { error in
            print(error.localizedDescription)
        }
        .previewDisplayName("Error Callback")
        
        TaskButton {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } label: { isRunning in
            if isRunning {
                Text("Cancel")
            } else {
                Text("Test")
            }
        }
        .taskButtonMode(.cancel)
        .previewDisplayName("Cancel")
        
        TaskButton {
            try await Task.sleep(nanoseconds: 5_000_000_000)
        } label: { isRunning in
            if isRunning {
                Text("Cancel")
            } else {
                Text("Test")
            }
        } error: { error in
            print(error.localizedDescription)
        }
        .taskButtonMode(.cancelAndRetry)
        .previewDisplayName("Cancel and Retry")
    }
}
