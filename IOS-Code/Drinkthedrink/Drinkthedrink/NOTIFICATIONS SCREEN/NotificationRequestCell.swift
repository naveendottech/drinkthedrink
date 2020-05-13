//
//  FollwersCell.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 14/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit

class NotificationRequestCell: UITableViewCell {
    @IBOutlet  var heightConstraintOfButtonAccept: NSLayoutConstraint!
    @IBOutlet  var lblStatus : UILabel!
    @IBOutlet  var heightConstraintOfStatusLabel: NSLayoutConstraint!


    @IBOutlet  var imgViewUser : UIImageView!
    @IBOutlet  var lblMessage : UILabel!
    @IBOutlet  var btnAccept : UIButton!
    @IBOutlet  var btnDecline : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
