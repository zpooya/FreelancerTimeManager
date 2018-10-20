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
    // MARK: - IBOutelt  -
    @IBOutlet weak var totalTimeSpent: UILabel!
    
    // MARK: - variables  -
    weak var delegate: TimeSectionHeaderTableViewCellDelegate?
    
    // MARK: - override  -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - IBAction  -
    @IBAction func goToaddTime(_ sender: UIButton) {
        self.delegate?.goToAddTime()
    }
    // MARK: - Public setContent  -
    func setContent(projectViewModel: ProjectViewModel?) {
        self.totalTimeSpent.text = projectViewModel?.totalTimeSpent ?? ""
    }
    
}
