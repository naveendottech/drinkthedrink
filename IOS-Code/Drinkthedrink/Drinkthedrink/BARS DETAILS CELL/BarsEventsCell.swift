//
//  BarsEventsCellTableViewCell.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 30/12/19.
//  Copyright © 2019 Dotttechnologies. All rights reserved.
//

import UIKit

class BarsEventsCell: UITableViewCell {
    
    @IBOutlet  var lblEventDay: UILabel!
    @IBOutlet  var lblEventTime: UILabel!
    @IBOutlet  var lblEventDescription: UILabel!
    @IBOutlet  var lblAppetizers: UILabel!
    @IBOutlet  var imgEvent: UIImageView!
    @IBOutlet  var lblFoodPrice: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
