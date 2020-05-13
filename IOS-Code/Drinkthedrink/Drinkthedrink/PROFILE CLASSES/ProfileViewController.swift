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


class ProfileViewController: UIViewController,WebServiceDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //WHEN USER COME FROM OTHER USER PROFILE
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    var otherUserId : Int = 0
    var isOtherUserProfile : Bool = false
    var otherUserProfileDataObj : OtherUserData?
    var selectedPeopleObj  :PeopleList? // for refrence for messages

    var imageData : NSData? = nil
    var newPickedImage : UIImage? = nil
    var selectedIndexforCocktailImages : Int = 0
    var visibilityValue : Int = 0
    let savedataInstance = SaveDataClass.sharedInstance
    
    @IBOutlet  var mainInnerView: UIView!
    @IBOutlet  var viewShadow: UIView!

    @IBOutlet  var collectionViewSuperView: UIView!
    @IBOutlet  var btnMessages:  UIButton!
    @IBOutlet  var viewOtherUserMessages:  UIView!

    @IBOutlet  var collectionViewProfileImages: UICollectionView!
    @IBOutlet  var heightConstraintforcollectionViewImages: NSLayoutConstraint!
    @IBOutlet  var heightConstraintforbtnEditprofile: NSLayoutConstraint!

    @IBOutlet  var btnFollowingFollowerOnProfileScreen: UIButton!
    
    @IBOutlet  var imgCircleVisibilityOtherUser: UIImageView!

    @IBOutlet  var lblvisibilityorOnlineMYUSER: UILabel!
    @IBOutlet  var lblvisibilityorOnlineOTHERUSER: UILabel!


    @IBOutlet  var lblPhoneTopConstraint: NSLayoutConstraint!

    @IBOutlet  var lblAddressTopConstraint: NSLayoutConstraint!
    @IBOutlet  var lblAddressbottomConstraint: NSLayoutConstraint!//works for both bar address bottom and top ?
    @IBOutlet  var lblBarNamebottomConstraint: NSLayoutConstraint!
    @IBOutlet  var imgVisibilityStatus: UIImageView!
    @IBOutlet  var btnVisibilityOnProfileScreen: UIButton!
    @IBOutlet  var btnonmainProfileViewSuperView: UIButton!
    @IBOutlet  var mainProfileViewSuperView: UIView!
    @IBOutlet  var scrollViewforProfile: UIView!
    @IBOutlet  var btnCrossProfile: UIButton!
    @IBOutlet  var btnImgProfile: UIButton!
    @IBOutlet  var btnEditProfile: UIButton!
    @IBOutlet  var lblFollowing      : UILabel!
    @IBOutlet  var lblFollowers      : UILabel!
    @IBOutlet  var lblUsername    : UILabel!
    @IBOutlet  var lblEmail      : UILabel!
    @IBOutlet  var lblPhone     : UILabel!
    @IBOutlet  var lblCounrty   : UILabel!
    @IBOutlet  var lblWorksAt  : UILabel!
    @IBOutlet  var lblState  : UILabel!
    @IBOutlet  var lblCity  : UILabel!

//    @IBOutlet  var lblFavDrink  : UILabel!
//    @IBOutlet  var lblFavSpirit  : UILabel!
//    @IBOutlet  var lblFavCocktail  : UILabel!
//    @IBOutlet  var lblFavLiquir  : UILabel!

