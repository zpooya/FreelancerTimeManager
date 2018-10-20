//
//  TimeTableViewCell.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit
protocol TimeTableViewCellDelegate: class {
    func deleteTime(withId id: Int)
}
class TimeTableViewCell: UITableViewCell {

    // MARK: - IBOutlet  -
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    // MARK: - variables  -
    var timeId: Int?
    weak var delegate: TimeTableViewCellDelegate?
    // MARK: - override  -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - IBAction  -
    @IBAction func deleteTime(_ sender: UIButton) {
        guard let timeId = self.timeId else {
            return
        }
        self.delegate?.deleteTime(withId: timeId)
    }
    
    // MARK: - Public setContent  -
    func setContent(projectDetailTimeViewModel: ProjectDetailTimeViewModel?) {
        self.timeId = projectDetailTimeViewModel?.id
        self.dateLabel.text = projectDetailTimeViewModel?.dateToShow ?? ""
        self.timeSpentLabel.text = projectDetailTimeViewModel?.timeToShow ?? ""
    }
}
