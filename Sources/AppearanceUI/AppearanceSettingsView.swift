//
//  AppearanceSettingsView.swift
//  Utils/AppearanceUI
//
//  Created by David Walter on 17.12.22.
//

import SwiftUI
import Appearance

public struct AppearanceSettingsView: View {
    @ObservedObject var manager: AppearanceManager
    
    public init(manager: AppearanceManager) {
        self.manager = manager
    }
    
    public var body: some View {
        List {
            Section {
                Picker(selection: $manager.mode) {
                    ForEach(AppearanceMode.allCases) { mode in
                        VStack(alignment: .leading) {
                            Text(mode.localized)
                                .font(.body)
                                .foregroundColor(.primary)
                            Text(mode.localizedHint)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .tag(mode)
                    }
                } label: {
                    Text("appearance.mode.title".localized())
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            
            if manager.mode == .manual {
                Section {
                    Picker(selection: $manager.manualUserInterfaceStyle) {
                        Text("appearance.mode.manual.light".localized())
                            .tag(UIUserInterfaceStyle.light)
                        Text("appearance.mode.manual.dark".localized())
                            .tag(UIUserInterfaceStyle.dark)
                    } label: {
                        Text("appearance.mode.manual".localized())
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                } header: {
                    Text("appearance.mode.manual".localized())
                }
            }
            
            if manager.mode == .scheduled {
                Section {
                    DatePicker("appearance.mode.scheduled.light".localized(),
                               selection: $manager.scheduleLight,
                               displayedComponents: .hourAndMinute)
                    DatePicker("appearance.mode.scheduled.dark".localized(),
                               selection: $manager.scheduleDark,
                               displayedComponents: .hourAndMinute)
                } header: {
                    Text("appearance.mode.scheduled".localized())
                }
            }
            
            if manager.mode == .brightness {
                Section {
                    Slider(value: $manager.brightnessThreshold,
                           in: 0 ... 1) {
                        Text("appearance.mode.brightness.slider".localized())
                    } minimumValueLabel: {
                        Image(systemName: "sun.min")
                    } maximumValueLabel: {
                        Image(systemName: "sun.max")
                    } onEditingChanged: { value in
                        guard !value else { return }
                        manager.apply()
                    }
                } header: {
                    Text("appearance.mode.brightness".localized())
                } footer: {
                    Text(String(format: "appearance.mode.brightness.slider.hint".localized(), Int(manager.brightnessThreshold * 100)))
                }
            }
        }
        .animation(.default, value: manager.mode)
        .onAppear {
            manager.apply()
        }
    }
}

extension AppearanceMode {
    private var localizedKey: String {
        switch self {
        case .system:
            return "appearance.mode.system"
        case .manual:
            return "appearance.mode.manual"
        case .scheduled:
            return "appearance.mode.scheduled"
        case .brightness:
            return "appearance.mode.brightness"
        }
    }
    
    var localized: String {
        localizedKey.localized()
    }
    
    private var localizedHintKey: String {
        switch self {
        case .system:
            return "appearance.mode.system.hint"
        case .manual:
            return "appearance.mode.manual.hint"
        case .scheduled:
            return "appearance.mode.scheduled.hint"
        case .brightness:
            return "appearance.mode.brightness.hint"
        }
    }
    
    var localizedHint: String {
        localizedHintKey.localized()
    }
}

struct AppearanceManager_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppearanceSettingsView(manager: AppearanceManager())
        }
    }
}
