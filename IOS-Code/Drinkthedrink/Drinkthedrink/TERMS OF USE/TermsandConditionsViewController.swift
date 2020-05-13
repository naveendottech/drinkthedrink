//
//  SignUpViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import WebKit

class TermsandConditionsViewController: UIViewController
{

    let savedataInstance = SaveDataClass.sharedInstance
    @IBOutlet  var viewShadow : UIView!
    @IBOutlet  var btncrossonTermsScreen  : UIButton!
    @IBOutlet  var lblTitleTermsScreen  : UILabel!
    var urlTerms  : URL?

    var isTermsScreen : Bool = false
   
    //BAR TENDER VIEW CONSTRAINTS
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    @objc func loadUI()
    {
        RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.viewShadow)
        if isTermsScreen == false
        {
            lblTitleTermsScreen.text = "Privacy Policy"
            urlTerms = URL.init(string: Constant.PRIVACYPOLICYURL)
        }
        else
        {
        lblTitleTermsScreen.text = "Terms of Service"
        urlTerms = URL.init(string: Constant.TERMSOFUSEURL)
        }

    }
    
    @IBAction func crossButtonClicked(_ sender: Any)
    {
        self.view.isHidden = true
    }
    
    }

