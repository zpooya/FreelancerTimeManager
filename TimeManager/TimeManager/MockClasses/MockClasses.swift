//
//  MockClasses.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation
/// This is a mock DataManager used to test the projectsPresenter
class DataManagerMock: DataManager {
    private let projectsModel: [ProjectModel]
    
    init(projectsModel: [ProjectModel]) {
        self.projectsModel = projectsModel
    }
    
    override func getProjects() -> [ProjectModel]? {
        return self.projectsModel
    }
    
    override func deleteProject(withId id: Int) -> Bool {
        return true
    }
}
/// This is a mock ProjectsViewController used to test the projectsPresenter
class ProjectsViewControllerMock: ProjectsPresenterDelegate {
    var setProjectsCalled = false
    var handleEmptyProjectsCalled = false
    var projectDeletedCalled = false
    var oneProjectIdToDelete: Int?
    func handleEmptyProjects() {
        self.handleEmptyProjectsCalled = true
    }
    func setProjects(projectsViewModel: [ProjectViewModel]) {
        self.setProjectsCalled = true

    }
    func projectDeletedShowMessage(title: String, message: String) {
        projectDeletedCalled = true
    }
    func handleViewWithProjects() {
        
    }
}
