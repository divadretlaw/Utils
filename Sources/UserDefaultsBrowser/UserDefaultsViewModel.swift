//
//  UserDefaultsViewModel.swift
//  Utils/UserDefaultsBrowser
//
//  Created by David Walter on 05.02.21.
//

import Foundation

class UserDefaultsViewModel: ObservableObject, Identifiable {
    @Published var entries: [UserDefaultsEntry] = []
    
    var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadAllUserDefaults() {
        entries = userDefaults
            .dictionaryRepresentation()
            .map { UserDefaultsEntry(key: $0, value: $1) }
            .sorted(by: <)
    }
    
    func delete(entry: UserDefaultsEntry) {
        userDefaults.removeObject(forKey: entry.key)
    }
    
    func deleteRows(at offsets: IndexSet) {
        offsets.forEach { userDefaults.removeObject(forKey: entries.remove(at: $0).key) }
    }
}
