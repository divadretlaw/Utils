//
//  UserDefaultsBrowser.swift
//  Utils/UserDefaultsBrowser
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI

public struct UserDefaultsBrowser: View {
    private var userDefaults: UserDefaults
    @State private var entries: [UserDefaultsEntry] = []
    
    @Namespace private var listId
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public var body: some View {
        List {
            ForEach(entries) { entry in
                row(for: entry)
                    .matchedGeometryEffect(id: entry.id, in: listId)
                    .contextMenu {
                        Button(role: .destructive) {
                            delete(entry: entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .coordinateSpace(name: listId)
        .listStyle(.insetGrouped)
        .navigationTitle("UserDefaults")
        .animation(.default, value: entries)
        .task {
            await loadAllUserDefaults()
            
            for await _ in NotificationCenter.default.notifications(named: UserDefaults.didChangeNotification).map({ $0.name }) {
                await loadAllUserDefaults()
            }
        }
    }
    
    @MainActor
    func loadAllUserDefaults() async {
        let task = Task.detached {
            try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
            return userDefaults
                .dictionaryRepresentation()
                .map { UserDefaultsEntry(key: $0, value: $1) }
                .sorted(by: <)
        }
        let entries = await task.value
        withAnimation {
            self.entries = entries
        }
    }
    
    func delete(entry: UserDefaultsEntry) {
        userDefaults.removeObject(forKey: entry.key)
    }
    
    func deleteRows(at offsets: IndexSet) {
        offsets.forEach { userDefaults.removeObject(forKey: entries.remove(at: $0).key) }
    }
    
    @ViewBuilder
    func row(for entry: UserDefaultsEntry) -> some View {
        if entry.isSimpleType {
            rowContent(for: entry)
        } else {
            NavigationLink {
                UserDefaultsEntryView(entry: entry, userDefaults: userDefaults)
            } label: {
                rowContent(for: entry)
            }
        }
    }
    
    @ViewBuilder
    func rowContent(for entry: UserDefaultsEntry) -> some View {
        if #available(iOS 16.0, *) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    Text(entry.key)
                    Spacer()
                    Text(entry.valueDescription)
                        .font(.system(.body, design: .monospaced))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text(entry.key)
                    Text(entry.valueDescription)
                        .font(.system(.body, design: .monospaced))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
                }
            }
        } else {
            HStack {
                Text(entry.key)
                Spacer()
                Text(String(reflecting: entry.value))
                    .font(.system(.body, design: .monospaced))
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct UserDefaultsBrowser_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDefaultsBrowser()
        }
    }
}
