//
//  ProjectViewModel.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

class ProjectViewModel {
    var project: ProjectModel
    var title: String? {
        return self.project.title
    }
    var customerName: String? {
        return self.project.customer?.name
    }
    var totalTimeSpent: String? {
        var hoursSpent: Int = 0
        var minuteSpent: Int = 0
        var totalTimeSpentString = ""
        for time in self.project.times ?? [] {
            hoursSpent += (time.hourSpent ?? 0)
            minuteSpent += (time.minuteSpent ?? 0)
        }
        if minuteSpent > 59 {
            hoursSpent += (minuteSpent / 60)
            minuteSpent = (minuteSpent % 60)
        }
    
        if hoursSpent != 0, minuteSpent != 0 {
            totalTimeSpentString = ("\(hoursSpent)" + "hour" + ", " + "\(minuteSpent)" + "minute")
        } else if hoursSpent == 0 {
            totalTimeSpentString = "\(minuteSpent)" + "minute"
        } else if minuteSpent == 0 {
            totalTimeSpentString = "\(hoursSpent)" + "hour"
        }
        
        return totalTimeSpentString
    }
    
    init(project: ProjectModel) {
        self.project = project
    }
}
