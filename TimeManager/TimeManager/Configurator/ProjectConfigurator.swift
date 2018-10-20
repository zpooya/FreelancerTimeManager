//
//  ProjectConfigurator.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class ProjectConfigurator {
    /**
     This method creats the **ProjectDetailViewController** and set its initial data which is of kind **ProjectViewModel**.
     
     - Parameter data: the initial data for **ProjectDetailViewController** which is of kind **ProjectViewModel**.
     - returns: an istance of **ProjectDetailViewController**.
     */
    static func createProjectDetailViewController(withData data: ProjectViewModel) -> ProjectDetailViewController {
        let projectDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController
        guard let controller = projectDetailViewController else {
            fatalError("could not make ProjectDetailViewController")
        }
        controller.setContent(projectViewModel: data)
        return controller
    }
    
    /**
     This method creats the **AddProjectViewController** and set its initial data which is of kind **ProjectViewModel**.
     
     - Parameter data: the initial data for **AddProjectViewController** which is of kind **ProjectViewModel**.
     - returns: an istance of **AddProjectViewController**.
     */
    static func createAddProjectViewController(withData data: ProjectViewModel?) -> AddProjectViewController {
        let addProjectViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProjectViewController") as? AddProjectViewController
        guard let controller = addProjectViewController else {
            fatalError("could not make AddProjectViewController")
        }
        controller.setContent(projectViewModel: data)
        return controller
    }
    
    /**
     This method creats the **AddTimeViewController** and set its initial data which is of kind **TimeViewModel**.
     
     - Parameter data: the initial data for **AddTimeViewController** which is of kind **TimeViewModel**.
     - returns: an istance of **AddTimeViewController**.
     */
    static func createAddTimeViewController(withData data: TimeViewModel?, projectId: Int) -> AddTimeViewController {
        let addTimeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTimeViewController") as? AddTimeViewController
        guard let controller = addTimeViewController else {
            fatalError("could not make AddTimeViewController")
        }
        controller.setContent(timeViewModel: data, projectId: projectId)
        return controller
    }
}
