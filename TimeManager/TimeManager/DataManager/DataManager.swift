//
//  DataManager.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit
import CoreData

protocol DataManagerProtocol: class {
    var appDelegate: AppDelegate? {get}
    var managedContext: NSManagedObjectContext? {get}
    func getProjects() -> [ProjectModel]?
    func addProject(project: ProjectModel)
    func getProject(withId id: Int) -> ProjectModel?
    func editProject(project: ProjectModel)
    func deleteProjec(withId id: Int)
    func addTimeToProject(projectId: Int, time: TimeModel)
    func editTime(projectId: Int, time: TimeModel)
    func getTime(projectId: Int,timeId: Int) -> TimeModel?
    func deleteTime(projectId: Int, timeId: Int)
    
}
class CoreDataEntityNames {
    struct ProjectKeys {
        static let projectEntityName = "Project"
        static let id = "id"
        static let title = "title"
        static let desc = "desc"
        static let customerName = "customerName"
        static let customerMobile = "customerMobile"
        static let customerEmail = "customerEmail"
        

    }
    struct TimeKeys {
        static let timeEntityName = "Time"
        static let id = "id"
        static let date = "date"
        static let hourSpent = "hourSpent"
        static let minuteSpent = "minuteSpent"
    }
}
class DataManager: DataManagerProtocol {
    
    
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
            print("Could not fetch Projects. \(error)")
            return nil
        }
    }
    
    func addProject(project: ProjectModel) {
        guard let managedContext = self.managedContext else {
            return
        }
        guard let projectEntity = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.ProjectKeys.projectEntityName, in: managedContext) else {
            return
        }
        let projectObject = NSManagedObject(entity: projectEntity, insertInto: managedContext)
         let uniqueId = self.nextAvailble(CoreDataEntityNames.ProjectKeys.id, forEntityName: CoreDataEntityNames.ProjectKeys.projectEntityName, inContext: managedContext)
        projectObject.setValue(Int64(uniqueId), forKeyPath: CoreDataEntityNames.ProjectKeys.id)
        projectObject.setValue(project.title, forKeyPath: CoreDataEntityNames.ProjectKeys.title)
        projectObject.setValue(project.desc, forKey: CoreDataEntityNames.ProjectKeys.desc)
        projectObject.setValue(project.customerName, forKey: CoreDataEntityNames.ProjectKeys.customerName)
        projectObject.setValue(project.customerMobile, forKey: CoreDataEntityNames.ProjectKeys.customerMobile)
        projectObject.setValue(project.customerEmail, forKey: CoreDataEntityNames.ProjectKeys.customerEmail)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save Project. \(error)")
        }
    }
    
    func getProject(withId id: Int) -> ProjectModel? {
        
        let projectModel: ProjectModel? = self.fetchProject(withId: id)
        return projectModel
    }
    
    func editProject(project: ProjectModel) {
        guard let managedContext = self.managedContext else {
            return
        }
        guard let projectId = project.id else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.ProjectKeys.projectEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(projectId))
        do {
            let projects = try managedContext.fetch(fetchRequest)
            let project: Project = projects.first as! Project
            project.setValue(project.title, forKeyPath: CoreDataEntityNames.ProjectKeys.title)
            project.setValue(project.desc, forKey: CoreDataEntityNames.ProjectKeys.desc)
            project.setValue(project.customerName, forKey: CoreDataEntityNames.ProjectKeys.customerName)
            project.setValue(project.customerMobile, forKey: CoreDataEntityNames.ProjectKeys.customerMobile)
            project.setValue(project.customerEmail, forKey: CoreDataEntityNames.ProjectKeys.customerEmail)
            
        } catch let error as NSError {
            print("Could not fetch Project. \(error)")
            return
        }
        
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Editing Project Failed: \(error)")
        }
    }
    
    func deleteProjec(withId id: Int) {
        guard let managedContext = self.managedContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.ProjectKeys.projectEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(id))
        do {
            let projects = try managedContext.fetch(fetchRequest)
            let project: Project = projects.first as! Project
            managedContext.delete(project)

        } catch let error as NSError {
            print("Could not fetch Project. \(error)")
            return
        }
    }
    
    func addTimeToProject(projectId: Int, time: TimeModel) {
        
    }
    
    func editTime(projectId: Int, time: TimeModel) {
        
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
    
    func deleteTime(projectId: Int, timeId: Int) {
        
    }
   
}

extension DataManager {
    func fetchProject(withId id: Int) -> ProjectModel? {
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
            print("Could not fetch Project. \(error)")
            return nil
        }
    }
    func nextAvailble(_ idKey: String, forEntityName entityName: String, inContext context: NSManagedObjectContext) -> Int {
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
