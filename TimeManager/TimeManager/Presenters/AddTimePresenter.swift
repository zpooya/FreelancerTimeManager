//
//  AddTimePresenter.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import Foundation

protocol AddTimePresenterDelegate: class {
    func showloading()
    func success()
    func handleError()
}
protocol AddTimePresenterProtocol: class {
    func saveSelectedDateAndTime(timeViewModel: TimeViewModel?, date: Date, time: Date)
}
class AddTimePresenter {
     private weak var delegate: AddTimePresenterDelegate?
    private var dataManager = DataManager()
    init(delegate: AddTimePresenterDelegate) {
        self.delegate = delegate
    }
}

// MARK: - AddTimePresenterProtocol  -
extension AddTimePresenter: AddTimePresenterProtocol {
    public func saveSelectedDateAndTime(timeViewModel: TimeViewModel?, date: Date, time: Date) {
        if let id = timeViewModel?.id  {
            self.updateDateAndTime(id: id, date: date, time: time)
        } else {
            self.createDateAndTime(date: date, time: time)
        }
    }
}
// MARK: - Connecting to DataManager  -
extension AddTimePresenter {
    private func createDateAndTime(date: Date, time: Date) {
        // (todo).call datamanager
    }
    private func updateDateAndTime(id: Int, date: Date, time: Date) {
        // (todo). callUpdateDateAndTime
    }
}
