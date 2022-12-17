//
//  Date+Extensions.swift
//  Utils/Appearance
//
//  Created by David Walter on 17.12.22.
//

import Foundation

extension Date {
    static var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    var secondsSinceMidnight: TimeInterval {
        floor(self.timeIntervalSince(Calendar.current.startOfDay(for: self)))
    }
}
