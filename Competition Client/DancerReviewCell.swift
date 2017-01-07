//
//  DancerReviewCell.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/6/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

import UIKit

class DancerReviewCell: UITableViewCell {
	@IBOutlet weak var dancerIdLabel : UILabel?
	var dancer : Dancer?
	weak var parentVC : DancerReviewTableViewController?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func editButtonPressed() {
		guard (dancer != nil) else { return }
		parentVC?.editButtonPressed(dancer: dancer!)
	}
}
