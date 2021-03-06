//
//  ProjectInfoTableViewCell.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class ProjectInfoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets  -
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectDescLabel: UILabel!
    
    // MARK: - overrides  -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public setContent  -
    public func setContent(projectViewModel: ProjectViewModel?) {
        self.projectTitleLabel.text = projectViewModel?.title ?? ""
        self.projectDescLabel.text = projectViewModel?.desc ?? ""
    }
}
