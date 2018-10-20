//
//  CustomerInfoTableViewCell.swift
//  TimeManager
//
//  Created by Zamzam Pooya on 10/20/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import UIKit
protocol CustomerInfoTableViewCellDelegate: class {
    func sendEmail()
}
class CustomerInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerMobileButton: UIButton!
    @IBOutlet weak var customerEmailButton: UIButton!
    
    private var projectViewModel: ProjectViewModel?
    weak var delegate: CustomerInfoTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func call(_ sender: UIButton) {
        if let number = self.projectViewModel?.customerMobile,
            let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func email(_ sender: UIButton) {
        self.delegate?.sendEmail()
    }
    
    public func setContent(projectViewModel: ProjectViewModel?) {
        self.projectViewModel = projectViewModel
        self.customerNameLabel.text = projectViewModel?.customerName ?? ""
        self.customerMobileButton.setTitle(projectViewModel?.customerMobile ?? "Not Set", for: .normal)
        self.customerEmailButton.setTitle(projectViewModel?.customerEmail ?? "Not Set", for: .normal)
    }
}
