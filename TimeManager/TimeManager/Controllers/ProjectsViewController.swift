//
//  ProjectsViewController.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/18/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
    
    // MARK: - Constant Variables  -
    let pageTitle = "Projects"
    let heightForRow: CGFloat = 133
    let numberOfSections: Int = 1
    let projectTableViewCellIdentifier = "ProjectTableViewCell"
    let alerControllerTitle = "No Projects"
    let alertControllerMessage = "There are no projects, add One"
    let addActionTitle = "Add Project"
    let action1Title = "Ok"
    let action2Title = "Cancel"
    // MARK: - IBOutlet  -
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var projectsTableView: UITableView! {
        didSet {
            self.projectsTableView.register(UINib(nibName: self.projectTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: self.projectTableViewCellIdentifier)
            self.projectsTableView.delegate = self
            self.projectsTableView.dataSource = self
        }
    }
    // MARK: - Variables -
    private var presenter: ProjectsPresenter?
    private var projectsViewModel = [ProjectViewModel]() {
        didSet {
            self.projectsTableView.reloadData()
        }
    }
    // MARK: - Override -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle()
        self.setPresenter()
        self.getProjects()
        // Do any additional setup after loading the view.
    }
}
// MARK: - IBAction -
extension ProjectsViewController {
    @IBAction func goToAddProject(_ sender: UIBarButtonItem) {
        
    }
}
// MARK: - setPresenter  -
extension ProjectsViewController {
    private func setPresenter() {
        self.presenter = ProjectsPresenter(delegate: self)
    }
}
// MARK: - SetupView -
extension ProjectsViewController {
    private func setTitle() {
        self.title = self.pageTitle
    }
}
// MARK: - getProjects -
extension ProjectsViewController {
    private func getProjects() {
        self.presenter?.getProjects()
    }
}
// MARK: - UITableViewDataSource  -
extension ProjectsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectsViewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.projectTableViewCellIdentifier, for: indexPath) as! ProjectTableViewCell
        cell.setContent(projectViewModel: self.projectsViewModel[indexPath.row])
        cell.delegate = self
        return cell
    }
}
// MARK: - UITableViewDelegate  -
extension ProjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.goToProjectDetail(controller: self, projectViewModel: self.projectsViewModel[indexPath.row])
    }
}
// MARK: - ProjectTableViewCellDelegate  -
extension ProjectsViewController: ProjectTableViewCellDelegate {
    func userDidSelectDeleteProject(projectViewModel: ProjectViewModel?) {
        guard let projectId = projectViewModel?.id else {
            return
        }
        self.presenter?.deleteProject(projectId: projectId)
    }
    
    func userDidSelecAddTime(projectViewModel: ProjectViewModel?) {
        guard let projectId = projectViewModel?.id else {
            return
        }

        self.presenter?.goToAddTime(controller: self, timeViewModel: nil, projectId: projectId)
    }
    
    
}

// MARK: - ProjectsPresenterDelegate  -
extension ProjectsViewController: ProjectsPresenterDelegate {
    func startLoading() {
        
    }
    
    func stopLoading() {
        
    }
    
    func handleEmptyProjects() {
        let alertController = UIAlertController(title: self.alerControllerTitle, message: self.alertControllerMessage, preferredStyle: .alert)
        let action1 = UIAlertAction(title: self.addActionTitle, style: .default) { (action:UIAlertAction) in
            self.presenter?.gotoAddProject(controller: self, projectViewModel: nil)
        }
        let action2 = UIAlertAction(title: self.action2Title, style: .cancel, handler: nil)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func setProjects(projectsViewModel: [ProjectViewModel]) {
        self.projectsViewModel = projectsViewModel
    }
    
    func projectDeletedShowMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: self.action1Title, style: .default) { (action:UIAlertAction) in
            self.presenter?.getProjects()
        }
        alertController.addAction(action1)
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
