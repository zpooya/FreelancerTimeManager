//
//  ProjectViewModel.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

class ProjectViewModel {
    // MARK: - variables fot ProjectTableView  -
    var project: ProjectModel
    var title: String? {
        return self.project.title
    }
    var customerName: String? {
        return self.project.customerName
    }
    var id: Int? {
        return self.project.id
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
    
    // MARK: - additional variables for Project Detail  -
    var desc: String? {
        return self.project.desc
    }
    var customerMobile: String? {
        return self.project.customerMobile
    }
    var customerEmail: String? {
        return self.project.customerEmail
    }
    
    // MARK: - timesForProjectDetail  -
    var timesForProjectDetail: [ProjectDetailTimeViewModel] {
        var times: [ProjectDetailTimeViewModel] = []
        for time in self.project.times ?? [] {
            let timeForProjectDetail = ProjectDetailTimeViewModel(time: time)
            times.append(timeForProjectDetail)
        }
        /// soriting array according to date
        times = times.sorted(){
            (obj1, obj2) in
            let date1 = obj1.dateToShow?.date
            let date2 = obj2.dateToShow?.date
            return date1! < date2!
        }
        return times
    }
    
    // MARK: - timesForTimeDetail  -
    var timesForTimeDetail: [TimeViewModel] {
        var times: [TimeViewModel] = []
        for time in self.project.times ?? [] {
            let timeForTimeDetail = TimeViewModel(time: time)
            times.append(timeForTimeDetail)
        }
        return times
    }
    // MARK: - init  -
    init(project: ProjectModel) {
        self.project = project
    }
}
