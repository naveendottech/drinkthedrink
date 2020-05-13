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

class EditProfileViewController: UIViewController,WebServiceDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate
{
        var cityArray = NSMutableArray()
        var filteredCityArray = NSMutableArray()
        @IBOutlet  var citySelectionSuperView: UIView!
        @IBOutlet  var cityTableView: UITableView!
    
        var isAnythingChanged : Bool = false

        var favSpiritArray = NSArray()
        var selectedfavSpiritIndex: Int = 0

    //MARK:- VARIABLES

        var imageData : NSData? = nil
        let savedataInstance = SaveDataClass.sharedInstance
    //role values
        var rolePickerView = UIPickerView()
        var selectedRoleTypeIndex : Int = 0
        var roleArray = NSArray()
    
    //country values
        var countryArray = NSArray()
        var countryPickerView = UIPickerView()
        var selectedCountryIndex : Int = 0
    
    //state values
        var statePickerView = UIPickerView()
        var selectedStateIndex : Int = 0
        var stateArray = NSArray()
    
    //MARK:- OUTLETS
    @IBOutlet  var viewShadow: UIView!
    @IBOutlet  var btnUpdatePassword: UIButton!

    @IBOutlet  var btnSave: UIButton!
    @IBOutlet  var btnFollowerFollowingonEditProfile: UIButton!
    //BAR TENDER VIEW CONSTRAINTS
     @IBOutlet  var heightConstraintforBartenderView: NSLayoutConstraint!
    @IBOutlet  var barTenderHideUnhideView: UIView!
    @IBOutlet  var lblStateDummy: UILabel!
    @IBOutlet  var imgVisibilityStatus: UIImageView!
    @IBOutlet  var btnVisibilityOnEditProfileScreen: UIButton!
    @IBOutlet  var btnonmainEditProfileViewSuperView: UIButton!
    @IBOutlet  var mainEditProfileViewSuperView: UIView!
    @IBOutlet  var scrollViewforEditProfile: UIScrollView!
    @IBOutlet  var btnCrossEditProfile: UIButton!
    @IBOutlet  var btnImgEditProfile: UIButton!
    @IBOutlet  var lblFollowing      : UILabel!
    @IBOutlet  var lblFollowers      : UILabel!
    @IBOutlet  var txtName    : UITextField!
    @IBOutlet  var txtEmail   : UITextField!
    @IBOutlet  var txtUserName : UITextField!
    @IBOutlet  var txtPhone  : UITextField!
    @IBOutlet  var txtRole   :UITextField!
    @IBOutlet  var txtCountry   : UITextField!
    @IBOutlet  var txtState : UITextField!
    @IBOutlet  var txtCity            : UITextField!
//    @IBOutlet  var txtStreetAddress   : UITextView!
    @IBOutlet  var txtWorksAt  : UITextView!
    
    //NEW FIELDS
    @IBOutlet  var txtFavAlcohol  : UITextField!
    
    @IBOutlet  var txtOutingDay  : UITextField!
    var selectedDayIndex: Int = 0
    var dayPicker = UIPickerView()
    var dayArray = NSArray()

       var purchaseAlcoholArray = NSArray()
       var purchaseAlcoholPicker = UIPickerView()
       var selectedpurchaseAlcoholIndex : Int = 0
       @IBOutlet  var txtPurchaseAlcohol: UITextField!
        

    @IBOutlet  var txtSpeciality  : UITextField!
    
    
    func setUpVisibility()
    {
        if savedataInstance.visibility_status != nil
           {
           if  "\(savedataInstance.visibility_status!)" == "1"
           {
               imgVisibilityStatus.image = UIImage.init(named: "NEWON")
                               
               btnImgEditProfile.layer.borderColor = Constant.THEME_DARK_GREEN_COLOR.cgColor
               btnImgEditProfile.layer.borderWidth = 3.0
                               
           }
           else
           {
                               
           btnImgEditProfile.layer.borderColor = UIColor.clear.cgColor
           btnImgEditProfile.layer.borderWidth = 0.0
                               
           imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
           }
           }
           else
           {
               btnImgEditProfile.layer.borderColor = UIColor.clear.cgColor
               btnImgEditProfile.layer.borderWidth = 0.0
               imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
               imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
           }
    }
    
    @IBAction func searchBarsAction(_ sender: UIButton)
      {
          self.view.endEditing(true)
          
          if txtWorksAt.text?.isEmpty == true
          {
            if txtRole.text == "Hospitality"
            {
            SVProgressHUD.showError(withStatus: "Please enter bar name to search")
            }
            else
            {
                SVProgressHUD.showError(withStatus: "Please  enter store name to search")
            }
            
          }
          else if txtWorksAt.text!.count < 3
          {
            
              SVProgressHUD.showError(withStatus: "Please enter minimum three characters to search")
            
          }
          else
          {
              self.getSearchedBars()
          }
      }
    
