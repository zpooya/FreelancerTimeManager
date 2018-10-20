//
//  AddTimeViewController.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/18/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class AddTimeViewController: UIViewController {
    // MARK: - IBOutlet  -
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var customNavigationBar: UINavigationBar! {
        didSet {
            self.customNavigationBar.delegate = self
        }
    }
    // MARK: - variables  -
    private var timeViewModel: TimeViewModel?
    private var presenter: AddTimePresenter?
    private var selectedDate = Date()
    private var selectedTime = Date()
    // MARK: - override  -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPresenter()
        self.addTargetToPickers()
        self.setupView()
    }
  
}

// MARK: - IBActions  -
extension AddTimeViewController
{
    @IBAction func done(_ sender: Any) {
        self.presenter?.saveSelectedDateAndTime(timeViewModel: self.timeViewModel, date: self.selectedDate, time: self.selectedTime)
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
}
// MARK: - objc Functions -
@objc extension AddTimeViewController {
     func dateChanged(sender: UIDatePicker) {
        self.selectedDate = sender.date
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
        }
    }
    
    func timeChanged(sender: UIDatePicker) {
        self.selectedTime = sender.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        if let hour = components.hour, let minute = components.minute {
            print("\(hour) \(minute)")
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
    }
}
// MARK: - AddTimePresenterDelegate  -
extension AddTimeViewController: AddTimePresenterDelegate {
    func showloading() {
        
    }
    
    func success() {
        
    }
    
    func handleError() {
        
    }
    
}
