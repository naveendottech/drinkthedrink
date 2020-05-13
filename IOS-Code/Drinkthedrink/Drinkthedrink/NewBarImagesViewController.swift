//
//  LoginViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewBarImagesViewController: UIViewController,UITextViewDelegate
{


    //CURRENT SELECTED INDEX FOR BAR AND STORE IMAGES :
      var indexofSelectedBarandStoreImage: Int = 0

    //LEFT ARROW
    @IBOutlet  var btnLeftArrowOnnewBarImages: UIButton!
    //RIGHT ARROW
    @IBOutlet  var btnRightArrowOnnewBarImages: UIButton!
    //SAVE DTA OBJECT FOR USER INFO
    let savedataInstance = SaveDataClass.sharedInstance
    //MAIN VIEW CONTAINING COLLECTION VIEW
    @IBOutlet  var mainSuperViewNewBarImages: UIView!
    
    @IBOutlet  var btnCrossOnNewImagesViewController: UIButton!
    @IBOutlet  var collectionViewBarImagesNew: UICollectionView!
    
    override func viewDidLoad()
    {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadUI()
    {
    print("came in")
    }
    
    //MARK:-  SEND FEEDBACK API HIT
    
    
    

   

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}





//class UserData {
//    let email: Any?
//    let follow_by: Any?
//    let follow_to: Any?
//    let id: Any?
//    let message: Any?
//    let my_status: Any?
//    let name: Any?
//    let phone: Any?
//    let profile_image: Any?
//    let role: Any?
//    let role_name: Any?
//    let token: Any?
//    let username: Any?
//    let visibility_status: Any?
//    init(email : Any?,follow_by:Any?, follow_to: Any?, id: Any? , message : Any? , my_status : Any? , name: Any? , phone:Any? , profile_image : Any?,role : Any?,role_name : Any? ,token : Any?,username : Any?,visibility_status : Any? )
//    {
//        self.email = email
//        self.follow_by = follow_by
//        self.follow_to = follow_to
//        self.id = id
//        self.message = message
//        self.my_status = my_status
//        self.name = name
//        self.phone = phone
//        self.profile_image = profile_image
//        self.role = role
//        self.role_name = role_name
//        self.token = token
//        self.username = username
//        self.visibility_status = visibility_status
//    }
//}

