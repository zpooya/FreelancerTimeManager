//
//  AddTimePresenter.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation
/**
 This protocol is the Delegate of AddTimePresenter.
 
 ## It has the Following functions ##
 1. **successfullyCreatedOrUpdated**
 2. **failedToCreateOrUpdate**
 3. **setPageTitle**
 */
protocol AddTimePresenterDelegate: class {
    /// set the message for successfully created or updated
    func successfullyCreatedOrUpdated(title: String, message: String)
    /// set the messafe for failing to create or update
    func failedToCreateOrUpdate(title: String, message: String)
    /// set the page title
    func setPageTitle(title: String)
}
/**
 This protocol represents the public functions of **AddTimePresenter** class.
 
 ## It has the Following functions ##
 1. **saveOrUpdateSelectedDateAndTime**
 2. **getPageTitle**
 */
protocol AddTimePresenterProtocol: class {
    /// has the duty to create time
    func saveOrUpdateSelectedDateAndTime(timeViewModel: TimeViewModel?, date: Date, time: Date, projectId: Int)
    /// has the duty to get the page title
    func getPageTitle(timeViewModel: TimeViewModel?)

}
class AddTimePresenter {
    // MARK: - Constant Variables  -
    let successfullyCreated = "Time Successfully Created"
    let successfullyUpdated = "Time Successfully Updated"
    let successTitle = "Success"
    let failedToCreate = "Failed to Create Time"
    let failedToUpdate = "Failed to Update Time"
    let failedTitle = "Error"
    let updateTitle = "Update Time"
    let createTitle = "Create Time"
    
    // MARK: - private variables  -
    private weak var delegate: AddTimePresenterDelegate?
    private var dataManager = DataManager()
    init(delegate: AddTimePresenterDelegate, dataManager: DataManager) {
        self.delegate = delegate
        self.dataManager = dataManager
    }
}

// MARK: - AddTimePresenterProtocol  -
extension AddTimePresenter: AddTimePresenterProtocol {
    /**
     This method is called from view to add the time to CoreData
     */
    func saveOrUpdateSelectedDateAndTime(timeViewModel: TimeViewModel?, date: Date, time: Date, projectId: Int) {
        let timeModel = self.createTimeModel(date: date, time: time, id: timeViewModel?.id)
        if timeViewModel?.id != nil {
            let timeUpdated = self.updateDateAndTime(timeModel: timeModel, projectId: projectId)
            if timeUpdated {
                self.delegate?.successfullyCreatedOrUpdated(title: successTitle, message: successfullyUpdated)
            } else {
                self.delegate?.failedToCreateOrUpdate(title: failedTitle, message: failedToUpdate)
            }
        } else {
            let timeCreated = self.createDateAndTime(timeModel: timeModel, projectId: projectId)
            if timeCreated {
                self.delegate?.successfullyCreatedOrUpdated(title: successTitle, message: successfullyCreated)
            } else {
                self.delegate?.failedToCreateOrUpdate(title: failedTitle, message: failedToCreate)

            }
        }
    }
    /**
     This method is called from view to get the page title .
     - Parameter timeViewModel: if timeViewModel.id  is not null then the title is update else it is create
     */

    func getPageTitle(timeViewModel: TimeViewModel?) {
        if timeViewModel?.id != nil {
            self.delegate?.setPageTitle(title: self.updateTitle)
        } else {
            self.delegate?.setPageTitle(title: self.createTitle)
        }
    }
   
}
// MARK: - Connecting to DataManager  -
extension AddTimePresenter {
    private func createDateAndTime(timeModel: TimeModel, projectId: Int) -> Bool {
        return dataManager.addTimeToProject(projectId: projectId, timeModel: timeModel)
    }
    private func updateDateAndTime(timeModel: TimeModel, projectId: Int) -> Bool{
        return self.dataManager.editTime(projectId: projectId, timeModel: timeModel)
    }
}
// MARK: - helper functions -
extension AddTimePresenter {
    /**
     This method makes the **TimeModel*** to be give to DataManager.
     
     - Parameter date: selected date.
     - Parameter time: selected time.
     - Parameter id: timeId if available for updating.

     - returns: TimeModel to be given to DataManager.
     */
    private func createTimeModel(date: Date, time: Date, id: Int?) -> TimeModel {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let timeModel = TimeModel(id: id, date: date.string, hourSpent: hour, minuteSpent: minute)
        return timeModel
        
    }
}