//    var roleArray = NSArray()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    func setUpProfileDetails()
       {
        RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.viewShadow)

        if isOtherUserProfile == true
        {
            self.getOtherUserProfileAPI()
            
        }
        else
        {
        self.getMyProfileandUpdateData()
        collectionViewProfileImages.isUserInteractionEnabled = true
            
        lblUsername.text = (savedataInstance.username as? String)?.uppercased()
        lblEmail.text = (savedataInstance.email as? String)?.uppercased()
        lblPhone.text = (savedataInstance.phone as? String)?.uppercased()
        if lblPhone.text?.isEmpty == true
        {
        lblPhoneTopConstraint.constant = 0.0
        }
        else
        {
        lblPhoneTopConstraint.constant = 10.0
        }
       
        if  self.savedataInstance.follow_by  != nil
        {
            lblFollowers.text = "\(savedataInstance.follow_by!)"
        }
        else
        {
            lblFollowers.text = "0"
        }
       
        if  self.savedataInstance.follow_to != nil
        {
        lblFollowing.text = "\(savedataInstance.follow_to!)"
        }
        else
        {
        lblFollowing.text = "0"
        }
        if savedataInstance.visibility_status != nil{
       
        if  "\(savedataInstance.visibility_status!)" == "1"
        {
        visibilityValue = 1
        imgVisibilityStatus.image = UIImage.init(named: "NEWON")
       
            btnImgProfile.layer.borderColor = Constant.THEME_DARK_GREEN_COLOR.cgColor
            btnImgProfile.layer.borderWidth = 3.0
        }
        else
        {
       
        btnImgProfile.layer.borderColor = UIColor.clear.cgColor
            btnImgProfile.layer.borderWidth = 0.0
        visibilityValue = 0
        imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
        }
        }
        else
        {
             visibilityValue = 0
             imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
         }
       
         print("\(savedataInstance.role ?? "")" == "7")


            if "\(savedataInstance.country ?? "")".isEmpty == false
            {
                lblCounrty.text = "COUNTRY : \(savedataInstance.country!)"
            }
            else{
                lblCounrty.text = "COUNTRY : "
            }
            
            if "\(savedataInstance.state ?? "")".isEmpty == false
            {
               lblState.text = "STATE : \(savedataInstance.state!)"
            }
            else{
                lblState.text = "STATE : "
            }
            
            if "\(savedataInstance.city ?? "")".isEmpty == false
            {
                lblCity.text = "CITY : \(savedataInstance.city!)"
            }
            else{
                lblCity.text = "CITY : "
            }
            
//
//
//            if "\(savedataInstance.state ?? "")".isEmpty == false
//            {
//
//                if addressStr.isEmpty == false{
//
//                addressStr = "\(addressStr)" + ", \(savedataInstance.state ?? "")"
//                }
//                else
//                {
//                    addressStr = "\(savedataInstance.state ?? "")"
//                }
//            }
//
//            if "\(savedataInstance.city ?? "")".isEmpty == false
//            {
//                if addressStr.isEmpty == false
//                {
//                addressStr = "\(addressStr)" + ", \(savedataInstance.city ?? "")"
//                }
//                else
//                {
//                    addressStr = "\(salvedataInstance.city ?? "")"
//                }
//
//            }
//
//
//            if addressStr.isEmpty == false
//            {
//              lblAddress.text = addressStr
//              lblAddressTopConstraint.constant = 10.0
//              lblAddressbottomConstraint.constant = 10.0
//              lblBarNamebottomConstraint.constant = 10.0
//           }
//           else
//           {
//                lblAddress.text = ""
//               lblAddressTopConstraint.constant    = 0.0
//               lblBarNamebottomConstraint.constant = 0.0
//           }
           
            if RandomObjects.checkValueisNilorNull(value: savedataInstance.work_at) == false
            {
                
                 if  "\(savedataInstance.role!)" == "7"{
                
                    lblWorksAt.text = "WORKS AT : \(savedataInstance.bar_name! )".uppercased()
                }
                else if "\(savedataInstance.role!)" == "8"
                {
                    lblWorksAt.text = "WORKS AT : \(savedataInstance.store_name! )".uppercased()

                }
            }
            else
            {
            lblWorksAt.text = "WORKS AT : NA"
            }
                

            if  "\(savedataInstance.role ?? "")" == "7" || "\(savedataInstance.role ?? "")" == "8"
            {
                
            }
            else
            {
                lblWorksAt.text = ""
                lblBarNamebottomConstraint.constant = 0.0
            }
            
//            }
//            else
//            {
//                lblAddress.text = ""
//                lblWorksAt.text = ""
//                print("need to show bar name and address")
//                lblAddressTopConstraint.constant    = 0.0
//
//            }
            
            
            
            

//      if   RandomObjects.checkValueisNilorNull(value: savedataInstance.fav_drink) == false
//           {
//
//           lblFavDrink.text = "FAVOURITE DRINK : " + (savedataInstance.fav_drink as! String).uppercased()
//           }
//           else
//           {
//               lblFavDrink.text = "FAVOURITE DRINK :"
//           }
//        if RandomObjects.checkValueisNilorNull(value: savedataInstance.fav_cocktail) == false
//          {
//                   lblFavCocktail.text = "FAVOURITE COCKTAIL : " + (savedataInstance.fav_cocktail as! String).uppercased()
//          }
//          else
//          {
//              lblFavCocktail.text = "FAVOURITE COCKTAIL :"
//          }

//            if RandomObjects.checkValueisNilorNull(value: savedataInstance.fav_alcohol) == false
//                {
//                   lblFavSpirit.text = "FAVOURITE SPIRIT : " + (savedataInstance.fav_alcohol as! String).uppercased()
//                }
//                else
//                {
//                   lblFavSpirit.text = "FAVOURITE SPIRIT :"
//               }
            
//            if RandomObjects.checkValueisNilorNull(value: savedataInstance.fav_alcohol) == false
//            {
//                lblFavAlcohal.text = "FAVOURITE ALCOHOL : " + (savedataInstance.fav_alcohol as! String).uppercased()
//            }
//            else
//            {
//                lblFavAlcohal.text = "FAVOURITE ALCOHOL :"
//            }
            
            
            
//      if RandomObjects.checkValueisNilorNull(value: savedataInstance.fav_liquor) == false
//      {
//          lblFavLiquir.text = "FAVOURITE LIQUOR : " + (savedataInstance.fav_liquor as! String).uppercased()
//      }
//      else
//      {
//      lblFavLiquir.text = "FAVOURITE LIQUOR :"
//      }
            
    print(savedataInstance.getUserDetails()!)
             
               let imgStr: String = RandomObjects.getUserOwnProfileImageStr()
               btnImgProfile.contentMode = .scaleToFill
               btnImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //set placeholder PENDING HB
               btnImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
               btnImgProfile.sd_setImage(with: URL.init(string: imgStr), for: .normal, placeholderImage: UIImage.init(named: "profileplaceholder"), options: .highPriority)
              
               btnImgProfile.layer.cornerRadius = btnImgProfile.frame.size.width / 2
               btnImgProfile.layer.masksToBounds = true
               btnImgProfile.clipsToBounds = true
               collectionViewProfileImages.dataSource = self
               collectionViewProfileImages.delegate = self
               collectionViewProfileImages.reloadData()
        }
        self.enableDisableUserInteractions()
       }
    
    func setOtherUserProfileDetails()
    {
        if (otherUserProfileDataObj!.username as? String)?.uppercased().isEmpty == true
        {
        lblUsername.text = (otherUserProfileDataObj!.name as? String)?.uppercased()
        }
        else
        {
        lblUsername.text = (otherUserProfileDataObj!.username as? String)?.uppercased()
        }
        
        
//        if RandomObjects.checkValueisNilorNull(value: otherUserProfileDataObj?.fav_liquor) == false
//        {
//            lblFavLiquir.text = "FAVOURITE LIQUOR : " + (otherUserProfileDataObj?.fav_liquor as! String).uppercased()
//        }
//        else
//        {
//        lblFavLiquir.text = "FAVOURITE LIQUOR :"
//        }
        
        
//        if RandomObjects.checkValueisNilorNull(value: otherUserProfileDataObj?.fav_alcohol) == false
//              {
//                  lblFavAlcohal.text = "FAVOURITE ALCOHAL : " + (otherUserProfileDataObj?.fav_alcohol as! String).uppercased()
//              }
//              else
//              {
//              lblFavAlcohal.text = "FAVOURITE ALCOHAL :"
//              }
              
        
//        lblCounrty.text
        if "\(otherUserProfileDataObj!.country ?? "")".isEmpty == false
        {
            lblCounrty.text = "COUNTRY : \(savedataInstance.country!)"
        }
        else{
            lblCounrty.text = "COUNTRY : "
        }
        
        if "\(otherUserProfileDataObj!.state ?? "")".isEmpty == false
        {
            lblState.text = "STATE : \(savedataInstance.state!)"
        }
        else{
            lblState.text = "STATE : "
        }
        
        if "\(otherUserProfileDataObj!.city ?? "")".isEmpty == false
        {
            lblCity.text = "CITY : \(savedataInstance.city!)"
        }
        else{
            lblCity.text = "CITY : "
        }
        
        lblEmail.text = (otherUserProfileDataObj!.email as? String)?.uppercased()
        lblPhone.text = (otherUserProfileDataObj!.phone as? String)?.uppercased()
        
        if lblPhone.text?.isEmpty == true
        {
        lblPhoneTopConstraint.constant = 0.0
        }
        else
        {
        lblPhoneTopConstraint.constant = 10.0
        }
        
        if  self.otherUserProfileDataObj?.follow_by  != nil
        {
            lblFollowers.text = "\(otherUserProfileDataObj?.follow_by! ?? "0")"
        }
        else
        {
            lblFollowers.text = "0"
        }
        
        if  self.otherUserProfileDataObj?.follow_to != nil
        {
            lblFollowing.text = "\(otherUserProfileDataObj?.follow_to! ?? "0")"
        }
        else
        {
        lblFollowing.text = "0"
        }
        if otherUserProfileDataObj?.visibility_status != nil
        {
        
            if  "\(otherUserProfileDataObj?.visibility_status! ?? "")" == "1"
        {
        visibilityValue = 1
        imgVisibilityStatus.image = UIImage.init(named: "NEWON")
            
            btnImgProfile.layer.borderColor = Constant.THEME_DARK_GREEN_COLOR.cgColor
            btnImgProfile.layer.borderWidth = 3.0
            
            lblvisibilityorOnlineOTHERUSER.text = "ONLINE"
            imgCircleVisibilityOtherUser.isHidden = false
            
        }
        else
        {
        imgCircleVisibilityOtherUser.isHidden = true
        lblvisibilityorOnlineOTHERUSER.text = "OFFLINE"
        btnImgProfile.layer.borderColor = UIColor.clear.cgColor
            btnImgProfile.layer.borderWidth = 0.0
        visibilityValue = 0
        imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
        }
        }
        else
        {
            imgCircleVisibilityOtherUser.isHidden = true
            visibilityValue = 0
            imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
            lblvisibilityorOnlineOTHERUSER.text = "OFFLINE"
        }
        
  
        
        let imgStr: String = RandomObjects.getOtherUserProfileImage(imgStrName: otherUserProfileDataObj?.profile_image as! String)
        
           btnImgProfile.contentMode = .scaleToFill
           btnImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //set placeholder PENDING HB
           btnImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
           btnImgProfile.sd_setImage(with: URL.init(string: imgStr), for: .normal, placeholderImage: UIImage.init(named: "profileplaceholder"), options: .highPriority)
          
           btnImgProfile.layer.cornerRadius = btnImgProfile.frame.size.width / 2
           btnImgProfile.layer.masksToBounds = true
           btnImgProfile.clipsToBounds = true
           collectionViewProfileImages.dataSource = self
           collectionViewProfileImages.delegate = self
           collectionViewProfileImages.reloadData()
          

    }
    
    
    //OTHER USER PROFILE USER CAN NOT INTERACT WITH FOLLOW, VISIBILITY AND COLLECTION VIEW SELECTION
    func enableDisableUserInteractions(){
        
        if isOtherUserProfile == true
        {
        heightConstraintforbtnEditprofile.constant = 0.0
        self.imgVisibilityStatus.isHidden = true
        self.viewOtherUserMessages.isHidden = false
        self.btnEditProfile.isHidden = true
        self.collectionViewSuperView.isHidden = true
    self.btnFollowingFollowerOnProfileScreen.isUserInteractionEnabled = false
     self.btnVisibilityOnProfileScreen.isUserInteractionEnabled = false
            
        }
        else
        {
        self.viewOtherUserMessages.isHidden = true
        heightConstraintforbtnEditprofile.constant = 30.0
        self.imgVisibilityStatus.isHidden = false
        self.btnEditProfile.isHidden = false
        self.collectionViewSuperView.isHidden = false
    self.btnFollowingFollowerOnProfileScreen.isUserInteractionEnabled = true
            
    self.btnVisibilityOnProfileScreen.isUserInteractionEnabled = true
            
        }
        
    }
        
    func getMyProfileandUpdateData()
        {
            let params = NSMutableDictionary()
            params.setValue(savedataInstance.id!, forKey: "user_id")
            print("params for otheruserprofile api \(params)")
                 
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                     break
                     // Show alert if internet not available.
                     //show alert
                 default:
                    
                ApiManager.sharedManager.delegate = self
                SVProgressHUD.show(withStatus: "Fetching Profile data...")
            ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.GETOTHERUSERPROFILEAPI as NSString,currentView: self.view)
                 }
             }
    
    
    func getOtherUserProfileAPI()
        {
            let params = NSMutableDictionary()
            params.setValue(otherUserId, forKey: "user_id")
            print("params for otheruserprofile api \(params)")
                 
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                     break
                     // Show alert if internet not available.
                     //show alert
                 default:
                    
                ApiManager.sharedManager.delegate = self
                SVProgressHUD.show(withStatus: "Fetching Profile data...")
            ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.GETOTHERUSERPROFILEAPI as NSString,currentView: self.view)
                 }
             }
    
    
    @IBAction func visibilityButtonClicked(_ sender: Any)
    {
        self.view.endEditing(true)
        if (imgVisibilityStatus.image?.isEqual(UIImage.init(named: "NEWOFF")))!
        {
        self.setVisiBilityApi(value: 1)
                    visibilityValue = 1
        }
        else
        {
        visibilityValue = 0
        self.setVisiBilityApi(value: 0)
        }
    }
    
            //MARK:-  getBarsApi
    func setVisiBilityApi(value: Int)
    {
        let params = NSMutableDictionary()
        params.setValue(savedataInstance.id, forKey: "id")
//        params.setValue(11897, forKey: "id")
        params.setValue("\(value)", forKey: "visibility_status")
        params.setValue("public", forKey: "visible_for")
        
        
//        RED
        
        if  appdelegate.selectedLatitude! != 0.0
        {

    params.setValue(appdelegate.selectedLatitude, forKey: "user_latitude")
            
    params.setValue(appdelegate.selectedLongitude, forKey: "user_longitude")
            
        }
        else
        {
            
    params.setValue(RandomObjects.getLatitude(), forKey: "user_latitude")
            
    params.setValue(RandomObjects.getLongitude(), forKey: "user_longitude")
            
        }
        
        print("params for get bars api \(params)")
             
         let status = Reach().connectionStatus()
         switch status {
         case .unknown, .offline:
                 SVProgressHUD.dismiss()
                 SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                 break
                 // Show alert if internet not available.
                 //show alert
             default:
                
                 ApiManager.sharedManager.delegate = self
                  SVProgressHUD.show(withStatus: "Updating Visibility...")
                 ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.updateVisibilityApi as NSString,currentView: self.view)
             }
         }
    
    
        func setSaveDataDetails(jsonDictionary: NSDictionary?)
        {
  self.savedataInstance.saveUserDetails(userdataDict: jsonDictionary!["data"] as! NSDictionary)
        
        }
    
    
            //MARK:- SUCESS RESPONSE
        func serverReponse(responseData: Data?, serviceurl: NSString)
        {
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                do {
                    
        if serviceurl as String == Constant.updateVisibilityApi
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                
                
            if (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "message") is NSArray
            {
                print("is array")
            SVProgressHUD.showSuccess(withStatus: (((jsonDictionary["data"] as! NSDictionary).value(forKey: "message") as! NSArray).object(at: 0) as! String))
            }
            else if (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "message") is String
            {
                SVProgressHUD.showSuccess(withStatus: ((jsonDictionary["data"] as! NSDictionary).value(forKey: "message") as! String))
                print("is isString")
            }
                           
                
                var userDetailDict = NSMutableDictionary()
                userDetailDict = self.savedataInstance.getUserDetails()?.mutableCopy() as! NSMutableDictionary
                
                print("user details dict is \(userDetailDict)")
                if self.visibilityValue == 1
                    {
                        self.imgVisibilityStatus.image = UIImage.init(named: "NEWON")
                    userDetailDict.setValue(1, forKey: "visibility_status")
                    }
                else
                    {
                        self.imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
                        
                    userDetailDict.setValue(0, forKey: "visibility_status")
                    }
            self.savedataInstance.saveUserDetails(userdataDict: userDetailDict)
                        
            }
            else
            {
        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )

           print("error in visibility api")
                
              }
        }
       else if serviceurl as String == Constant.GETOTHERUSERPROFILEAPI
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                                       
            print("JSON RESPONSE for GET OTHER USER PROFILE API = \(jsonDictionary)")
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                
        if jsonDictionary.value(forKey: "data") != nil
        {
            
            
            if self.isOtherUserProfile == true {
                    
            let dict = jsonDictionary["data"] as! NSDictionary
                if self.otherUserProfileDataObj != nil
                {
                self.otherUserProfileDataObj = nil
                }
                    self.otherUserProfileDataObj = OtherUserData.init(
                        fav_alcohol: dict["fav_alcohol"],
                        fav_liquor:  dict["fav_liquor"],
                        work_at: dict["work_at"],
                        role: dict["role"],
                        address: dict["address"],
                        api_token: dict["api_token"],
                        city: dict["city"],
                        country: dict["country"],
                        device_token: dict["device_token"],
                        drink_image_1: dict["drink_image_1"],
                        drink_image_2: dict["drink_image_2"],
                        drink_image_3: dict["drink_image_3"],
                drinks_folder_name: dict["drinks_folder_name"],
                        email: dict["email"],
                        fav_cocktail: dict["fav_cocktail"],
                        fav_drink: dict["fav_drink"],
                        fav_spirit: dict["fav_spirit"],
                        follow_by: dict["follow_by"],
                        follow_to: dict["follow_to"],
                        message: dict["message"],
                        my_status: dict["my_status"],
                        name: dict["name"],
                        phone: dict["phone"],
            profile_folder_name: dict["profile_folder_name"],
                        profile_image: dict["profile_image"],
                        state: dict["state"],
                        user_latitude: dict["user_latitude"],
                        user_longitude: dict["user_longitude"],
                        username: dict["username"],
            visibility_status: dict["visibility_status"],
                        visible_bar: dict["visible_bar"],
                        visible_for: dict["visible_for"])
                    
                    self.setOtherUserProfileDetails()
            }
            else
            {
                self.setSaveDataDetails(jsonDictionary: jsonDictionary)
            }
            }
            }
           else
           {
         RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )

          print("error in visibility api")
             }
                
            }
                    
                }catch let _error {
                    print(_error)
                }
             }
        }
    
