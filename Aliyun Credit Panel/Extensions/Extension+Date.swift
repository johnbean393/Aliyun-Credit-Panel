//
//  Extension+Date.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import Foundation

extension Date {
    
    /// Returns a string representing the previous month in "yyyy-MM" format.
    static var lastMonthString: String? {
        let calendar = Calendar.current
        guard let lastMonthDate = calendar.date(
            byAdding: .month,
            value: -1,
            to: Date.now
        ) else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: lastMonthDate)
    }
    
}
