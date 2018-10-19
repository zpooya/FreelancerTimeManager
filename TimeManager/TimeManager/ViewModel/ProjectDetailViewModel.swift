//
//  ProjectDetailViewModel.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

class ProjectDetailViewModel {
    var project: ProjectModel
    
    var title: String? {
        return self.project.title
    }
    var desc: String? {
        return self.project.desc
    }
    var customerName: String? {
        return self.project.customerName
    }
    var customerMobile: String? {
        return self.project.customerMobile
    }
    var customerEmail: String? {
        return self.project.customerEmail
    }
    
    init(project: ProjectModel) {
        self.project = project
    }
}
