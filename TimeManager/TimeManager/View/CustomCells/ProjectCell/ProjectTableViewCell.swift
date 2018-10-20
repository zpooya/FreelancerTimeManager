//
//  ProjectTableViewCell.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit
protocol ProjectTableViewCellDelegate: class {
    func userDidSelectDeleteProject(projectViewModel: ProjectViewModel?)
    func userDidSelecAddTime(projectViewModel: ProjectViewModel?)
}
class ProjectTableViewCell: UITableViewCell {
    // MARK: - IBOutlet  -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var timeSpentAmountLabel: UILabel!
    
    // MARK: - variables  -
    weak var delegate: ProjectTableViewCellDelegate?
    private var projectViewModel: ProjectViewModel?
    // MARK: - overrides -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - IBAction  -
    @IBAction func addTime(_ sender: UIButton) {
        self.delegate?.userDidSelecAddTime(projectViewModel: self.projectViewModel)
    }
    @IBAction func deleteProject(_ sender: Any) {
        self.delegate?.userDidSelectDeleteProject(projectViewModel: self.projectViewModel)
    }
    
    // MARK: - Public SetContent -
    public func setContent(projectViewModel: ProjectViewModel) {
        self.projectViewModel = projectViewModel
        self.titleLabel.text = projectViewModel.title ?? ""
        self.customerLabel.text = projectViewModel.customerName ?? ""
        self.timeSpentAmountLabel.text = projectViewModel.totalTimeSpent ?? ""
    }
}
