//
//  ProjectDetailViewController.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/18/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit
import MessageUI

class ProjectDetailViewController: UIViewController {
    
    // MARK: - Constant Variables  -
    let estimatedRowHeight: CGFloat = 50
    let section0HeaderHeight: CGFloat = 0
    let section1HeaderHeight: CGFloat = 70
    let numberOfSections: Int = 2
    let numberOfSection0Rows: Int = 2
    let projectInfoTableViewCelldentifier = "ProjectInfoTableViewCell"
    let customerInfoTableViewCelldentifier = "CustomerInfoTableViewCell"
    let timeTableViewCellIdentifier = "TimeTableViewCell"
    let timeSectionHeaderTableViewCellIdentifier = "TimeSectionHeaderTableViewCell"
    let pageTitle = "Project Detail"
    let action1Title = "Ok"
    let action2Title = "Cancel"
    let deleteTimeAlertMessage = "Are you sure you want to delete the time?"
    let deleteActionTile = "Yes"
    let emailSubject = "Invoice"
    
    // MARK: - IBOutlet  -
    @IBOutlet weak var projectDetailTableView: UITableView! {
        didSet {
            // MARK: registering Nibs
            self.projectDetailTableView.register(UINib(nibName: self.projectInfoTableViewCelldentifier, bundle: nil), forCellReuseIdentifier: self.projectInfoTableViewCelldentifier)
            self.projectDetailTableView.register(UINib(nibName: self.customerInfoTableViewCelldentifier, bundle: nil), forCellReuseIdentifier: self.customerInfoTableViewCelldentifier)
            self.projectDetailTableView.register(UINib(nibName: self.timeTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: self.timeTableViewCellIdentifier)
          
            self.projectDetailTableView.register(UINib(nibName: self.timeSectionHeaderTableViewCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.timeSectionHeaderTableViewCellIdentifier)
            // MARK: tableView Setting
            self.projectDetailTableView.estimatedRowHeight = self.estimatedRowHeight
            self.projectDetailTableView.rowHeight = UITableView.automaticDimension
            self.projectDetailTableView.delegate = self
            self.projectDetailTableView.dataSource = self
            
        }
    }
    // MARK: - variables  -
    private var projectViewModel: ProjectViewModel? {
        didSet {
            self.projectDetailTableView?.reloadData()
        }
    }
    private var presenter: ProjectDetailPresenter?
    private var emailMessage: String {
        var message = "<p>This email is to notify you that your invoice for porject "
        message += "<b>" + (self.projectViewModel?.title ?? "" ) + "</b>"
        message += " is as follow:</p><p>\n\n Total Time Spent: \n\n"
        message += (self.projectViewModel?.totalTimeSpent ?? "0") + "</p>"
        return message
    }

    // MARK: - overrides -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle()
        self.setPresenter()
        self.projectDetailTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getProject()
    }
    
}
// MARK: - setPresenter  -
extension ProjectDetailViewController {
    private func setPresenter() {
        self.presenter = ProjectDetailPresenter(delegate: self)
    }
}
// MARK: - helper functions  -
extension ProjectDetailViewController {
    private func getProject() {
        guard let projectId = self.projectViewModel?.id else {
            return
        }
        self.presenter?.getProject(projectId: projectId)
    }
}
// MARK: - IBAction  -
extension ProjectDetailViewController {
    @IBAction func editProjec(_ sender: UIBarButtonItem) {
        self.presenter?.gotoAddProject(controller: self, projectViewModel: self.projectViewModel)
    }
}
// MARK: - public setContent  -
extension ProjectDetailViewController {
    public func setContent(projectViewModel: ProjectViewModel) {
        self.projectViewModel = projectViewModel
    }
}
// MARK: - private functions  -
extension ProjectDetailViewController {
    private func setTitle() {
        self.title = self.pageTitle
    }
}
// MARK: - UITableViewDataSource  -
extension ProjectDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return numberOfSection0Rows
        default:
            return self.projectViewModel?.timesForProjectDetail.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: self.projectInfoTableViewCelldentifier, for: indexPath) as! ProjectInfoTableViewCell
                cell.setContent(projectViewModel: self.projectViewModel)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: self.customerInfoTableViewCelldentifier, for: indexPath) as! CustomerInfoTableViewCell
                cell.setContent(projectViewModel: self.projectViewModel)
                cell.delegate = self
                return cell
            }
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.timeTableViewCellIdentifier, for: indexPath) as! TimeTableViewCell
            cell.setContent(projectDetailTimeViewModel: self.projectViewModel?.timesForProjectDetail[indexPath.row])
            cell.delegate = self
            return cell
            
        }
    }
    
}
// MARK: - UITableViewDelegate  -
extension ProjectDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return self.section0HeaderHeight
        default:
            return self.section1HeaderHeight
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.timeSectionHeaderTableViewCellIdentifier) as! TimeSectionHeaderTableViewCell
        headerView.setContent(projectViewModel: self.projectViewModel)
        headerView.delegate = self
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            self.presenter?.goToAddTime(controller: self, projectDetailTimeViewModel: self.projectViewModel?.timesForProjectDetail[indexPath.row], projectViewModel: self.projectViewModel)
        default:
            break
        }
    }
}
// MARK: - CustomerInfoTableViewCellDelegate  -
extension ProjectDetailViewController: CustomerInfoTableViewCellDelegate {
    func sendEmail() {
        self.sendEmailToCustomer()
    }
}
// MARK: - TimeTableViewCellDelegate  -
extension ProjectDetailViewController: TimeTableViewCellDelegate {
    func deleteTime(withId id: Int) {
        guard let projectId = self.projectViewModel?.id else {
            return
        }
        let alertController = UIAlertController(title: nil, message: self.deleteTimeAlertMessage, preferredStyle: .alert)
        let action1 = UIAlertAction(title: self.deleteActionTile, style: .default) { (action:UIAlertAction) in
            self.presenter?.deleteTime(timeId: id, projectId: projectId)
        }
        let action2 = UIAlertAction(title: self.action2Title, style: .cancel, handler: nil)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
        
    }
}
// MARK: - TimeSectionHeaderTableViewCellDelegate  -
extension ProjectDetailViewController: TimeSectionHeaderTableViewCellDelegate {
    func goToAddTime() {
        self.presenter?.goToAddTime(controller: self, projectDetailTimeViewModel: nil, projectViewModel: self.projectViewModel)
    }
    
}
// MARK: - sending invoice email  -
extension ProjectDetailViewController {
    func sendEmailToCustomer() {
    
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.projectViewModel?.customerEmail ?? ""])
            mail.setSubject(self.emailSubject)
            mail.setMessageBody(self.emailMessage, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
 
}
// MARK: - MFMailComposeViewControllerDelegate  -
extension ProjectDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)

    }
}
// MARK: - ProjectDetailPresenterDelegate  -
extension ProjectDetailViewController: ProjectDetailPresenterDelegate {
    func handleEmptyProject() {
        self.projectViewModel = nil
    }
    
    func setProject(projectViewMode: ProjectViewModel) {
        self.projectViewModel = projectViewMode
    }
    
    func timeDeletedShowMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: self.action1Title, style: .default) { (action:UIAlertAction) in
            self.getProject()
        }
        alertController.addAction(action1)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
    }
}
