//
//  AddProjectViewController.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/18/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class AddProjectViewController: KeyboardHandler {
    // MARK: - constant variables  -
    let mandatoryErrorMessage = "Required"
    let action1Title = "Ok"
    
    // MARK: - IBOutlets  -
    @IBOutlet weak var customNavigationBar: UINavigationBar! {
        didSet {
            self.customNavigationBar.delegate = self
        }
    }
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var projectTitleTextField: CustomSkyFloatingLabelTextField!
    @IBOutlet weak var projectDescTextField: CustomSkyFloatingLabelTextField!
    @IBOutlet weak var customerNameTextField: CustomSkyFloatingLabelTextField!
    @IBOutlet weak var customerMobileTextField: CustomSkyFloatingLabelTextField!
    @IBOutlet weak var customerEmailTextField: CustomSkyFloatingLabelTextField!
    @IBOutlet var textFields: [CustomSkyFloatingLabelTextField]! {
        didSet {
            textFields.forEach({
                $0.delegate = self
            })
        }
    }
    // MARK: - variables  -
    private var presenter: AddProjectPresenter?
    private var projectTitle = ""
    private var projectDesc = ""
    private var customerName = ""
    private var customerMobile = ""
    private var customerEmail = ""
    private var projectId: Int?
    
    // MARK: - override  -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPresenter()
        self.setupView()
        self.getPageTitle()
    }
}
// MARK: - IBActions -
extension AddProjectViewController {
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.validation()
    }
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - public setContent  -
extension AddProjectViewController {
    public func setContent(projectViewModel: ProjectViewModel?) {
        guard let projectId = projectViewModel?.id else {
            return
        }
        self.projectTitle = projectViewModel?.title ?? ""
        self.projectDesc = projectViewModel?.desc ?? ""
        self.customerName = projectViewModel?.customerName ?? ""
        self.customerMobile = projectViewModel?.customerMobile ?? ""
        self.customerEmail = projectViewModel?.customerEmail ?? ""
        self.projectId = projectId
    }
}
// MARK: - UINavigationBarDelegate -
extension AddProjectViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
// MARK: - helper functions -
extension AddProjectViewController {
    private func setPresenter() {
        self.presenter = AddProjectPresenter(delegate: self)
    }
    private func setupView() {
        self.projectTitleTextField.text = self.projectTitle
        self.projectDescTextField.text = self.projectDesc
        self.customerNameTextField.text = self.customerName
        self.customerMobileTextField.text = self.customerMobile
        self.customerEmailTextField.text = self.customerEmail
        self.addKeyboardNotification(withConstraint: keyboardHeightLayoutConstraint)
        self.addGesturetoRemoveKeybard()
    }
    private func getPageTitle() {
        self.presenter?.getPageTitle(projectId: self.projectId)
    }
    private func validation() {
        self.projectTitle = self.projectTitleTextField.text ?? ""
        self.projectDesc = self.projectDescTextField.text ?? ""
        self.customerName = self.customerNameTextField.text ?? ""
        self.customerMobile = self.customerMobileTextField.text ?? ""
        self.customerEmail = self.customerEmailTextField.text ?? ""
        if projectTitle.count > 0, customerName.count > 0 {
            self.createOrUpdateProject()
            return
        }
        if projectTitle.count < 1 {
            self.projectTitleTextField.errorMessage = self.mandatoryErrorMessage
        }
        if customerName.count < 1 {
            self.customerNameTextField.errorMessage = self.mandatoryErrorMessage
        }
    }
    private func createOrUpdateProject() {
        self.presenter?.createProject(projectTitle: self.projectTitle, projectDesc: self.projectDesc, customerName: self.customerName, customerMobile: self.customerMobile, customerEmail: self.customerEmail, projectId: self.projectId)
    }
}
// MARK: - UITextFieldDelegate  -
extension AddProjectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case projectTitleTextField:
            self.projectDescTextField.becomeFirstResponder()
        case projectDescTextField:
            self.customerNameTextField.becomeFirstResponder()
        case customerNameTextField:
            self.customerMobileTextField.becomeFirstResponder()
        case customerMobileTextField:
            self.customerEmailTextField.becomeFirstResponder()
        case customerEmailTextField:
            self.validation()
        default:
            break
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textFiledCustom = textField as? CustomSkyFloatingLabelTextField {
            textFiledCustom.errorMessage = ""
        }
    }
}
// MARK: - AddProjectPresenterDelegate  -
extension AddProjectViewController: AddProjectPresenterDelegate {
    func setPageTitle(title: String) {
        self.navItem.title = title
    }
    
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
}

