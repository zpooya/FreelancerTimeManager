//
//  ProjectModel.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation
/**
 Model recieved from and is used to save Data to **CoreData**.
 
 ## Important Notes ##
 1. Has an array of **times** which is of kinde **TimeModel**.
 2. **ProjectModel** is used to make the **ProjectViewModel**.
 */
class ProjectModel {
    var id: Int?
    var title: String?
    var desc: String?
    var times: [TimeModel]?
    var customerName: String?
    var customerMobile: String?
    var customerEmail: String?
    
    init(id: Int?, title: String?, desc: String?, times: [TimeModel]?, customerName: String?, customerMobile: String?, customerEmail: String?) {
        self.id = id
        self.title = title
        self.desc = desc
        self.times = times
        self.customerName = customerName
        self.customerMobile = customerMobile
        self.customerEmail = customerEmail
    }
}

