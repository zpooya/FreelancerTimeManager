//
//  ProjectsPresenter.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

/**
 This protocol is the Delegate of ProjectsPresenter.
 
 ## It has the Following functions ##
 1. **handleViewWithProjects**
 2. **handleEmptyProjects**
 3. **setProjects**
 4. **projectDeletedShowMessage**
 */
protocol ProjectsPresenterDelegate: class {
    /// notify view to handle view with projects
    func handleViewWithProjects()
    /// notify the view to handle view with no projects
    func handleEmptyProjects()
    /// set the projectsViewModel of the view
    func setProjects(projectsViewModel: [ProjectViewModel])
    /// send the message for deleting project
    func projectDeletedShowMessage(title: String, message: String)
}
/**
 This protocol represents the public functions of **ProjectsPresenterProtocol** class.

 ## It has the Following functions ##
 1. **getProjects**
 2. **deleteProject**
 3. **gotoAddProject**
 4. **goToAddTime**
 5. **goToProjectDetail**

 */
protocol ProjectsPresenterProtocol: class {
    /// has the duty to get all the projects
    func getProjects()
    /// has the duty to delete projects
    func deleteProject(projectId: Int)
    /// has the duty to navigate to AddProjectViewController
    func gotoAddProject(controller: ProjectsViewController, projectViewModel: ProjectViewModel?)
    /// has the duty to navigate to AddTimeViewController
    func goToAddTime(controller: ProjectsViewController, timeViewModel: TimeViewModel?, projectId: Int)
    /// has the duty to navigate to ProjectDetailViewController
    func goToProjectDetail(controller: ProjectsViewController, projectViewModel: ProjectViewModel)
}
class ProjectsPresenter {
    // MARK: - Constant Variables  -
    let projectSuccessfullyDeleted = "Project Successfully Deleted"
    let successTitle = "Success"
    let projectDeletingFailed = "Project Deleting Failed"
    let failedTitle = "Error"

    // MARK: - private variables  -
    private weak var delegate: ProjectsPresenterDelegate?
    private var dataManager = DataManager()
    
    // MARK: - init  -
    init(delegate: ProjectsPresenterDelegate, dataManager: DataManager) {
        self.delegate = delegate
        self.dataManager = dataManager
    }
}
// MARK: - ProjectsPresenterProtocol  -
extension ProjectsPresenter: ProjectsPresenterProtocol {
    /**
     This method is called from view to get the **ProjectsModel** from CoreData and making the **projectsViewModel** to send to view.
     */
    func getProjects() {
        let projectsModel: [ProjectModel] = self.dataManager.getProjects() ?? []
        if projectsModel.count > 0 {
            let projectsViewModel: [ProjectViewModel] = self.makeProjectsViewModel(projectsModel: projectsModel)
            self.delegate?.handleViewWithProjects()
            self.delegate?.setProjects(projectsViewModel: projectsViewModel)
        } else {
            self.delegate?.handleEmptyProjects()
        }
       
    }
    /**
     This method is called from view to delete the **Project** with id **projectId**.
     - Parameter projectId: the projectId which is used for deleting its refrence from CoreData
     */
    func deleteProject(projectId: Int) {
       let success = self.dataManager.deleteProject(withId: projectId)
        if success {
            self.delegate?.projectDeletedShowMessage(title: self.successTitle, message: self.projectSuccessfullyDeleted)
        } else {
            self.delegate?.projectDeletedShowMessage(title: self.failedTitle, message: self.projectDeletingFailed)
        }
    }
    /**
     This method is called from view to navigate to **AddProjectViewController**.
     - Parameter controller: the viewController which is of kind **ProjectsViewController** and is responsible of presenting the instance of **AddProjectViewController**.
     - Parameter projectViewModel: the initial data needed to call the **createAddProjectViewController** method of **ProjectConfigurator** and make the instance of **AddProjectViewController**.
     */
    func gotoAddProject(controller: ProjectsViewController, projectViewModel: ProjectViewModel?) {
        let addProjectViewController = ProjectConfigurator.createAddProjectViewController(withData: projectViewModel)
        controller.present(addProjectViewController, animated: true, completion: nil)
    }
    /**
     This method is called from view to navigate to **AddTimeViewController**.
     - Parameter controller: the viewController which is of kind **ProjectsViewController** and is responsible of presenting the instance of **AddTimeViewController**.
     - Parameter timeViewModel: the initial data needed to call the **createAddTimeViewController** method of **ProjectConfigurator** and make the instance of **AddTimeViewController**.
     - Parameter projectId: which is needed to be given to the *createAddTimeViewController* method
     */
    func goToAddTime(controller: ProjectsViewController, timeViewModel: TimeViewModel?, projectId: Int) {
        let addTimeViewController = ProjectConfigurator.createAddTimeViewController(withData: timeViewModel, projectId: projectId)
        controller.present(addTimeViewController, animated: true, completion: nil)
    }
    /**
     This method is called from view to navigate to **ProjectDetailViewController**.
     - Parameter controller: the viewController which is of kind **ProjectsViewController** and is responsible of pushing the instance of **ProjectDetailViewController**.
     - Parameter projectViewModel: the initial data needed to call the **createProjectDetailViewController** method of **ProjectConfigurator** and make the instance of **ProjectDetailViewController**.
     */
    func goToProjectDetail(controller: ProjectsViewController, projectViewModel: ProjectViewModel) {
        let projectDetailViewController = ProjectConfigurator.createProjectDetailViewController(withData: projectViewModel)
        controller.navigationController?.pushViewController(projectDetailViewController, animated: true)
    }
   
}


// MARK: - Private Functions  -
extension ProjectsPresenter {
    /**
     This method makes the **[ProjectViewModel]***.
     
     - Parameter projectsModel: an array of original model fetched from CoreData.
     - returns: [ProjectViewModel] an array of **ProjectViewModel** to be given to view.
     */
    private func makeProjectsViewModel(projectsModel: [ProjectModel]) -> [ProjectViewModel] {
        var projectsViewModel:[ProjectViewModel] = []
        for projectModel in projectsModel {
            let projectViewModel = ProjectViewModel(project: projectModel)
            projectsViewModel.append(projectViewModel)
        }
        return projectsViewModel
    }
}
