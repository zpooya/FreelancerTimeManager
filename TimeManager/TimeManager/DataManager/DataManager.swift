//
//  DataManager.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit
import CoreData
/**
 This protocol represents the public functions of **DataManager** class.
 
 ## It has the Following functions ##
 1. **getProjects**
 2. **addProject**
 3. **getProject**
 4. **editProject**
 5. **deleteProject**
 6. **addTimeToProject**
 7. **editTime**
 8. **getTime**
 9. **deleteTime**
 
 ## It has the Following computed variables ##
 1. **appDelegate**
 2. **managedContext**

 */
protocol DataManagerProtocol: class {
    var appDelegate: AppDelegate? {get}
    var managedContext: NSManagedObjectContext? {get}
    /// has the duty to fetch all Projects from the CoreData
    func getProjects() -> [ProjectModel]?
    /// has the duty to add Project to the CoreData
    func addProject(project: ProjectModel) -> Bool
    /// has the duty to fetch a project using id from the CoreData
    func getProject(withId id: Int) -> ProjectModel?
    /// has the duty to edit the exsiting project in the CoreData
    func editProject(project: ProjectModel) -> Bool
    /// has the duty to delete the project from the CoreData
    func deleteProject(withId id: Int) -> Bool
    /// has the duty to add time to an existing project in the CoreData
    func addTimeToProject(projectId: Int, timeModel: TimeModel) -> Bool
    /// has the duty to edit the existing time which is assigned to an existing project in the CoreData
    func editTime(projectId: Int, timeModel: TimeModel) -> Bool
    /// has the duty to get the time from the CoreData
    func getTime(projectId: Int,timeId: Int) -> TimeModel?
    /// has the duty to delete the time from the CoreData
    func deleteTime(projectId: Int, timeId: Int) -> Bool
    
}
/**
 This class has the duty to fetch and save the data from and to **CoreData**.
 
 ## Important Notes ##
 1. All the presenters have an instance of this class.
 2. All the **CoreData** business is handled in this class.
 */
class DataManager: DataManagerProtocol {
    // MARK: - Error Messages  -
    let errorGetProjects = "Could not fetch Projects. "
    let errorAddProject = "Could not save Project. "
    let errorGetProject = "Could not fetch Project. "
    let errorEditProject = "Editing Project Failed. "
    let errorDeleteProject = "Could not delete Project. "
    let errorAddTimeToProject = "Could not add Time to Project."
    let errorEditTime = "Could not Edit Time. "
    let errorGetTime = "Could not fetch Time. "
    let errorDeleteTime = "Could not delete Time. "
    
