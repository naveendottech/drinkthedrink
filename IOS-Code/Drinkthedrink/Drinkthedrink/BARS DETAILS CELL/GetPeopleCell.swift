//
//  FollwersCell.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 14/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit

class GetPeopleCell: UITableViewCell {
    
    @IBOutlet  var imgViewFollowers : UIImageView!
    @IBOutlet  var lblName : UILabel!
    @IBOutlet  var btnFollowUnfollow : UIButton!
    @IBOutlet  var btnBlockUnblock   : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
