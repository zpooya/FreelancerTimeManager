//
//  TimeSectionHeaderTableViewCell.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit
protocol TimeSectionHeaderTableViewCellDelegate: class {
    func goToAddTime()
}
class TimeSectionHeaderTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var totalTimeSpent: UILabel!
    
    weak var delegate: TimeSectionHeaderTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func goToaddTime(_ sender: UIButton) {
        self.delegate?.goToAddTime()
    }
    
    func setContent(projectViewModel: ProjectViewModel?) {
        self.totalTimeSpent.text = projectViewModel?.totalTimeSpent ?? ""
    }
    
}
