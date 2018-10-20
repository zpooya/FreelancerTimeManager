//
//  AddTimeViewController.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/18/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class AddTimeViewController: UIViewController {
    // MARK: - constant variables  -
    let missingTitle = "Missing Value"
    let missingTimeMessage = "Please select how many hours you worked."
    let action1Title = "Ok"
    let action2Title = "Cancel"
    // MARK: - IBOutlet  -
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var customNavigationBar: UINavigationBar! {
        didSet {
            self.customNavigationBar.delegate = self
        }
    }
    @IBOutlet weak var navItem: UINavigationItem!
    // MARK: - variables  -
    private var timeViewModel: TimeViewModel?
    private var presenter: AddTimePresenter?
    private var selectedDate = Date()
    private var selectedTime = Date()
    private var projectId: Int?
    // MARK: - override  -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPresenter()
        self.addTargetToPickers()
        self.setupView()
        self.getPageTitle()
    }
  
}

// MARK: - IBActions  -
extension AddTimeViewController
{
    @IBAction func done(_ sender: Any) {
        self.validation()
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
// MARK: - helper functions -
extension AddTimeViewController {
    private func setPresenter() {
        self.presenter = AddTimePresenter(delegate: self)
    }
    private func addTargetToPickers() {
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(timeChanged(sender:)), for: .valueChanged)

    }
    private func setupView() {
        self.datePicker.date = self.timeViewModel?.dateToShow ?? Date()
        let defaultTime = Date().setTime(hour: 0, min: 0) ?? Date()
        self.timePicker.date = self.timeViewModel?.timeToShow ?? defaultTime
    }
    
    private func getPageTitle() {
        self.presenter?.getPageTitle(timeViewModel: self.timeViewModel)
    }
    
    private func validation() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self.selectedTime)
        if let hour = components.hour, hour > 0 {
            self.createOrUpdateTime()
            return
        } else if let minute = components.minute, minute > 0 {
            self.createOrUpdateTime()
            return
        } else {
            let alertController = UIAlertController(title: missingTitle, message: missingTimeMessage, preferredStyle: .alert)
            let action1 = UIAlertAction(title: self.action1Title, style: .default) { (action:UIAlertAction) in
            }
            alertController.addAction(action1)
            alertController.popoverPresentationController?.sourceView = self.view
            self.present(alertController, animated: true, completion: nil)
        }
    }
    private func createOrUpdateTime() {
        guard let projectId = self.projectId else {
            return
        }
        self.presenter?.saveOrUpdateSelectedDateAndTime(timeViewModel: self.timeViewModel, date: self.selectedDate, time: self.selectedTime, projectId: projectId)
    }
}
// MARK: - objc Functions -
@objc extension AddTimeViewController {
     func dateChanged(sender: UIDatePicker) {
        self.selectedDate = sender.date
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            debugPrint("\(day) \(month) \(year)")
        }
    }
    
    func timeChanged(sender: UIDatePicker) {
        self.selectedTime = sender.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        if let hour = components.hour, let minute = components.minute {
            debugPrint("\(hour) \(minute)")
        }
    }
}
// MARK: - UINavigationBarDelegate -
extension AddTimeViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
// MARK: - Public Functions  -
extension AddTimeViewController {
    func setContent(timeViewModel: TimeViewModel?, projectId: Int) {
        self.timeViewModel = timeViewModel
        self.projectId = projectId
    }
}
// MARK: - AddTimePresenterDelegate  -
extension AddTimeViewController: AddTimePresenterDelegate {
    func successfullyCreatedOrUpdated(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: self.action1Title, style: .default) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action1)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
    }
    
    func failedToCreateOrUpdate(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: self.action1Title, style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setPageTitle(title: String) {
        self.navItem.title = title
    }
}
