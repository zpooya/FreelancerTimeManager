//
//  ProjectDetailPresenter.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation
/**
 This protocol is the Delegate of ProjectDetailPresenter.
 
 ## It has the Following functions ##
 1. **handleEmptyProject**
 2. **setProject**
 3. **timeDeletedShowMessage**
 */
protocol ProjectDetailPresenterDelegate: class {
    /// notifies the view tho handle empty project
    func handleEmptyProject()
    /// set the projectViewModel of the view
    func setProject(projectViewMode: ProjectViewModel)
    /// send the message for deleting time
    func timeDeletedShowMessage(title: String, message: String)
}
/**
 This protocol represents the public functions of **ProjectDetailPresenter** class.
 
 ## It has the Following functions ##
 1. **getProject**
 2. **deleteTime**
 3. **goToAddTime**
 4. **gotoAddProject**
 
 */
protocol ProjectDetailPresenterProtocol {
    /// has the duty to get the project
    func getProject(projectId: Int)
    /// has the duty to delete time
    func deleteTime(timeId: Int, projectId: Int)
    /// has the duty to navigate to AddTimeViewController
    func goToAddTime(controller: ProjectDetailViewController, projectDetailTimeViewModel: ProjectDetailTimeViewModel?, projectViewModel: ProjectViewModel?)
    /// has the duty to navigate to AddProjectViewController
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
// MARK: - ProjectDetailPresenterProtocol  -
extension ProjectDetailPresenter: ProjectDetailPresenterProtocol {
    /**
     This method is called from view to get the **projectModel** from CoreData and making the **projectViewModel** to send to view.
     - Parameter projectId: the id which is used for fetching its refrence from CoreData
     */
    func getProject(projectId: Int) {
       let projectModel = self.dataManager.getProject(withId: projectId)
        
        if let projectModel = projectModel {
            let projectViewModel: ProjectViewModel = self.makeProjectViewModel(projectModel: projectModel)
            self.delegate?.setProject(projectViewMode: projectViewModel)

        } else {
            self.delegate?.handleEmptyProject()
        }
    
    }
    /**
     This method is called from view to delete the **time** with id **timeId**.
     - Parameter projectId: the projectId which this time is assigned to.
     - Parameter timeId: the id which belongs to the time
     */
    func deleteTime(timeId: Int, projectId: Int) {
        let success = self.dataManager.deleteTime(projectId: projectId, timeId: timeId)
        if success {
            self.delegate?.timeDeletedShowMessage(title: self.successTitle, message:self.timeSuccessfullyDeleted )
        } else {
            self.delegate?.timeDeletedShowMessage(title: self.failedTitle, message: self.timeDeletingFailed)
        }
    }
    /**
     This method is called from view to navigate to **AddTimeViewController**.
     - Parameter controller: the viewController which is of kind **ProjectDetailViewController** and is responsible of presenting the instance of **AddTimeViewController**.
     - Parameter projectDetailTimeViewModel: the data needed to get the timeVieModel which is used to call the **createAddTimeViewController** method of **ProjectConfigurator** and make the instance of **AddTimeViewController**.
     - Parameter projectId: which is needed to be given to the *createAddTimeViewController* method
     */
    func goToAddTime(controller: ProjectDetailViewController, projectDetailTimeViewModel: ProjectDetailTimeViewModel?, projectViewModel: ProjectViewModel?) {
        var selectedTimeViewModel: TimeViewModel?
            
        for time in projectViewModel?.timesForTimeDetail ?? [] where time.id == projectDetailTimeViewModel?.id {
            selectedTimeViewModel = time
        }
        guard let projectId = projectViewModel?.id else {
            return
        }
        let addTimeViewController = ProjectConfigurator.createAddTimeViewController(withData: selectedTimeViewModel, projectId: projectId)
        controller.present(addTimeViewController, animated: true, completion: nil)
    }
    /**
     This method is called from view to navigate to **AddProjectViewController**.
     - Parameter controller: the viewController which is of kind **ProjectDetailViewController** and is responsible of presenting the instance of **AddProjectViewController**.
     - Parameter projectViewModel: the initial data needed to call the **createAddProjectViewController** method of **ProjectConfigurator** and make the instance of **AddProjectViewController**.
     */
    func gotoAddProject(controller: ProjectDetailViewController, projectViewModel: ProjectViewModel?) {
        let addProjectViewController = ProjectConfigurator.createAddProjectViewController(withData: projectViewModel)
        controller.present(addProjectViewController, animated: true, completion: nil)
    }
}
// MARK: - helper function  -
extension ProjectDetailPresenter {
    /**
     This method makes the **ProjectViewModel***.
     
     - Parameter projectModel: an array of original model fetched from CoreData.
     - returns: ProjectViewModel to be given to view.
     */
    private func makeProjectViewModel(projectModel: ProjectModel) -> ProjectViewModel {
        let projectViewModel = ProjectViewModel(project: projectModel)
        return projectViewModel
    }
}
