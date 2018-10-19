//
//  ProjectTableViewCell.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/19/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    // MARK: - IBOutlet  -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var timeSpentAmountLabel: UILabel!
    
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
    }
    @IBAction func deleteProject(_ sender: Any) {
    }
    
    // MARK: - Public SetContent -
    public func setContent() {
        
    }
}
