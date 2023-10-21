//
//  AppearanceSettingsView.swift
//  Utils/AppearanceUI
//
//  Created by David Walter on 17.12.22.
//

#if canImport(UIKit)
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
                        HStack(spacing: 10) {
                            if mode.isDynamic {
                                mode.icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .blackAndWhite()
                            } else {
                                mode.icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.secondary)
                                    .padding(5)
                                    .background {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(Color(uiColor: .systemGroupedBackground))
                                        }
                                    }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(mode.localized)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text(mode.localizedHint)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
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
                        HStack(spacing: 10) {
                            Image(systemName: "textformat.size")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                                .padding(5)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(.white)
                                    }
                                }
                            
                            Text("appearance.mode.manual.light".localized())
                        }
                        .tag(UIUserInterfaceStyle.light)
                        HStack(spacing: 10) {
                            Image(systemName: "textformat.size")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .padding(5)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(.black)
                                    }
                                }
                            
                            Text("appearance.mode.manual.dark".localized())
                        }
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
            
            #if !targetEnvironment(macCatalyst)
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
            #endif
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
        #if !targetEnvironment(macCatalyst)
        case .brightness:
            return "appearance.mode.brightness"
        #endif
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
        #if !targetEnvironment(macCatalyst)
        case .brightness:
            return "appearance.mode.brightness.hint"
        #endif
        }
    }
    
    var localizedHint: String {
        localizedHintKey.localized()
    }
    
    var icon: Image {
        switch self {
        case .scheduled:
            return Image(systemName: "clock")
        #if !targetEnvironment(macCatalyst)
        case .brightness:
            return Image(systemName: "sun.max")
        #endif
        default:
            return Image(systemName: "textformat.size")
        }
    }
    
    var isDynamic: Bool {
        switch self {
        case .system:
            return false
        case .manual:
            return true
        case .scheduled:
            return true
        #if !targetEnvironment(macCatalyst)
        case .brightness:
            return true
        #endif
        }
    }
}

struct AppearanceManager_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppearanceSettingsView(manager: AppearanceManager())
                .navigationTitle("Appearance")
        }
    }
}
#endif
