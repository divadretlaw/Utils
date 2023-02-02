//
//  TaskButton.swift
//  Utils/TaskButton
//
//  Created by David Walter on 21.01.23.
//

import SwiftUI

public struct TaskButton<Label>: View  where Label: View {
    var role: ButtonRole?
    var action: @Sendable () async throws -> Void
    var label: (Bool) -> Label
    var error: ((Error) -> Void)?
    var onStateChanged: ((_ isRunning: Bool) -> Void)?
    
    @State private var isRunning = false
    @State private var task: Task<(), Never>?
    
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
    
    public init(
        role: ButtonRole? = nil,
        action: @MainActor @Sendable @escaping () async throws -> Void,
        @ViewBuilder label: @escaping (_ isRunning: Bool) -> Label,
        error: ((Error) -> Void)? = nil
    ) {
        self.role = role
        self.action = action
        self.label = label
        self.error = error
    }
    
    public var body: some View {
        Button(role: role) {
            self.isRunning = true
            self.task = Task {
                do {
                    try await action()
                } catch {
                    self.error?(error)
                }
                self.isRunning = false
            }
        } label: {
            label(isRunning)
        }
        .animation(.default, value: isRunning)
        .disabled(isRunning)
        .onDisappear {
            task?.cancel()
        }
    }
}

struct TaskButton_Previews: PreviewProvider {
    static var previews: some View {
        TaskButton {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        } label: {
            Text("Test")
        } error: { error in
            print(error.localizedDescription)
        }
        
        TaskButton {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        } label: { isRunning in
            if isRunning {
                Text("Running...")
            } else {
                Text("Test")
            }
        }
    }
}