    // MARK: - Computed Variables  -
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    var managedContext: NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
        
    }
    
    // MARK: - functions  -
    func getProjects() -> [ProjectModel]? {
        guard let managedContext = self.managedContext else {
            return nil
        }
        var fetchedProjects: [NSManagedObject] = []

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.ProjectKeys.projectEntityName)
        do {
            fetchedProjects = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            let projects: [Project] = fetchedProjects as! [Project]
            var projectModels: [ProjectModel] = []
            for project in projects {
                let times = project.times?.allObjects as! [Time]
                var timeModels: [TimeModel] = []
                for time in times {
                    let timeModel = TimeModel(id: Int(time.id), date: time.date, hourSpent: Int(time.hourSpent), minuteSpent: Int(time.minuteSpent))
                    timeModels.append(timeModel)
                }
                let projectModel = ProjectModel(id: Int(project.id), title: project.title, desc: project.desc, times: timeModels, customerName: project.customerName, customerMobile: project.customerMobile, customerEmail: project.customerEmail)
                projectModels.append(projectModel)
            }
            return projectModels
        } catch let error as NSError {
            debugPrint(errorGetProjects + "\(error)")
            return nil
        }
    }
    
    func addProject(project: ProjectModel) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let projectObject = Project(context: managedContext)

        projectObject.title = project.title
        projectObject.desc = project.desc
        projectObject.customerName = project.customerName
        projectObject.customerMobile = project.customerMobile
        projectObject.customerEmail = project.customerEmail
        
        let uniqueId = self.nextAvailble(CoreDataEntityNames.ProjectKeys.id, forEntityName: CoreDataEntityNames.ProjectKeys.projectEntityName, inContext: managedContext)
        projectObject.id = Int64(uniqueId)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            debugPrint(errorAddProject + "\(error)")
            return false
        }
    }
    
    func getProject(withId id: Int) -> ProjectModel? {
        
        let projectModel: ProjectModel? = self.fetchProject(withId: id)
        return projectModel
    }
    
    func editProject(project: ProjectModel) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        guard let projectId = project.id else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.ProjectKeys.projectEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(projectId))
        do {
            let projects = try managedContext.fetch(fetchRequest)
            let projectObject: Project = projects.first as! Project
            projectObject.title = project.title
            projectObject.desc = project.desc
            projectObject.customerName = project.customerName
            projectObject.customerMobile = project.customerMobile
            projectObject.customerEmail = project.customerEmail
        } catch let error as NSError {
            debugPrint(errorEditProject + "\(error)")
            return false
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch let error as NSError {
            debugPrint(errorEditProject + "\(error)")
            return false
        }
    }
    
    func deleteProject(withId id: Int) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.ProjectKeys.projectEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(id))
        do {
            let projects = try managedContext.fetch(fetchRequest)
            let project: Project = projects.first as! Project
            managedContext.delete(project)
        } catch let error as NSError {
            debugPrint(errorDeleteProject + "\(error)")
            return false
        }
        do {
            try managedContext.save()
            return true
        }
        catch let error as NSError {
            debugPrint(errorDeleteProject + "\(error)")
            return false
        }
    }
    
    func addTimeToProject(projectId: Int, timeModel: TimeModel) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.ProjectKeys.projectEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(projectId))
        do {
            let projects = try managedContext.fetch(fetchRequest)
            let project: Project = projects.first as! Project
            let time = Time(context: managedContext)
            time.date = timeModel.date
            time.minuteSpent = Int64(timeModel.minuteSpent ?? 0)
            time.hourSpent = Int64(timeModel.hourSpent ?? 0)
            let uniqueId = self.nextAvailble(CoreDataEntityNames.TimeKeys.id, forEntityName: CoreDataEntityNames.TimeKeys.timeEntityName, inContext: managedContext)
            time.id = Int64(uniqueId)
            project.addToTimes(time)
        } catch let error as NSError {
            debugPrint(errorAddTimeToProject + "\(error)")
            return false
        }
        do {
            try managedContext.save()
            return true
        }
        catch let error as NSError {
            debugPrint(errorAddTimeToProject + "\(error)")
            return false
        }
    }
    
    func editTime(projectId: Int, timeModel: TimeModel) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        guard let timeId = timeModel.id else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.TimeKeys.timeEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(timeId))
        do {
            let times = try managedContext.fetch(fetchRequest)
            let time: Time = times.first as! Time
            time.hourSpent = Int64(timeModel.hourSpent ?? 0)
            time.minuteSpent = Int64(timeModel.minuteSpent ?? 0)
            time.date = timeModel.date
    
        } catch let error as NSError {
            debugPrint(errorEditTime + "\(error)")
        }
        do {
            try managedContext.save()
            return true
        }
        catch let error as NSError {
            debugPrint(errorEditTime + "\(error)")
            return false
        }
    }
    
    func getTime(projectId: Int, timeId: Int) -> TimeModel? {
        guard let projectModel: ProjectModel = self.fetchProject(withId: projectId) else {
            return nil
        }
        var selectedTime: TimeModel?
        for time in projectModel.times ?? [] where time.id == timeId  {
            selectedTime = time
        }
        return selectedTime
    }
    
    func deleteTime(projectId: Int, timeId: Int) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.TimeKeys.timeEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(timeId))
        do {
            let times = try managedContext.fetch(fetchRequest)
            let time: Time = times.first as! Time
            managedContext.delete(time)
        } catch let error as NSError {
            debugPrint(errorDeleteTime + "\(error)")
            return false
        }
        do {
            try managedContext.save()
            return true
        }
        catch let error as NSError {
            debugPrint(errorDeleteTime + "\(error)")
            return false
        }
    }
   
}

extension DataManager {
    /// helper function which fetch the project with the id from the CoreData
    private func fetchProject(withId id: Int) -> ProjectModel? {
        guard let managedContext = self.managedContext else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.ProjectKeys.projectEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(id))
        do {
            let projects = try managedContext.fetch(fetchRequest)
            let project: Project = projects.first as! Project
            var timeModels: [TimeModel] = []
            let times = project.times?.allObjects as! [Time]
            for time in times {
                let timeModel = TimeModel(id: Int(time.id), date: time.date, hourSpent: Int(time.hourSpent), minuteSpent: Int(time.minuteSpent))
                timeModels.append(timeModel)
            }
            let projectModel = ProjectModel(id: Int(project.id), title: project.title, desc: project.desc, times: timeModels, customerName: project.customerName, customerMobile: project.customerMobile, customerEmail: project.customerEmail)
            
            return projectModel
        } catch let error as NSError {
            print(errorGetProject + "\(error)")
            return nil
        }
    }
    /// helper function which returns a uiqueId to be assigned to entities in order to have a refrence to them later
    private func nextAvailble(_ idKey: String, forEntityName entityName: String, inContext context: NSManagedObjectContext) -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        fetchRequest.propertiesToFetch = [idKey]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: idKey, ascending: true)]
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard let lastObject = (results as? [NSManagedObject])?.last else {
                return 1
            }
            
            return (lastObject.value(forKey: idKey) as? Int ?? 0) + 1
            
        } catch let error as NSError {
            debugPrint(error)
        }
        
        return 1
    }
}