//MARK:- ERROR RESPONSE
    func failureRsponseError(failureError: NSError?, serviceurl: NSString) {
    }
   

       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CocktailImagesCell", for: indexPath) as! CocktailImagesCell
        
        var imgStr : String = ""
        
        if indexPath.item == 0
        {
            if isOtherUserProfile == true {
            
            if (otherUserProfileDataObj?.drink_image_1 as? String)?.isEmpty == false
            {
                imgStr  = Constant.cocktailImagesBaseUrl + (otherUserProfileDataObj?.drink_image_1 as? String)!
            }
            }
            else
            {
            if (savedataInstance.drink_image_1 as? String)?.isEmpty == false
            {
            imgStr  = Constant.cocktailImagesBaseUrl + (savedataInstance.drink_image_1 as? String)!
            }
                
            }
         
        }
        else  if indexPath.item == 1
        {
            if isOtherUserProfile == true {

            
        if (otherUserProfileDataObj?.drink_image_2 as? String)?.isEmpty == false
            {
       imgStr  = Constant.cocktailImagesBaseUrl + (otherUserProfileDataObj?.drink_image_2 as? String)!
            }
            }
            else{
                
            if (savedataInstance.drink_image_2 as? String)?.isEmpty == false
            {
                imgStr  = Constant.cocktailImagesBaseUrl + (savedataInstance.drink_image_2 as? String)!
            }
            }
            
        }
        else if  indexPath.item == 2
        {
            
        if isOtherUserProfile == true {

        if (otherUserProfileDataObj?.drink_image_3 as? String)?.isEmpty == false
        {
        imgStr  = Constant.cocktailImagesBaseUrl + (otherUserProfileDataObj?.drink_image_3 as? String)!
        }
            }
            else
            {
                if (savedataInstance.drink_image_3 as? String)?.isEmpty == false
                {
                imgStr  = Constant.cocktailImagesBaseUrl + (savedataInstance.drink_image_3 as? String)!
                }
            }
            
        }
        
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)
        
        cell.imgBars.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        print("image str is +\(imgStr)")
        
        cell.btnDeleteCockTailImage.tag = indexPath.item
        
        if imgStr.isEmpty == true
        {
            cell.btnDeleteCockTailImage.isHidden = true
        }
        else
        {
            cell.btnDeleteCockTailImage.isHidden = false
        }
        cell.btnDeleteCockTailImage.addTarget(self, action: #selector(deleteCocktailPhotosAction(_:)), for: .touchUpInside)

        cell.imgBars.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "bigPlusImg"))
        
        if imgStr.isEmpty == true
        {
        cell.imgBars.contentMode = .scaleAspectFit
            cell.imgBars.layer.borderColor = UIColor.lightGray.cgColor
            cell.imgBars.layer.borderWidth = 1.0
        }
        else
        {
            cell.imgBars.layer.borderColor = UIColor.clear.cgColor
            cell.imgBars.layer.borderWidth = 0.0
        cell.imgBars.contentMode = .scaleToFill
        }
        return cell
    }
    
    //MARK:- DELETE COCKTAIL PHOTOS

    @objc  func deleteCocktailPhotosAction(_ sender: UIButton)
    {
        selectedIndexforCocktailImages = sender.tag
        
            self.view.endEditing(true)
            let alert = UIAlertController(title: "Delete image", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
    
                self.deleteCockTailImagesApi()

            }))

            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { _ in
                
            }))


            self.present(alert, animated: true, completion: nil)
            
            
            
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
    heightConstraintforcollectionViewImages.constant = ((collectionView.frame.size.width - 40) / 3)
        
    return CGSize.init(width: ((collectionView.frame.size.width - 40) / 3)   , height: ((collectionView.frame.size.width - 40) / 3) )
  
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedIndexforCocktailImages = indexPath.item
        
        self.addCockTailImages()
    }
    
   func addCockTailImages()
    {
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
    }))

    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
    self.openGallery()
    }))

    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
