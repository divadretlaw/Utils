//
//  LicensePlist.swift
//  Utils/LicensePlist
//
//  Created by David Walter on 13.02.22.
//

import Foundation

/// Parsed License Plist file
public struct LicensePlist: Hashable {
    /// Possible parsing errors
    public enum Error: Swift.Error {
        /// No settings bundle was found
        case noSettingsBundle
        /// No `LicensePlist` file was found
        case noLicensePlist
        /// The `LicensePlist` file had an invalid format
        case invalidFormat
    }
    
    /// An entry in the License Plist file
    public struct Entry: Identifiable, Hashable {
        /// Unique identifier of the entry
        public let id: UUID
        /// Title of the entry
        public let title: String
        /// The license text
        public let license: String
        /// Type of the license
        public let licenseType: LicenseType?
        /// The source of the entry/license
        public var source: String?
        
        /// Initialize an entry in the License Plist file
        /// - Parameters:
        ///   - title: The title of the entry.
        ///   - url: The url of the details of the entry.
        public init?(title: String, url: URL) {
            self.id = UUID()
            self.title = title
            
            do {
                let dictionary = try NSDictionary(contentsOf: url, error: ())
                guard let array = dictionary["PreferenceSpecifiers"] as? NSArray, let license = array.lastObject as? NSDictionary else {
                    return nil
                }
                
                guard let string = license["FooterText"] as? String else {
                    return nil
                }
                
                self.license = string
                
                if let string = license["License"] as? String {
                    self.licenseType = LicenseType(rawValue: string)
                } else {
                    self.licenseType = nil
                }
                
                for element in array {
                    if let dict = element as? NSDictionary {
                        if let source = dict["DefaultValue"] as? String {
                            self.source = source
                        }
                    }
                }
            } catch {
                return nil
            }
        }
        
        /// Initialize an entry in the License Plist file
        /// - Parameters:
        ///   - title: The title of the entry.
        ///   - license: The license of the entry.
        ///   - licenseType: The ``LicenseType`` of the entry.
        ///   - source: The source of the entry.
        public init(title: String, license: String, licenseType: LicenseType? = nil, source: String? = nil) {
            self.id = UUID()
            self.title = title
            self.license = license
            self.licenseType = licenseType
            self.source = source
        }
    }
    
    public let entries: [Entry]
    
    /// Parse a ``LicensePlist`` from the given settings bundle
    ///
    /// - Parameters:
    ///   - filename: The file containg the license plist entries.
    ///   - settingsBundle: Path to the settings bundle.
    public init(filename: String, settingsBundle: URL? = Bundle.main.url(forResource: "Settings", withExtension: "bundle")) throws {
        guard let settingsURL = settingsBundle else {
            throw Error.noSettingsBundle
        }
        
        let licensesURL = settingsURL.appendingPathComponent(filename).appendingPathExtension("plist")
        guard FileManager.default.fileExists(atPath: licensesURL.path) else {
            throw Error.noLicensePlist
        }
        
        let dictionary = try NSDictionary(contentsOf: licensesURL, error: ())
        
        guard let licenses = dictionary["PreferenceSpecifiers"] as? NSArray else {
            throw Error.invalidFormat
        }
        
        self.entries = licenses.compactMap { entry -> Entry? in
            guard let dict = entry as? NSDictionary,
                  let title = dict["Title"] as? String,
                  let file = dict["File"] as? String else { return nil }
            
            return Entry(title: title, url: settingsURL.appendingPathComponent(file).appendingPathExtension("plist"))
        }
    }
    
    /// Initialize ``LicensePlist`` from the given entries.
    ///
    /// - Parameter entries: The entries of the license plist
    public init(entries: [Entry]) {
        self.entries = entries
    }
}
