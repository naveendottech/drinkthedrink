//
//  BarDetailsCell.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 26/12/19.
//  Copyright © 2019 Dotttechnologies. All rights reserved.
//

import UIKit
import UberRides

class BarDetailsCell: UITableViewCell {
    
    @IBOutlet  var btnFollowUnfollowBar : UIButton!
    @IBOutlet  var viewFollowBar  : UIView!
    @IBOutlet  var lblWebsiteLink  : UILabel!

    
    @IBOutlet  var lblBarName : UILabel!
    @IBOutlet  var txtBarAddress : UILabel!
    @IBOutlet  var txtBarPhone : UILabel!
    

    @IBOutlet  var lblDistanceandDollars :UILabel!
    @IBOutlet  var txtBarDescriptionFull : UITextView!
    @IBOutlet  var collectionViewBarImages : UICollectionView!
    @IBOutlet  var lblEmptySpecial : UILabel!
    
    @IBOutlet  var featuresViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet  var lblFeaturesTopConstraint: NSLayoutConstraint!

    
    @IBOutlet  var tblTodayEventsHeightConstraint: NSLayoutConstraint!
    @IBOutlet  var tblTodayEvents: UITableView!
    @IBOutlet  var lblTodayEvents: UILabel!
    
    @IBOutlet  var tblUpcomingEventsHeightConstraint: NSLayoutConstraint!
     @IBOutlet  var tblUpcomingEvents: IntrinsicTableView!
     @IBOutlet  var lblUpcomingEvents: UILabel!
    @IBOutlet  var btnPhoneBars: UIButton!

    
    @IBOutlet  var collectionViewWorkHere: UICollectionView!
    @IBOutlet  var lblWhoWorkHere: UILabel!
    @IBOutlet  var collectionViewWorkHereHeightConstraint: NSLayoutConstraint!

    
    @IBOutlet  var lblTime: UILabel!

    @IBOutlet  var lblFeaturesEmpty: UILabel!
    @IBOutlet  var lblFeatures: UILabel!

    @IBOutlet  var btnGetDirections: UIButton!
    @IBOutlet  var btnGetDirectionsUpside: UIButton!

    @IBOutlet  var btnUber: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