//        alert.BOUND
//        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceView = self.view
    alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)

    self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
      {
        
        if let pickedImage = info[.originalImage] as? UIImage
        {
            
         newPickedImage = RandomObjects.resizeImage(image: pickedImage, targetSize: CGSize.init(width: 300, height: 300))
                        
        imageData = newPickedImage!.jpegData(compressionQuality: 0.4) as NSData?
                                                                        
            // imageViewPic.contentMode = .scaleToFill
            self.updateCockTailImagesAPI()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
        //MARK:- DELETE COCKTAIL PHOTOS API
            func deleteCockTailImagesApi()
            {
                let params = NSMutableDictionary()

                var drink_image :String = ""
                
                if selectedIndexforCocktailImages == 0{
                    drink_image = "drink_image_1"

                }
                else if selectedIndexforCocktailImages == 1
                {
                    drink_image = "drink_image_2"

                }
                else if  selectedIndexforCocktailImages == 2
                {
                    drink_image = "drink_image_3"
                }
                
                params.setValue(drink_image, forKey: "drink_image")
                params.setValue("placeholder", forKey: "placeholder")
                
                
            let manager: AFHTTPSessionManager = AFHTTPSessionManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
                
            let urlStr : String = "\(Constant.baseUrl)\(Constant.updateCocktailImagesAPI)"
                
                        
            params.setValue(savedataInstance.id, forKey: "id")
            params.setValue(savedataInstance.token, forKey: "token")
     
                print("params for delete image api \(params)")
                       
            let request: NSMutableURLRequest = manager.requestSerializer.multipartFormRequest(withMethod: "POST"
                    , urlString: urlStr, parameters: params as? [String : AnyObject], constructingBodyWith: {(formData: AFMultipartFormData!) -> Void in
                        
                      
                        
                    }, error: nil)
                
                manager.dataTask(with: request as URLRequest) { (response, responseObject, error) -> Void in

                    if((error == nil)) {
                        
                        if ((responseObject as! NSDictionary).value(forKey: "status") as! Bool) == true
                        {
                            
                            print("Response for images is here\(responseObject)")
                            let  drink_image_1 : String? = ((responseObject as! NSDictionary).value(forKey: "data") as? NSDictionary)!.value(forKey: "drink_image_1") as? String
                            
                            let  drink_image_2 : String? = ((responseObject as? NSDictionary)!.value(forKey: "data") as? NSDictionary)!.value(forKey: "drink_image_2") as? String
                            
                            let  drink_image_3 : String? = ((responseObject as? NSDictionary)!.value(forKey: "data") as? NSDictionary)!.value(forKey: "drink_image_3") as? String
                            
                            
        var userDetailDict = NSMutableDictionary()
                            
                            
        userDetailDict = self.savedataInstance.getUserDetails()?.mutableCopy() as! NSMutableDictionary
                                      
                            userDetailDict.setValue(drink_image_1, forKey: "drink_image_1")
                            userDetailDict.setValue(drink_image_2, forKey: "drink_image_2")
                            userDetailDict.setValue(drink_image_3, forKey: "drink_image_3")

                            self.savedataInstance.saveUserDetails(userdataDict: userDetailDict)
                            self.collectionViewProfileImages.reloadData()
                                      
      
        SVProgressHUD.dismiss()
                            
        SVProgressHUD.showSuccess(withStatus: "Image Deleted Successfully.")
                            
        }
        else
        {
        RandomObjects.showErrorNow(jsonDictionary:responseObject as! NSDictionary )
        }
                        
        }
        else {
                        
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Something went wrong!!!")
            }

            }.resume()
                
            }
    
        //MARK:- UPDATE COCKTAIL IMAGES API ADD OPTION
        func updateCockTailImagesAPI()
        {
            let params = NSMutableDictionary()

            var drink_image :String = ""
            
            if selectedIndexforCocktailImages == 0{
                drink_image = "drink_image_1"

            }
            else if selectedIndexforCocktailImages == 1
            {
                drink_image = "drink_image_2"

            }
            else if  selectedIndexforCocktailImages == 2
            {
                drink_image = "drink_image_3"
            }
            
            params.setValue(drink_image, forKey: "drink_image")
            
            
            
        let manager: AFHTTPSessionManager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
            
        let urlStr : String = "\(Constant.baseUrl)\(Constant.updateCocktailImagesAPI)"
            
                    
        params.setValue(savedataInstance.id, forKey: "id")
        params.setValue(savedataInstance.token, forKey: "token")
 
                   
        let request: NSMutableURLRequest = manager.requestSerializer.multipartFormRequest(withMethod: "POST"
                , urlString: urlStr, parameters: params as? [String : AnyObject], constructingBodyWith: {(formData: AFMultipartFormData!) -> Void in
                    
                    if self.imageData != nil
                    {
                        formData.appendPart(withFileData: self.imageData! as Data, name: "cocktail_image", fileName: "cocktail_image.jpg", mimeType: "image/jpeg")
                    }
                    
                }, error: nil)
            
            manager.dataTask(with: request as URLRequest) { (response, responseObject, error) -> Void in

                if((error == nil)) {
                    
                    if ((responseObject as! NSDictionary).value(forKey: "status") as! Bool) == true
                    {
                        
                        print("Response for images is here\(responseObject)")
                        let  drink_image_1 : String? = ((responseObject as! NSDictionary).value(forKey: "data") as? NSDictionary)!.value(forKey: "drink_image_1") as? String
                        
                        let  drink_image_2 : String? = ((responseObject as? NSDictionary)!.value(forKey: "data") as? NSDictionary)!.value(forKey: "drink_image_2") as? String
                        
                        let  drink_image_3 : String? = ((responseObject as? NSDictionary)!.value(forKey: "data") as? NSDictionary)!.value(forKey: "drink_image_3") as? String
                        
                        
                        var userDetailDict = NSMutableDictionary()
                        
                        
                        userDetailDict = self.savedataInstance.getUserDetails()?.mutableCopy() as! NSMutableDictionary
                                  
                        userDetailDict.setValue(drink_image_1, forKey: "drink_image_1")
                        userDetailDict.setValue(drink_image_2, forKey: "drink_image_2")
                        userDetailDict.setValue(drink_image_3, forKey: "drink_image_3")

                        self.savedataInstance.saveUserDetails(userdataDict: userDetailDict)
                        self.collectionViewProfileImages.reloadData()

                                  
    SVProgressHUD.dismiss()
                        
    SVProgressHUD.showSuccess(withStatus: "Image Updated Successfully.")
                        
    }
    else
    {
    RandomObjects.showErrorNow(jsonDictionary:responseObject as! NSDictionary )
    }
                    
    }
    else {
                    
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "Something went wrong!!!")
        }

        print(responseObject)
        }.resume()
            
        }
    
}