    func getSearchedBars()
    {
        let params = NSMutableDictionary()
        params.setValue("\(txtWorksAt.text!)", forKey:"search")
        print("params are \(params)")
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Please check your internet connection.")
            break
            // Show alert if internet not available.
        //show alert
        default:
            ApiManager.sharedManager.delegate=self
            SVProgressHUD.show(withStatus: "Loading ...")
            
        if txtRole.text == "Hospitality"
        {
            print("hit bar name api")
        ApiManager.sharedManager.postDataOnserver(params: params, postUrl: Constant.SEARCHBARNAMEAPI as NSString, currentView: self.view)
        }
        else if txtRole.text == "Retail Liquor"
        {
            print("hit store name api")
        ApiManager.sharedManager.postDataOnserver(params: params, postUrl: Constant.SEARCHSTORENAMEAPI as NSString, currentView: self.view)
        }
            
        }
    }
    
    
    func getMyProfileandUpdateData()
        {
            
            if (self.savedataInstance.getUserDetails() != nil)
            {
                
            }
            else
            {
                return
            }
            
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
    
    
    
    //WORKING CODE
    func updateProfileNow()
    {
    let manager: AFHTTPSessionManager = AFHTTPSessionManager()
    manager.requestSerializer = AFJSONRequestSerializer()
    manager.responseSerializer = AFJSONResponseSerializer()
    let urlStr : String = "\(Constant.baseUrl)\(Constant.updateProfileAPI)"
    let params = NSMutableDictionary()

    params.setValue(savedataInstance.id, forKey: "id")
    params.setValue(savedataInstance.token, forKey: "token")
    params.setValue(txtName.text, forKey: "name")
    params.setValue(txtEmail.text, forKey: "email")
    params.setValue(txtPhone.text, forKey: "phone")
        //NEW VALUES ADDED
    params.setValue(txtFavAlcohol.text, forKey: "fav_alcohol")
    params.setValue(txtSpeciality.text!, forKey: "speciality")
//    params.setValue(txtFavLiq.text!, forKey: "fav_liquor")
//        params.setValue(txtFavLiq.text!, forKey: "fav_liquor")
        params.setValue("", forKey: "fav_liquor")

        
        //new api changes
        
        params.setValue(txtOutingDay.text!, forKey: "outing_day")
        
        if selectedpurchaseAlcoholIndex == 0
        {
            params.setValue("yes", forKey: "alcohol_online")
        }
        else if selectedpurchaseAlcoholIndex == 1
        {
            params.setValue("no", forKey: "alcohol_online")
        }


        
        

        
//        "Bar Tender","Liquor Store","Promoter","Other"
    //need to discuss
    params.setValue(txtUserName.text, forKey: "username")
        
        if txtRole.text == "Hospitality"
        {
            params.setValue("7", forKey: "role")
        }
        else if txtRole.text == "Retail Liquor"
        {
            params.setValue("8", forKey: "role")
        }
        else if txtRole.text == "Event"
        {
            params.setValue("4", forKey: "role")
        }
        else if txtRole.text == "Customer"
        {
            params.setValue("3", forKey: "role")
        }
        
        if (txtCountry.text!).lowercased() == "usa"
        {
            params.setValue("USA", forKey: "country")
        }
        else
        {
            params.setValue("Canada", forKey: "country")
        }
        
        if txtCountry.text == "USA"
        {
            params.setValue(((savedataInstance.States as! NSArray).object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state")
        }
        else
        {
            params.setValue(((savedataInstance.ProvincesAndTerritories as! NSArray).object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state")
        }
        params.setValue(txtCity.text!, forKey: "city")
//        params.setValue(txtStreetAddress.text!, forKey: "address")
        params.setValue("", forKey: "address")
        
        params.setValue(savedataInstance.work_at, forKey: "work_at")
        
      params.setValue("", forKey: "my_status")

                //PENDING
//       params.setValue(txtMyStatus.text!, forKey: "my_status")
//       params.setValue(txtFavDrink.text!, forKey: "fav_drink")
               params.setValue("", forKey: "fav_drink")

//       params.setValue(txtFavSpirit.text!, forKey: "fav_spirit")
        
//       params.setValue(txtFavCocktail.text!, forKey: "fav_cocktail")
        params.setValue("", forKey: "fav_cocktail")

       if  (imgVisibilityStatus.image?.isEqual( UIImage.init(named: "NEWON")))!
       {
           params.setValue("1", forKey: "visibility_status")
       }
       else{
           params.setValue("0", forKey: "visibility_status")
       }
               
        print("params for edit profile are \(params)")
        let request: NSMutableURLRequest = manager.requestSerializer.multipartFormRequest(withMethod: "POST"
            , urlString: urlStr, parameters: params as? [String : AnyObject], constructingBodyWith: {(formData: AFMultipartFormData!) -> Void in
                
        if self.imageData != nil
        {
            formData.appendPart(withFileData: self.imageData! as Data, name: "profile_image", fileName: "profile_image.jpg", mimeType: "image/jpeg")
        }
                
            }, error: nil)
        
        
                
        manager.dataTask(with: request as URLRequest) { (response, responseObject, error) -> Void in

            if((error == nil))
            {
                
                if ((responseObject as! NSDictionary).value(forKey: "status") as! Bool) == true
                {
                    SVProgressHUD.dismiss()

                    SVProgressHUD.showSuccess(withStatus: "Profile Updated Successfully.")

            self.savedataInstance.saveUserDetails(userdataDict: (responseObject as! NSDictionary)["data"] as! NSDictionary)
                    
                self.getMyProfileandUpdateData()
                    
                self.setUpVisibility()

                    
                let dict = self.savedataInstance.getUserDetails()
                                   
                    self.view.isHidden = true
                    
                }
                else
                {
                    print("error is in UPDATE PROFILE API \(error)")
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
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("my offset is \(scrollView.contentOffset)")
    }


    
    func setUpEditProfileDetails()
       {
        citySelectionSuperView.isHidden = true
        
        self.txtCity.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        print(savedataInstance.getUserDetails())
        txtWorksAt.isUserInteractionEnabled = false

        scrollViewforEditProfile.delegate = self
        
        RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.viewShadow)

                
        if RandomObjects.checkValueisNilorNull(value: savedataInstance.name) == false
        {
        
        txtName.text = (savedataInstance.name as? String)
        }
        else
        {
            txtName.text  = ""
        }
        if RandomObjects.checkValueisNilorNull(value: savedataInstance.username) == false
        {
        txtUserName.text = (savedataInstance.username as? String)
        }
        else{
             txtUserName.text = ""
        }
        
        if RandomObjects.checkValueisNilorNull(value: savedataInstance.email) == false
        {
        txtEmail.text = (savedataInstance.email as? String)

        }
        if RandomObjects.checkValueisNilorNull(value: savedataInstance.phone) == false
        {
        txtPhone.text = (savedataInstance.phone as? String)

        }
        
        if  self.savedataInstance.follow_by  != nil{
            lblFollowers.text = "\(savedataInstance.follow_by!)"

        }
        else{
        lblFollowers.text = "0"
        }
        
        if  self.savedataInstance.follow_to  != nil{
            lblFollowing.text = "\(savedataInstance.follow_to!)"
        }
        else
        {
            lblFollowing.text = "0"
        }
             
        self.setUpVisibility()
        
        if  "\(savedataInstance.role!)" == "4"
        {
        txtRole.text = "Event"
            txtRole.isUserInteractionEnabled = false

        selectedRoleTypeIndex = 2
        }

       else if  "\(savedataInstance.role!)" == "8"
        {
            txtRole.isUserInteractionEnabled = false

        txtRole.text = "Retail Liquor"
        selectedRoleTypeIndex = 1
        print("height is not greater than 35 of address")

        }
        else if  "\(savedataInstance.role!)" == "7"
        {
            txtRole.isUserInteractionEnabled = false

            txtRole.text = "Hospitality"
            selectedRoleTypeIndex = 0
            print("height is not greater than 35 of address")

        }
        else if  "\(savedataInstance.role!)" == "3"
        {
        txtRole.isUserInteractionEnabled = true
        txtRole.text = "Customer"

        }
            print("need to hide bar name and address")
            
            if savedataInstance.city != nil && savedataInstance.city is NSNull == false
            {
            txtCity.text = "\(savedataInstance.city!)"
            }
            
            if  savedataInstance.country != nil && savedataInstance.country is NSNull == false
            {
            txtCountry.text = "\(savedataInstance.country!)"
            }
            else
            {
            txtCountry.text = ""
            }
            
            if (txtCountry.text!).lowercased() == "usa"
            {
                lblStateDummy.text = "STATE :"
            }
            else
            {
                lblStateDummy.text = "PROVINCES :"
            }
            
              if  savedataInstance.state != nil && savedataInstance.state is NSNull == false
              {
                
                let stateArray : NSArray?
                if txtCountry.text! == "USA"
                {
                    stateArray = (savedataInstance.States as! NSArray)
                }
                else
                {
                    stateArray = (savedataInstance.ProvincesAndTerritories as! NSArray)
                }
                
                var stateStr : NSString = ""
                for i in 0..<stateArray!.count
                {
                    let dict = stateArray![i] as! NSDictionary
                    let abbreviation = (dict.value(forKey: "abbreviation") as! String).lowercased()
                    let selectedState = (savedataInstance.state as! String).lowercased()
 
                    if abbreviation == selectedState
                    {
                        stateStr = (dict.value(forKey: "full_name") as! NSString)
                        selectedStateIndex = i
                        txtState.text = stateStr as String
                        
                        self.getCitiesAccordingtoStateandCountry()
                        
                    }
                }
            }
            else
            {
                 txtState.text = ""
            }
            
//            if  savedataInstance.address != nil && savedataInstance.address is NSNull == false
//            {
//            txtStreetAddress.text = "\(savedataInstance.address!)"
//
//            }
//            else
//            {
//                txtStreetAddress.text = ""
//            }
        
            
            if "\(savedataInstance.role ?? "")" == "7"
            {
                if savedataInstance.bar_name != nil{
            txtWorksAt.text = "\(savedataInstance.bar_name!)"
                }
            }
            if "\(savedataInstance.role ?? "")" == "8"
            {
                if savedataInstance.store_name != nil
                {
                txtWorksAt.text = "\(savedataInstance.store_name!)"
                }
            }
                                    

        
//        if  savedataInstance.fav_drink != nil && savedataInstance.fav_drink is NSNull == false {
//            txtFavDrink.text = (savedataInstance.fav_drink as! String)
////                .uppercased()
//        }
//        if  savedataInstance.fav_cocktail != nil && savedataInstance.fav_cocktail is NSNull == false
//        {
//            txtFavCocktail.text = (savedataInstance.fav_cocktail as! String)
//                //.uppercased()
//        }
        if  savedataInstance.fav_alcohol != nil && savedataInstance.fav_alcohol is NSNull == false
        {
            txtFavAlcohol.text = (savedataInstance.fav_alcohol as! String)
//                .uppercased()
        }
        
        if  savedataInstance.outing_day != nil && savedataInstance.outing_day is NSNull == false
        {
            txtOutingDay.text = (savedataInstance.outing_day as! String)
        }
        
//
        if  savedataInstance.speciality != nil && savedataInstance.speciality is NSNull == false
        {
            txtSpeciality.text = (savedataInstance.speciality as! String)
        //                .uppercased()
        }
        
        if  savedataInstance.alcohol_online != nil && savedataInstance.alcohol_online is NSNull == false
               {
                   txtPurchaseAlcohol.text = (savedataInstance.alcohol_online as! String)
        
               }
        
        
                                
        print(savedataInstance.getUserDetails()!)
        if self.savedataInstance.profile_image != nil
        {
        let imgStr: String = RandomObjects.getUserOwnProfileImageStr()
                                    
        btnImgEditProfile.contentMode = .scaleToFill
        btnImgEditProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //set placeholder PENDING HB
        btnImgEditProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
        btnImgEditProfile.sd_setImage(with: URL.init(string: imgStr), for: .normal, placeholderImage: UIImage.init(named: "profileplaceholder"), options: .highPriority)
            
        }
      btnImgEditProfile.layer.cornerRadius = btnImgEditProfile.frame.size.width / 2
         btnImgEditProfile.layer.masksToBounds = true
         btnImgEditProfile.clipsToBounds = true
        
        //role picker creation

        roleArray = NSArray.init(objects: "Hospitality","Retail Liquor","Event")
        
        rolePickerView = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        rolePickerView.backgroundColor = UIColor.white
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
        txtRole.inputView = rolePickerView
           txtRole.delegate = self
        
        //country picker creation
        countryArray = NSArray.init(objects: "USA","Canada")
        countryPickerView = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        countryPickerView.backgroundColor = UIColor.white
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        txtCountry.inputView = countryPickerView
        txtCountry.delegate = self
        
        //state picker creation
        
        statePickerView = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        statePickerView.backgroundColor = UIColor.white
        statePickerView.delegate = self
        statePickerView.dataSource = self
//        txtState.inputView = statePickerView
        txtState.delegate = self
        
        
        
        if txtCountry.text?.isEmpty == false
        {
            txtState.inputView = statePickerView
        }
        
        
        favSpiritArray = NSArray.init(objects: "Vodka","Gin","Rum","Bourbon", "Tequila")

//        favSpiritPicker = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
//        favSpiritPicker.backgroundColor = UIColor.white
//        favSpiritPicker.delegate = self
//        favSpiritPicker.dataSource = self
//        txtFavSpirit.inputView = favSpiritPicker
        
//        collectionViewProfileImages.dataSource = self
//        collectionViewProfileImages.delegate = self
//        collectionViewProfileImages.reloadData()
        btnSave.backgroundColor = UIColor.darkGray
        btnSave.isUserInteractionEnabled = false
        
        
        dayArray = NSArray.init(objects: "MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY","SUNDAY")
        dayPicker = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
              
        dayPicker.backgroundColor = UIColor.white
        dayPicker.delegate = self
        dayPicker.dataSource = self
        txtOutingDay.inputView = dayPicker
        txtOutingDay.delegate = self
        
        
        
        purchaseAlcoholArray = NSArray.init(objects: "YES","NO")
                purchaseAlcoholPicker = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
               
                   purchaseAlcoholPicker.backgroundColor = UIColor.white
                   purchaseAlcoholPicker.delegate = self
                   purchaseAlcoholPicker.dataSource = self
                   txtPurchaseAlcohol.inputView = purchaseAlcoholPicker
                   txtPurchaseAlcohol.delegate = self
        
       }
    
    
    //IMAGE PICKER CONTROLLER WORK
    @IBAction func profileImageClicked(_ sender: Any)
    {
    self.view.endEditing(true)
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
    }))

    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
    self.openGallery()
    }))

    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

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
    
    @IBAction func saveProfileAction(_ sender: Any)
    {
        self.view.endEditing(true)
        if txtName.text?.isEmpty == true
        {
            SVProgressHUD.showError(withStatus: "Please enter name.")
        }
        else
            if txtPhone.text?.isEmpty == true
        {
            SVProgressHUD.showError(withStatus: "Please enter Phone Number.")
        }
        else if txtUserName.text?.isEmpty == true
        {
            SVProgressHUD.showError(withStatus: "Please enter Username.")
        }
        else if txtCountry.text?.isEmpty == true
        {
        SVProgressHUD.showError(withStatus: "Please select country.")
        }
        else if  txtState.text?.isEmpty == true
        {
        SVProgressHUD.showError(withStatus: "Please select state.")
        }
        else if txtCity.text?.isEmpty == true
        {
        SVProgressHUD.showError(withStatus: "Please enter city.")
        }
        else if (txtPhone.text!.count < 10)
        {
        SVProgressHUD.showError(withStatus: "Please enter valid Phone Number.")
        }
//        else if ((txtRole.text == "Hospitality" || txtRole.text?.lowercased() == "hospitality") &&  txtWorksAt.text?.isEmpty == true)
//            {
//                SVProgressHUD.showError(withStatus: "Please search and select work at.")
//
//            }
//            else if ((txtRole.text == "Retail Liquor" || txtRole.text?.lowercased() == "retail liquor") &&  txtWorksAt.text?.isEmpty == true)
//        {
//            SVProgressHUD.showError(withStatus: "Please search and select work at.")
//
//        }
//        else if ((txtRole.text == "LiquorStore" || txtRole.text?.lowercased() == "liquorstore") &&  txtWorksAt.text?.isEmpty == true)
//            {
//            SVProgressHUD.showError(withStatus: "Please search and select work at.")
//
//            }
//            else if ((txtRole.text == "Hospitality" || txtRole.text?.lowercased() == "hospitality") &&  txtWorksAt.text?.isEmpty == true)
//                {
//                SVProgressHUD.showError(withStatus: "Please search and select work at.")
//
//            }
        else
        {
        let status = Reach().connectionStatus()
               switch status {
        case .unknown, .offline:
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Please check your internet connection.")

        break
                       // Show alert if internet not available.
                       //show alert
            default:
        ApiManager.sharedManager.delegate=self
        SVProgressHUD.show(withStatus: "Updating Profile...")
        self.updateProfileNow()
                }

        }
//        else if txtUserName.text?.isEmpty == true {
//
//        }
//        else if txtPhone.text?.isEmpty == true
//        {
//
//        }
        
//        self.updateProfileApi()
//        self.updateProfilePictureHB()
//        self.updateProfilePicture()
//        self.updateProfileNow()
    }
    

    @IBAction func visibilityButtonClicked(_ sender: Any)
    {
        self.view.endEditing(true)
        if (imgVisibilityStatus.image?.isEqual(UIImage.init(named: "NEWOFF")))!
        {
            imgVisibilityStatus.image = UIImage.init(named: "NEWON")
          
        }
        else{
            imgVisibilityStatus.image = UIImage.init(named: "NEWOFF")
            
        }
        isAnythingChanged = true
        self.setSaveButtonAccordingly()
        
//        self.setVisibilityStatusApi()
//        imgVisibilityStatus
        
    }
    
    func setSaveButtonAccordingly(){
        if isAnythingChanged == true {
            
            btnSave.backgroundColor = UIColor.init(red: 23/255.0, green: 107/255.0, blue: 149/255.0, alpha: 1.0)
            btnSave.isUserInteractionEnabled = true

        }
        else
        {
            btnSave.backgroundColor = UIColor.darkGray
            btnSave.isUserInteractionEnabled = false

        }
    }
    
    
    func setVisibilityStatusApi(){
            //MARK:-  hit sign up api
    }

           //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
       {
               SVProgressHUD.dismiss()
               DispatchQueue.main.async {
                   do {

                    if serviceurl as String == Constant.GETOTHERUSERPROFILEAPI
                     {
                         let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                                                    
                         if (jsonDictionary.value(forKey: "status") as! Bool) == true
                         {
                             
                     if jsonDictionary.value(forKey: "data") != nil
                     {
                             self.setSaveDataDetails(jsonDictionary: jsonDictionary)
                       
                         }
                         }
                        else
                        {
                      RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )

                       print("error in visibility api")
                          }
                             
                         }
                    else if serviceurl as String == Constant.GETCITYAPI
                    {
                        let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                   
                        if (jsonDictionary.value(forKey: "status") as! Bool) == true
                        {
                           if jsonDictionary.value(forKey: "data") != nil
                           {
                            self.cityArray.removeAllObjects()
                            self.cityArray.addObjects(from: (jsonDictionary["data"] as! NSDictionary).value(forKey: "Cities")as! [Any])

                            self.cityTableView.reloadData()
                           }
                        }
                        else
                        {
                           RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                        }
                       }

               }catch let _error
               {
                       print(_error)
               }
               }
           }
       
    //MARK:- ERROR RESPONSE
       func failureRsponseError(failureError: NSError?, serviceurl: NSString) {
            SVProgressHUD.dismiss()
       }
    
    //MARK:- SAVE DATA USER
            func setSaveDataDetails(jsonDictionary: NSDictionary?)
            {
      self.savedataInstance.saveUserDetails(userdataDict: jsonDictionary!["data"] as! NSDictionary)
            }
    
    //MARK:- UITEXTFIIELD DELEGATES
    
    @objc func textFieldDidChange(_ textField: UITextField)
      {
        if textField == txtCity
        {
          if textField.text?.isEmpty == false
          {
            filteredCityArray.removeAllObjects()
            
            for i in 0..<cityArray.count
            {
            let dict =   cityArray.object(at: i) as! NSDictionary
                
                let cityStr : NSString = "\(dict.value(forKey: "city") ?? "")".lowercased() as NSString
                print("city str is \(cityStr)")
                if cityStr.contains(textField.text!.lowercased())
                {
                    filteredCityArray.add(dict)
                }
                print("filtered city array is here \(filteredCityArray)")
                if filteredCityArray.count > 0
                {
                    citySelectionSuperView.isHidden = false
                    cityTableView.reloadData()
                }
                else{
                    citySelectionSuperView.isHidden = true
                    cityTableView.reloadData()

                }
            }
            
          }
          else
          {
            citySelectionSuperView.isHidden = true
            filteredCityArray.removeAllObjects()
            cityTableView.reloadData()
          }
        }
      }
    
    //MARK:- TABLEVIEW DELEGATES AND DATASOURCE

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
      {
          return filteredCityArray.count
      }
      func numberOfSections(in tableView: UITableView) -> Int
      {
          return 1
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
      {
          let cell : CityCell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! CityCell
          if filteredCityArray.count > 0
          {
          cell.lblCityName.text = (filteredCityArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "city") as? String
          }
          return cell
      }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        txtCity.text = (filteredCityArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "city") as? String
        citySelectionSuperView.isHidden = true
        cityTableView.reloadData()
    }
    
    
    
    
    
    //MARK:- UICOLLECTION VIEW DELEGATES AND DATASOURCE

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarImagesCell", for: indexPath) as! BarImagesCell

        //checking for ui :
        cell.imgBars.contentMode = .scaleAspectFit
        cell.imgBars.backgroundColor = UIColor.red
//        cell.imgBars.image = (addsImagesArray[indexPath.item] as! UIImage)
        
        return cell
    }
    
    //MARK:- UICOLLECTION VIEW DELEGATE AND DATA SOURCE

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
     return CGSize.init(width: (collectionView.frame.size.width / 3) - 10   , height: (collectionView.frame.size.width / 3) - 10 )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
