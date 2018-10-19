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
    func addProject(project: ProjectModel) -> Bool
    func getProject(withId id: Int) -> ProjectModel?
    func editProject(project: ProjectModel) -> Bool
    func deleteProject(withId id: Int) -> Bool
    func addTimeToProject(projectId: Int, timeModel: TimeModel) -> Bool
    func editTime(projectId: Int, timeModel: TimeModel) -> Bool
    func getTime(projectId: Int,timeId: Int) -> TimeModel?
    func deleteTime(projectId: Int, timeId: Int) -> Bool
    
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
        

//        guard let projectEntity = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.ProjectKeys.projectEntityName, in: managedContext) else {
//            return
//        }
//        let projectObject = NSManagedObject(entity: projectEntity, insertInto: managedContext)
//         let uniqueId = self.nextAvailble(CoreDataEntityNames.ProjectKeys.id, forEntityName: CoreDataEntityNames.ProjectKeys.projectEntityName, inContext: managedContext)
//        projectObject.setValue(Int64(uniqueId), forKeyPath: CoreDataEntityNames.ProjectKeys.id)
//        projectObject.setValue(project.title, forKeyPath: CoreDataEntityNames.ProjectKeys.title)
//        projectObject.setValue(project.desc, forKey: CoreDataEntityNames.ProjectKeys.desc)
//        projectObject.setValue(project.customerName, forKey: CoreDataEntityNames.ProjectKeys.customerName)
//        projectObject.setValue(project.customerMobile, forKey: CoreDataEntityNames.ProjectKeys.customerMobile)
//        projectObject.setValue(project.customerEmail, forKey: CoreDataEntityNames.ProjectKeys.customerEmail)
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save Project. \(error)")
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
//            project.setValue(project.title, forKeyPath: CoreDataEntityNames.ProjectKeys.title)
//            project.setValue(project.desc, forKey: CoreDataEntityNames.ProjectKeys.desc)
//            project.setValue(project.customerName, forKey: CoreDataEntityNames.ProjectKeys.customerName)
//            project.setValue(project.customerMobile, forKey: CoreDataEntityNames.ProjectKeys.customerMobile)
//            project.setValue(project.customerEmail, forKey: CoreDataEntityNames.ProjectKeys.customerEmail)
//
        } catch let error as NSError {
            print("Could not edit Project. \(error)")
            return false
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch let error as NSError {
            print("Editing Project Failed: \(error)")
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
            return true

        } catch let error as NSError {
            print("Could not delete Project. \(error)")
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
            return true
        } catch let error as NSError {
            print("Could not add Time to Project. \(error)")
            return false
        }
    }
    
    func editTime(projectId: Int, timeModel: TimeModel) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityNames.TimeKeys.timeEntityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(projectId))
        do {
            let times = try managedContext.fetch(fetchRequest)
            let time: Time = times.first as! Time
            time.hourSpent = Int64(timeModel.hourSpent ?? 0)
            time.minuteSpent = Int64(timeModel.minuteSpent ?? 0)
            time.date = timeModel.date
    
        } catch let error as NSError {
            print("Could not fetch Project. \(error)")
        }
        do {
            try managedContext.save()
            return true
        }
        catch let error as NSError {
            print("Editing Time Failed: \(error)")
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
            return true
            
        } catch let error as NSError {
            print("Could not delete Time. \(error)")
            return false
        }
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
