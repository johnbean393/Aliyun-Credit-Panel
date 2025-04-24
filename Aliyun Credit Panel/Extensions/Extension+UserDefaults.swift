//
//  Extension+UserDefaults.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import Foundation

public extension UserDefaults {
    
    /// Function to check if a key exists
    func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}
