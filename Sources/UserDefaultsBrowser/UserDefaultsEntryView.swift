//
//  UserDefaultsEntryView.swift
//  Utils/UserDefaultsBrowser
//
//  Created by David Walter on 05.02.21.
//

import SwiftUI

struct UserDefaultsEntryView: View {
    @Environment(\.dismiss) var dismiss
    
    var entry: UserDefaultsEntry
    var userDefaults: UserDefaults = .standard
    
    @State private var showDeleteConfirmation = false

    var body: some View {
        List {
            formattedData
            rawData
        }
        .listStyle(.insetGrouped)
        .navigationTitle(entry.key)
        .toolbar {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Image(systemName: "trash")
            }
            .foregroundColor(.red)
        }
        .alert("Delete", isPresented: $showDeleteConfirmation) {
            Button(role: .cancel) {
            } label: {
                Text("Cancel")
            }
            
            Button(role: .destructive) {
                userDefaults.removeObject(forKey: entry.key)
                dismiss()
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete '`\(entry.key)`'?")
        }
    }

    var formattedData: some View {
        let mirror: Mirror
        
        if let data = entry.value as? Data, let unarchived = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) {
            mirror = Mirror(reflecting: unarchived)
        } else {
            mirror = Mirror(reflecting: entry.value)
        }
        
        let views = mirror.children.map { child in
            HStack {
                if let label = child.label {
                    Text(label)
                    Spacer()
                }
                
                Text(String(reflecting: unwrap(child.value)))
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
        }
        return ForEach(0 ..< views.count, id: \.self) { views[$0] }
    }

    @ViewBuilder
    var rawData: some View {
        if let data = entry.value as? Data {
            Section {
                HStack {
                    Text(String(describing: format(data)))
                        .frame(alignment: Alignment.trailing)
                        .font(.system(.body, design: .monospaced))
                }
            } header: {
                Text("Raw")
            }
        }
    }
    
    func unwrap<T>(_ any: T) -> Any {
        let mirror = Mirror(reflecting: any)
        guard mirror.displayStyle == .optional, let first = mirror.children.first else {
            return format(any)
        }
        
        return format(first.value)
    }

    func format<T>(_ any: T) -> Any {
        guard let data = any as? Data else {
            return any
        }
        
        if let unarchived = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) {
            return unarchived
        }
        
        return String(data: data, encoding: .utf8) ?? data.map { String(format: "%02hhx", $0) }.joined()
    }
}

struct UserDefaultsEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDefaultsEntryView(entry: UserDefaultsEntry(key: "Key", value: Data("Value".utf8)))
        }
    }
}
