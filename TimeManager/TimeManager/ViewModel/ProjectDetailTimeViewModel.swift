//
//  ProjectDetailTimeViewModel.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation
/**
 **ProjectDetailTimeViewModel** is the ViewModel which is used in **ProjectDetailViewController**.
 */
class ProjectDetailTimeViewModel {
    var time: TimeModel
    var id: Int? {
        return time.id
    }
    var dateToShow: String? {
        return time.date
    }
    var timeToShow: String? {
        var totalTimeSpentString = ""
        let hourSpent = time.hourSpent ?? 0
        let minuteSpent = time.minuteSpent ?? 0
        if hourSpent != 0, minuteSpent != 0 {
            totalTimeSpentString = ("\(hourSpent)" + "hour" + ", " + "\(minuteSpent)" + "minute")
        } else if hourSpent == 0 {
            totalTimeSpentString = "\(minuteSpent)" + "minute"
        } else if minuteSpent == 0 {
            totalTimeSpentString = "\(hourSpent)" + "hour"
        }
        return totalTimeSpentString
    }
    // MARK: - init  -
    init(time: TimeModel) {
        self.time = time
    }
}
