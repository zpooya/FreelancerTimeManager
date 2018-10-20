//
//  CustomerInfoTableViewCell.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit

class CustomerInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerMobileButton: UIButton!
    @IBOutlet weak var customerEmailButton: UIButton!
    
    private var projectViewModel: ProjectViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func call(_ sender: UIButton) {
    }
    
    @IBAction func email(_ sender: UIButton) {
    }
    
    public func setContent(projectViewModel: ProjectViewModel?) {
        self.projectViewModel = projectViewModel
        self.customerNameLabel.text = projectViewModel?.customerName ?? ""
        self.customerMobileButton.setTitle(projectViewModel?.customerMobile ?? "", for: .normal)
        self.customerEmailButton.setTitle(projectViewModel?.customerEmail ?? "", for: .normal)
    }
}
