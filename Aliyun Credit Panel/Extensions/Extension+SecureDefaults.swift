//
//  Extension+SecureDefaults.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import Foundation
import SecureDefaults

public extension SecureDefaults {
    
    /// Function that returns secure defaults obkect
    static func defaults() -> SecureDefaults {
        // Init secure defaults object
        let defaults: SecureDefaults = SecureDefaults.shared
        if !defaults.isKeyCreated {
            defaults.password = UUID().uuidString
        }
        return defaults
    }
    
}
