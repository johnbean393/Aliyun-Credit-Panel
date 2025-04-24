//
//  Settings.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import Foundation
import SecureDefaults

public class Settings {
    
    /// A `String` for the user's Aliyun console access endpoint URL
    public static var endpoint: String {
        get {
            guard let endpoint = UserDefaults.standard.string(
                forKey: "endpoint"
            ) else {
                return "business.aliyuncs.com"
            }
            return endpoint
        }
        set {
            // Save
            UserDefaults.standard.set(newValue, forKey: "endpoint")
        }
    }
    
    /// A `String` for the user's Aliyun console access key ID
    public static var accessKeyId: String {
        set {
            let defaults: SecureDefaults = SecureDefaults.defaults()
            defaults.set(newValue, forKey: "accessKeyId")
        }
        get {
            let defaults: SecureDefaults = SecureDefaults.defaults()
            return defaults.string(forKey: "accessKeyId") ?? ""
        }
    }
    
    /// A `String` for the user's Aliyun secret console access key
    public static var accessKeySecret: String {
        set {
            let defaults: SecureDefaults = SecureDefaults.defaults()
            defaults.set(newValue, forKey: "accessKeySecret")
        }
        get {
            let defaults: SecureDefaults = SecureDefaults.defaults()
            return defaults.string(forKey: "accessKeySecret") ?? ""
        }
    }
    
    /// The refresh interval at which credit data is retrieved
    static var refreshInterval: Int {
        get {
            // Default to 15 minutes
            if !UserDefaults.standard.exists(key: "refreshInterval") {
                Self.refreshInterval = 1
            }
            return UserDefaults.standard.integer(
                forKey: "refreshInterval"
            )
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refreshInterval")
        }
    }
    
    /// Possible refresh intervals for credit data
    public enum RefreshInterval: Int, CaseIterable {
        
        case minutes1 = 0
        case minites15 = 1
        case minites30 = 2
        case hours1 = 3
        
        static var interval: Self? {
            return Self.init(rawValue: Settings.refreshInterval)
        }
        
        var description: String {
            switch self {
                case .minutes1:
                    return "1 minute"
                case .minites15:
                    return "15 minutes"
                case .minites30:
                    return "30 minutes"
                case .hours1:
                    return "1 hour"
            }
        }
        
        var seconds: Double {
            switch self {
                case .minutes1:
                    return 60
                case .minites15:
                    return 900
                case .minites30:
                    return 1800
                case .hours1:
                    return 3600
            }
        }
        
    }
    
}
