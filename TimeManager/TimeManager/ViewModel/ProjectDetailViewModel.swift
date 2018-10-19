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
    var description: String? {
        return self.project.description
    }
    var customerName: String? {
        return self.project.customer?.name
    }
    var customerMobile: String? {
        return self.project.customer?.mobile
    }
    var customerEmail: String? {
        return self.project.customer?.email
    }
    
    init(project: ProjectModel) {
        self.project = project
    }
}
