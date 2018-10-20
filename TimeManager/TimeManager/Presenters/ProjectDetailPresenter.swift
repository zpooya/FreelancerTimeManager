//
//  ProjectDetailPresenter.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

protocol ProjectDetailPresenterDelegate: class {
    func handleEmptyProjects()
    func setProject(projectViewMode: ProjectViewModel)
    func timeDeletedShowMessage(title: String, message: String)
}

protocol ProjectDetailPresenterProtocol {
    func getProject(projectId: Int)
    func deleteTime(timeId: Int, projectId: Int)
    func goToAddTime(controller: ProjectDetailViewController, timeViewModel: TimeViewModel?, projectId: Int)
    func gotoAddProject(controller: ProjectDetailViewController, projectViewModel: ProjectViewModel?)

}
class ProjectDetailPresenter {
    // MARK: - Constant Variables  -
    let timeSuccessfullyDeleted = "Time Successfully Deleted"
    let successTitle = "Success"
    let timeDeletingFailed = "Time Deleting Failed"
    let failedTitle = "Error"

    // MARK: - private variables  -
    private weak var delegate: ProjectDetailPresenterDelegate?
    private var dataManager = DataManager()
    
    // MARK: - init  -
    init(delegate: ProjectDetailPresenterDelegate) {
        self.delegate = delegate
    }
}
extension ProjectDetailPresenter: ProjectDetailPresenterProtocol {
    func getProject(projectId: Int) {
       let projectModel = self.dataManager.getProject(withId: projectId)
        
        if let projectModel = projectModel {
            let projectViewModel: ProjectViewModel = self.makeProjectViewModel(projectModel: projectModel)
            self.delegate?.setProject(projectViewMode: projectViewModel)

        } else {
            self.delegate?.handleEmptyProjects()
        }
    
    }
    
    func deleteTime(timeId: Int, projectId: Int) {
        let success = self.dataManager.deleteTime(projectId: projectId, timeId: timeId)
        if success {
            self.delegate?.timeDeletedShowMessage(title: self.successTitle, message:self.timeSuccessfullyDeleted )
        } else {
            self.delegate?.timeDeletedShowMessage(title: self.failedTitle, message: self.timeDeletingFailed)
        }
    }
    
    func goToAddTime(controller: ProjectDetailViewController, timeViewModel: TimeViewModel?, projectId: Int) {
        let addTimeViewController = ProjectConfigurator.createAddTimeViewController(withData: timeViewModel, projectId: projectId)
        controller.present(addTimeViewController, animated: true, completion: nil)
    }
    
    func gotoAddProject(controller: ProjectDetailViewController, projectViewModel: ProjectViewModel?) {
        let addProjectViewController = ProjectConfigurator.createAddProjectViewController(withData: projectViewModel)
        controller.present(addProjectViewController, animated: true, completion: nil)
    }
    
    
}
extension ProjectDetailPresenter {
    private func makeProjectViewModel(projectModel: ProjectModel) -> ProjectViewModel {
        let projectViewModel = ProjectViewModel(project: projectModel)
        return projectViewModel
    }
}
