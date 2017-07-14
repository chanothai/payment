//
//  StatementTableViewCell.swift
//  payment
//
//  Created by Pakgon on 4/20/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class StatementTableViewCell: UITableViewCell {
    @IBOutlet var imgProfileDetail: UIImageView!
    @IBOutlet var nameDetailLabel: UILabel!
    @IBOutlet var timeDetailLabel: UILabel!
    @IBOutlet var amountDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
