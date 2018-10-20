//
//  DateExtension.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

extension Date {
    /**
     This String returns the String of The Date in the wanted format.
     */
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "MMM dd, yyy"
        
        return dateFormatter.string(from: self)
    }
    
    /**
     This function set the hour and minute and returns a Date type.
     - Parameter hour: hour in Int
     - Parameter min: minute in Int
     - returns: Date? format
     */
    public func setTime(hour: Int, min: Int) -> Date? {
        let calenderComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calender = Calendar.current
        var components = calender.dateComponents(calenderComponents, from: self)
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.hour = hour
        components.minute = min
        return calender.date(from: components)
    }
}
