//
//  PackageListTableViewCell.swift
//  Package Tracker
//
//  Created by Sean Ogden Power on 16/6/18.
//  Copyright © 2018 Sean Ogden Power. All rights reserved.
//

import UIKit

class PackageListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
