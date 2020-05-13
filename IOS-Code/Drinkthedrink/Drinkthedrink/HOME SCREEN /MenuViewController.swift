//
//  MenuViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 06/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var btnMenuViewSuperView : UIButton!
//    @IBOutlet var lblStatus : UILabel!
    //@IBOutlet var lblStatus : UILabel!
//    @IBOutlet var txtStatus : UITextView!

    @IBOutlet var lblName : UILabel!
    @IBOutlet var btnFollowUnfollow : UIButton!

    @IBOutlet var btnEditProfileonMenu : UIButton!
    @IBOutlet var lblFollowersCount : UILabel!
    @IBOutlet var lblFollowingCount : UILabel!
    @IBOutlet var btnVisibilityOnMenu : UIButton!
    @IBOutlet var imgVisibilityOnMenu : UIImageView!
    @IBOutlet var btnImgProfile : UIButton!
    @IBOutlet var btnMessagesOnMenu : UIButton!
//    @IBOutlet var btnStatusonMenu : UIButton!
    @IBOutlet  var mainViewSuperView: UIView!
    @IBOutlet  var mainMenuView: UIView!
    @IBOutlet  var menuView: UIView!
    @IBOutlet  var profileView: UIView!
    @IBOutlet  var btnLoginRegisterOrInviteFriends: UIButton!
    @IBOutlet  var btnFeedBack: UIButton!
//    @IBOutlet  var btnChooseLocation: UIButton!
    @IBOutlet  var btnLogout: UIButton!
    @IBOutlet  var btnNotification: UIButton!
    
    @IBOutlet  var btnLogoutHeightConstraint: NSLayoutConstraint!

    @IBOutlet  var profileViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet  var mainViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet  var btnSearchPeopletoEditMessage  : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
