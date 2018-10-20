//
//  AddProjectPresenter.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

protocol AddProjectPresenterDelegate: class {
    func successfullyCreatedOrUpdated(title: String, message: String)
    func failedToCreateOrUpdate(title: String, message: String)
    func setPageTitle(title: String)
}
protocol AddProjectPresenterProtocol: class {
   func createProject(projectTitle: String, projectDesc: String, customerName: String, customerMobile: String?, customerEmail: String?, projectId: Int?)
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
    init(delegate: AddProjectPresenterDelegate) {
        self.delegate = delegate
    }
}

extension AddProjectPresenter: AddProjectPresenterProtocol {
    func getPageTitle(projectId: Int?) {
        if projectId != nil {
            self.delegate?.setPageTitle(title: self.updateTitle)
        } else {
            self.delegate?.setPageTitle(title: self.createTitle)
        }
    }
    
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
// MARK: -  private functions  -
extension AddProjectPresenter {
    private func createProject(projectModel: ProjectModel) -> Bool {
        return self.dataManager.addProject(project: projectModel)
    }
    private func updateProject(projectModel: ProjectModel) -> Bool {
        return self.dataManager.editProject(project: projectModel)
    }
    
}
// MARK: - helper  -
extension AddProjectPresenter {
    private func createProjectModel(projectTitle: String, projectDesc: String, customerName: String, customerMobile: String?, customerEmail: String?, projectId: Int?) -> ProjectModel {
        let projectModel = ProjectModel(id: projectId, title: projectTitle, desc: projectDesc, times: nil, customerName: customerName, customerMobile: customerMobile, customerEmail: customerEmail)
        return projectModel
        
    }
}
