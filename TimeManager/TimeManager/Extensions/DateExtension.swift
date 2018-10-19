//
//  DateExtension.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

extension Date {
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMM dd, yyy"
        
        return dateFormatter.string(from: self)
    }
    
    public func setTime(hour: Int, min: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let calenderComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calender = Calendar.current
        var components = calender.dateComponents(calenderComponents, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        return calender.date(from: components)
    }
}
