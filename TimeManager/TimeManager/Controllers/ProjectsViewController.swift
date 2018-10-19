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
    let pageTitle = "Top Stories"
    let heightForRow: CGFloat = 133
    let numberOfSections: Int = 1
    let projectTableViewCellIdentifier = "ProjectTableViewCell"
    let alerControllerTitle = "No Project"
    let alertControllerMessage = "There are no projects, add One"
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
        // Do any additional setup after loading the view.
    }
}
// MARK: - setPresenter  -
extension ProjectsViewController {
    private func setPresenter() {
       // self.presenter = TopStoriesPresenter(delegate: self, network: TopStoriesNetwork())
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
     //   self.presenter?.getTopStories()
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
        //cell.setContent(topStoryViewModel: self.topStoriesViewModel[indexPath.row])
        return cell
    }
}
// MARK: - UITableViewDelegate  -
extension ProjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.presenter?.goToTopStoryDetail(controller: self, withData: self.topStoriesViewModel[indexPath.row])
    }
}
