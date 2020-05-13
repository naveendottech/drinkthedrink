//
//  BarDetailsCell.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 26/12/19.
//  Copyright © 2019 Dotttechnologies. All rights reserved.
//

import UIKit
import UberRides

class StoreDetailCell: UITableViewCell
{
    
    @IBOutlet  var collectionViewWhoWorkHereStore : UICollectionView!
    @IBOutlet  var lblWhoWorkHereStore : UILabel!
    @IBOutlet  var collectionViewWhoWorkHereStoreHeightConstraint : NSLayoutConstraint!

    @IBOutlet  var viewDelivery : UIView!
    @IBOutlet  var lblDeliveryCharges  : UILabel!
    
    
        @IBOutlet  var lblWebsiteLink  : UILabel!
        @IBOutlet  var btnFollowUnfollowStore  : UIButton!
        @IBOutlet  var viewFollowStore  : UIView!
    

    
    @IBOutlet  var lblBarName : UILabel!
    @IBOutlet  var txtBarAddress : UILabel!
    @IBOutlet  var lblDistanceandDollars :UILabel!
    @IBOutlet  var txtBarDescriptionFull : UITextView!
    @IBOutlet  var collectionViewBarImages : UICollectionView!
    @IBOutlet  var featuresViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet  var lblFeaturesTopConstraint: NSLayoutConstraint!
    
    @IBOutlet  var tblTodayEventsHeightConstraint: NSLayoutConstraint!
    @IBOutlet  var tblTodayEvents: UITableView!
    @IBOutlet  var lblTodayEvents: UILabel!
    
    @IBOutlet  var tblUpcomingEventsHeightConstraint: NSLayoutConstraint!
     @IBOutlet  var tblUpcomingEvents: IntrinsicTableView!
     @IBOutlet  var lblUpcomingEvents: UILabel!
    

    @IBOutlet  var txtStorePhone : UILabel!
      @IBOutlet  var btnPhoneStore: UIButton!
    
    @IBOutlet  var lblTime: UILabel!

    @IBOutlet  var lblFeaturesEmpty: UILabel!
    @IBOutlet  var lblFeatures: UILabel!

    @IBOutlet  var btnGetDirections: UIButton!

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
