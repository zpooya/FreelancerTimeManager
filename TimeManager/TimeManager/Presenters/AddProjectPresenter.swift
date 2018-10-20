//
//  AddProjectPresenter.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation
/**
 This protocol is the Delegate of AddProjectPresenter.
 
 ## It has the Following functions ##
 1. **successfullyCreatedOrUpdated**
 2. **failedToCreateOrUpdate**
 3. **setPageTitle**
 */
protocol AddProjectPresenterDelegate: class {
    /// set the message for successfully created or updated
    func successfullyCreatedOrUpdated(title: String, message: String)
    /// set the messafe for failing to create or update
    func failedToCreateOrUpdate(title: String, message: String)
    /// set the page title 
    func setPageTitle(title: String)
}
/**
 This protocol represents the public functions of **AddProjectPresenter** class.
 
 ## It has the Following functions ##
 1. **createProject**
 2. **getPageTitle**
 */
protocol AddProjectPresenterProtocol: class {
    /// has the duty to create project
   func createProject(projectTitle: String, projectDesc: String, customerName: String, customerMobile: String?, customerEmail: String?, projectId: Int?)
    /// has the duty to get the page title
    func getPageTitle(projectId: Int?)
}
class AddProjectPresenter {
    // MARK: - Constant Variables  -
    let successfullyCreated = "Project Successfully Created"
    let successfullyUpdated = "Project Successfully Updated"
    let successTitle = "Success"
    let failedToCreate = "Failed to Create Project"
    let failedToUpdate = "Failed to Update Project"
    let failedTitle = "Error"
    let updateTitle = "Update Project"
    let createTitle = "Create Project"

    // MARK: - private variables  -
    private weak var delegate: AddProjectPresenterDelegate?
    private var dataManager = DataManager()
    
    // MARK: - init  -
    init(delegate: AddProjectPresenterDelegate, dataManager: DataManager) {
        self.delegate = delegate
        self.dataManager = dataManager
    }
}
// MARK: - AddProjectPresenterProtocol  -
extension AddProjectPresenter: AddProjectPresenterProtocol {
    /**
     This method is called from view to get the page title .
     - Parameter projectId: if it is not null then the title is update else it is create 
     */
    func getPageTitle(projectId: Int?) {
        if projectId != nil {
            self.delegate?.setPageTitle(title: self.updateTitle)
        } else {
            self.delegate?.setPageTitle(title: self.createTitle)
        }
    }
    /**
     This method is called from view to add the project to CoreData
     */
    func createProject(projectTitle: String, projectDesc: String, customerName: String, customerMobile: String?, customerEmail: String?, projectId: Int?) {
        
        let projectModel = self.createProjectModel(projectTitle: projectTitle, projectDesc: projectDesc, customerName: customerName, customerMobile: customerMobile, customerEmail: customerEmail, projectId: projectId)
        if projectId != nil {
            let projectUpdated = self.updateProject(projectModel: projectModel)
            if projectUpdated {
                self.delegate?.successfullyCreatedOrUpdated(title: successTitle, message: successfullyUpdated)
            } else {
                self.delegate?.failedToCreateOrUpdate(title: failedTitle, message: failedToUpdate)
            }
        } else {
            let projectCreated = self.createProject(projectModel: projectModel)
            if projectCreated {
                self.delegate?.successfullyCreatedOrUpdated(title: successTitle, message: successfullyCreated)
            } else {
                self.delegate?.failedToCreateOrUpdate(title: failedTitle, message: failedToCreate)
            }
        }
    }
}
// MARK: -  connecting to DataManager  -
extension AddProjectPresenter {
    private func createProject(projectModel: ProjectModel) -> Bool {
        return self.dataManager.addProject(project: projectModel)
    }
    private func updateProject(projectModel: ProjectModel) -> Bool {
        return self.dataManager.editProject(project: projectModel)
    }
    
}
// MARK: - helper function -
extension AddProjectPresenter {
    /**
     This method makes the **ProjectModel*** to be given to DataManager.
     */
    private func createProjectModel(projectTitle: String, projectDesc: String, customerName: String, customerMobile: String?, customerEmail: String?, projectId: Int?) -> ProjectModel {
        let projectModel = ProjectModel(id: projectId, title: projectTitle, desc: projectDesc, times: nil, customerName: customerName, customerMobile: customerMobile, customerEmail: customerEmail)
        return projectModel
        
    }
}