//           MARK:- UIPickerViewDataSource methods
              func numberOfComponents(in pickerView: UIPickerView) -> Int {
                  return 1
              }
    
              func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

                    if pickerView == countryPickerView
                {
                    return countryArray.count
                }
                else if pickerView == purchaseAlcoholPicker
                {
                    return purchaseAlcoholArray.count
                    }
                else if pickerView == dayPicker
                {
                    return dayArray.count
                }
                else if pickerView == rolePickerView
                {
                    return roleArray.count
                }
                else if pickerView == statePickerView
                {
                    if txtCountry.text! == "USA"
                    {
                    return (savedataInstance.States as! NSArray).count
                    }
                    else
                    {
                        return  (savedataInstance.ProvincesAndTerritories as! NSArray).count
                    }
                }
          
                return roleArray.count
            }
    
              //MARK:- UIPickerViewDelegates methods
              func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

                if pickerView == rolePickerView
            {
                    return (roleArray[row] as! String)
            }
            else if pickerView == dayPicker
            {
                return (dayArray[row] as! String)
            }
                    else if pickerView == purchaseAlcoholPicker
                    {
                        return (purchaseAlcoholArray[row] as! String)
                    }
            else if pickerView == countryPickerView{
                return (countryArray[row] as! String)
            }
            else if pickerView == statePickerView
            {
            if txtCountry.text! == "USA"
            {
                return (((savedataInstance.States as! NSArray)[row] as! NSDictionary).value(forKey: "full_name") as! String)
            }
            else
            {
            return (((savedataInstance.ProvincesAndTerritories as! NSArray)[row] as! NSDictionary).value(forKey: "full_name") as! String)
            }
                }
                return (roleArray[row] as! String)
              }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == rolePickerView
        {
            selectedRoleTypeIndex = row
        }
        else if pickerView == countryPickerView{
            selectedCountryIndex = row
        }
        else if pickerView == statePickerView{
            selectedStateIndex = row
        }
        else if pickerView == dayPicker
        {
            selectedDayIndex = row
        }
        else if pickerView == purchaseAlcoholPicker
        {
            selectedpurchaseAlcoholIndex = row
        }

    }
    
    //   :-MARK UITEXTFIELD DELEGATES :
    //  MARK:- UIPickerViewDataSource methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
            if textField == txtWorksAt
        {
            txtWorksAt.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        

            if textField  == txtRole
        {
            txtWorksAt.text = ""
            
            isAnythingChanged = true

            textField.text = (roleArray.object(at: selectedRoleTypeIndex) as! String)
//                .uppercased()
            
        }
        else  if textField  == txtCountry
        {
            cityArray.removeAllObjects()
            filteredCityArray.removeAllObjects()
            txtCity.text = ""
            citySelectionSuperView.isHidden = true
            self.txtState.isUserInteractionEnabled = true
            self.txtCity.isUserInteractionEnabled = true

            
            
            txtCountry.text = (countryArray.object(at: selectedCountryIndex) as! String).uppercased()
            
            txtState.inputView = statePickerView
            
            if (txtCountry.text!).lowercased() == "usa"
            {
                lblStateDummy.text = "STATE :"
                txtState.text = (((savedataInstance.States as! NSArray)[0] as! NSDictionary).value(forKey: "full_name") as! String)
//                dfe
                
            }
            else
            {
            lblStateDummy.text = "PROVINCES :"
            txtState.text = (((savedataInstance.ProvincesAndTerritories as! NSArray)[0] as! NSDictionary).value(forKey: "full_name") as! String)
            }
            
            self.getCitiesAccordingtoStateandCountry()

            if txtCountry.text!.lowercased() == "\(savedataInstance.country!)".lowercased()
            {
                print("NOT CHANGED COUNTRY")
            }
            else{
                print(" CHANGED COUNTRY")
                isAnythingChanged = true
            }
            
        }
        else  if textField  == txtState
        {
            if txtCountry.text?.isEmpty == true
            {
                return
            }
            
            if txtCountry.text! == "USA"
            {
                txtState.text = (((savedataInstance.States as! NSArray)[selectedStateIndex] as! NSDictionary).value(forKey: "full_name") as! String)
            }
            else
            {
                txtState.text = (((savedataInstance.ProvincesAndTerritories as! NSArray)[selectedStateIndex] as! NSDictionary).value(forKey: "full_name") as! String)
            }
            
            if txtState.text!.lowercased() == "\(savedataInstance.state!)".lowercased()
            {
                print("NOT CHANGED state")
            }
            else
            {
                print(" CHANGED state")
                isAnythingChanged = true
            }
            
            cityArray.removeAllObjects()
                       filteredCityArray.removeAllObjects()
                       txtCity.text = ""
                       citySelectionSuperView.isHidden = true
                       
                   self.getCitiesAccordingtoStateandCountry()
       }
        
        else  if textField  == txtCity
        {
            if txtCity.text!.lowercased() == "\(savedataInstance.city!)".lowercased()
                    {
                        print("NOT CHANGED city")
                    }
                    else
                    {
                        print(" CHANGED city")
                        isAnythingChanged = true
                    }
        }
        else  if textField  == txtName
        {
        if txtName.text!.lowercased() == "\(savedataInstance.name!)".lowercased()
        {
                print("NOT CHANGED name")
        }
        else
        {
                print(" CHANGED name")
                isAnythingChanged = true
        }
        }
        else  if textField  == txtUserName
        {
        if txtUserName.text!.lowercased() == "\(savedataInstance.username!)".lowercased()
        {
            print("NOT CHANGED username")
        }
        else
        {
            print(" CHANGED username")
            isAnythingChanged = true
        }
        }

        else  if textField  == txtSpeciality
               {
                     if txtSpeciality.text!.lowercased() == "\(savedataInstance.speciality!)".lowercased()
                     {
                         print("NOT CHANGED speciality")
                     }
                     else
                     {
                         print(" CHANGED speciality")
                         isAnythingChanged = true
                     }
               }
        else  if textField  == txtPhone
                      {
                            if txtPhone.text!.lowercased() == "\(savedataInstance.phone!)".lowercased()
                            {
                                print("NOT CHANGED phone")
                            }
                            else
                            {
                                print(" CHANGED phone")
                                isAnythingChanged = true
                            }
                      }
                            else  if textField  == txtFavAlcohol
                
                             {
                                   if txtFavAlcohol.text!.lowercased() == "\(savedataInstance.fav_alcohol!)".lowercased()
                                   {
                                       print("NOT CHANGED phone")
                                   }
                                   else
                                   {
                                       print(" CHANGED phone")
                                       isAnythingChanged = true
                                   }
                             }
                            else if textField == txtOutingDay
                            {
                            txtOutingDay.text  = dayArray[selectedDayIndex] as? String
                            isAnythingChanged = true
                            }
                            else if textField == txtPurchaseAlcohol
                            {
                            txtPurchaseAlcohol.text = purchaseAlcoholArray[selectedpurchaseAlcoholIndex] as? String
                            isAnythingChanged = true
                            }
                            self.setSaveButtonAccordingly()
                            }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
          if range.location == 0 && (string == " ") {
                 return false
          }
         else if textField ==  txtPhone
          {
          let maxLength = 14
          let currentString: NSString = textField.text! as NSString
          let newString: NSString =
              currentString.replacingCharacters(in: range, with: string) as NSString
          return newString.length <= maxLength
          }
          else
          {
              return true
          }
      }
    
    func getCitiesAccordingtoStateandCountry()
    {
        let params = NSMutableDictionary()

        if (txtCountry.text!).lowercased() == "usa"
           {
               params.setValue("USA", forKey: "country")
           }
           else
           {
               params.setValue("Canada", forKey: "country")
           }
        
        if (txtCountry.text!).lowercased() == "usa"
           {
               params.setValue(((savedataInstance.States as! NSArray).object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state_code")
           }
           else
           {
               params.setValue(((savedataInstance.ProvincesAndTerritories as! NSArray).object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state_code")
           }
           
        print("get city api params \(params)")
        
        
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Please check your internet connection.")
            break
            // Show alert if internet not available.
        //show alert
        default:
            ApiManager.sharedManager.delegate=self
            SVProgressHUD.show(withStatus: "Loading ...")
            ApiManager.sharedManager.postDataOnserver(params: params, postUrl: Constant.GETCITYAPI as NSString, currentView: self.view)
        }
    }
    
    

    
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage
        {
            
        let newPickedImage = RandomObjects.resizeImage(image: pickedImage, targetSize: CGSize.init(width: 300, height: 300))
            
        imageData = newPickedImage.jpegData(compressionQuality: 0.4) as NSData?
            
        btnImgEditProfile.setImage(newPickedImage, for: .normal)
            
        btnImgEditProfile.layer.cornerRadius = btnImgEditProfile.frame.size.width / 2
            
        btnImgEditProfile.layer.masksToBounds = true
        btnImgEditProfile.clipsToBounds = true
            // imageViewPic.contentMode = .scaleToFill
        }
        isAnythingChanged = true
        self.setSaveButtonAccordingly()

        picker.dismiss(animated: true, completion: nil)

    }
    
    //MARK:- UITEXTVIEW DELEGATES

    func textViewDidChange(_ textView: UITextView)
    {

    }
    
    }

extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}
