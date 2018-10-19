//
//  TimeModel.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

class TimeModel {
    var id: Int?
    var date: String?
    var hourSpent: Int?
    var minuteSpent: Int?
    init(id: Int?, date: String?, hourSpent: Int, minuteSpent: Int) {
        self.id = id
        self.date = date
        self.hourSpent = hourSpent
        self.minuteSpent = minuteSpent
    }
}
