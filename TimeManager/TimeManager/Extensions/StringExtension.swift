//
//  StringExtension.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMM dd, yyy"
        return dateFormatter.date(from: self)
    }
}
