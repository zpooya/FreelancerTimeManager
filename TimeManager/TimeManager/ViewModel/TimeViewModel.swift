//
//  TimeViewModel.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

class TimeViewModel {
    var time: TimeModel
    var id: Int? {
        return time.id
    }
    var dateToShow: Date? {
        return time.date?.date
    }
    var timeToShow: Date? {
        return Date().setTime(hour: time.hourSpent ?? 0, min: time.minuteSpent ?? 0)
    }
    // MARK: - init  -
    init(time: TimeModel) {
        self.time = time
    }
}
