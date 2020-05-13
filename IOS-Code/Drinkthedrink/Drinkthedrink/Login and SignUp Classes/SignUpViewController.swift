//
//  SignUpViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol SignUpSuccessProtocolDelegate {
    func successFullSignupOpenStep()
}
//    var delegate        : BeginLocationChangesDelegateNew?

class SignUpViewController: UIViewController,WebServiceDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource
{
    var cityArray = NSMutableArray()
    var filteredCityArray = NSMutableArray()


    @IBOutlet  var citySelectionSuperView: UIView!
    @IBOutlet  var cityTableView: UITableView!

            
    var selectedUserTypeIndex : Int = -1

//    @IBOutlet  var collectionViewUserTypeOnSignUpScreen: UICollectionView!
//    @IBOutlet  var viewSpeciality: UIView!

//    @IBOutlet  var lblthisAppWillsendcustomers: UILabel!

     var delegate        : SignUpSuccessProtocolDelegate?


    //bars picker for search
    var barsPicker = UIPickerView()

    
    let savedataInstance = SaveDataClass.sharedInstance

    @IBOutlet  var btnPrivacy: UIButton!
    @IBOutlet  var btnTerms: UIButton!
    @IBOutlet  var shadowView: UIView!
    
    @IBOutlet  var lblPrivacyPolicy: UILabel!
    @IBOutlet  var btnonmainSignUpViewSuperView: UIButton!
    @IBOutlet  var mainSignUpViewSuperView: UIView!
    @IBOutlet  var scrollViewforSignUp: UIScrollView!
    @IBOutlet  var btnCrossSignUp: UIButton!
    @IBOutlet  var txtName: UITextField!
    @IBOutlet  var txtEmail: UITextField!
    
    //new things
    @IBOutlet  var txtPhoneNumber: UITextField!
//    @IBOutlet  var txtFavoriteLiquor: UITextField!
//    @IBOutlet  var txtFavoriteSpirit: UITextField!
//    @IBOutlet  var btnAreYouIndustry: UIButton!
    
    
    @IBOutlet  var txtPassword: UITextField!
    @IBOutlet  var txtUserName: UITextField!
    
    //    @IBOutlet  var viewIndustryItems: UIView!
//    @IBOutlet  var viewTellUs: UIView!
//    @IBOutlet  var txtBarName: UITextField!
    
    //new work
    //    var barNameArray  = [BarnameObj]()
    //    var selectedBarIndex : Int = -1
    //    let barsToolBar = UIToolbar()
    
    //    var storeNameArray  = [StorenameObj]()
    //    @IBOutlet  var btnSearchBarName: UIButton!
//    @IBOutlet  var viewMainBarNameHeightConstraint: NSLayoutConstraint!
//    @IBOutlet  var tellUsWorkingatViewHeightConstraint: NSLayoutConstraint!

    
    @IBOutlet  var txtCountry: UITextField!
    @IBOutlet  var txtState: UITextField!
    @IBOutlet  var txtCity: UITextField!




    
    var statesPickerView = UIPickerView()
    let statesArrray = NSMutableArray()
    var selectedStateIndex : Int = 0

    let provincesArray = NSMutableArray()
    
    var countryPickerView = UIPickerView()
    var countryArrray = NSArray()
    var selectedCountryIndex : Int = 0

    
    
    var selectedfavSpiritIndex: Int = 0
    var favSpiritPicker = UIPickerView()
    var favSpiritArray = NSArray()
    
    var workingAtArray = NSArray()
    
    @IBOutlet  var btnSignUp: UIButton!
    
    @IBOutlet  var btnAlreadyRegistered: UIButton!
    @IBOutlet  var btnLogin: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createPickerforWorkingAt()
    {
        self.txtCity.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        citySelectionSuperView.isHidden = true
        self.txtState.isUserInteractionEnabled = false
        self.txtCity.isUserInteractionEnabled = false
//        self.txtAddress.isUserInteractionEnabled = false
        
        if statesArrray.count == 0 && provincesArray.count == 0
        {
            self.getAllCountriesAndStatesAPI()
        }
        
//        workingAtArray = NSArray.init(objects: "Bar Tender","Liquor Store","Promoter","Other")
        workingAtArray = NSArray.init(objects: "Hospitality","Retail Liquor","Event","Customer")
        
        
        favSpiritArray = NSArray.init(objects: "Vodka","Gin","Rum","Bourbon", "Tequila")
        
        //CREATE FAV ALCOHOL PICKER
        
        favSpiritPicker = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        favSpiritPicker.backgroundColor = UIColor.white
        favSpiritPicker.delegate = self
        favSpiritPicker.dataSource = self
//        txtFavoriteSpirit.inputView = favSpiritPicker
        
//        viewIndustryItems.isHidden = true
//        viewMainBarNameHeightConstraint.constant = 0.0

//        viewIndustryItemsHeightConstraints.constant = 0.0
        
//        vfgc
        //create state picker
        //create country picke/r picker
       
        
          countryArrray = NSArray.init(objects: "USA","Canada")
         countryPickerView = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        
            countryPickerView.backgroundColor = UIColor.white
            countryPickerView.delegate = self
            countryPickerView.dataSource = self
            txtCountry.inputView = countryPickerView
            txtCountry.delegate = self
                
                //state picker creation
                
          statesPickerView = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
          statesPickerView.backgroundColor = UIColor.white
          statesPickerView.dataSource = self
        statesPickerView.delegate = self

         txtState.delegate = self
                
        //HB ONLY CREATE PICKER
//        self.createBarsPicker()
//        txtBarName.isUserInteractionEnabled = false
        
        
    }
    
    
    //    func showNotificationsSettings()
    //    {
    //        let settingsButton = NSLocalizedString("Settings", comment: "")
    //        let cancelButton = NSLocalizedString("Cancel", comment: "")
    //        let message = NSLocalizedString("Your need to give a permission from notification settings.", comment: "")
    //        let goToSettingsAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
    //
    //        goToSettingsAlert.addAction(UIAlertAction(title: settingsButton, style: .destructive, handler: { (action: UIAlertAction) in
    //            DispatchQueue.main.async {
    //                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
    //                    return
    //                }
    //
    //                if UIApplication.shared.canOpenURL(settingsUrl) {
    //                    if #available(iOS 10.0, *) {
    //                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
    //                            print("Settings opened: \(success)") // Prints true
    //                        })
    //                    } else {
    //                        UIApplication.shared.openURL(settingsUrl as URL)
    //                    }
    //                }
    //            }
    //        }))
    //
    ////        logoutUserAlert.addAction(UIAlertAction(title: cancelButton, style: .cancel, handler: nil))
    //    }
    

    @IBAction func signUpButtonAction(_ sender: Any)
    {
        self.view.endEditing(true)
        
//        if UIApplication.shared.isRegisteredForRemoteNotifications == false
//        {
//            self.showAlertForSettings()
//            print("NOT REGISTERED FOR REMOTE NOTIFICATIONS")
//            return
//        }
//        else
            if (txtName.text?.isEmpty == true)
        {
            SVProgressHUD.showError(withStatus: "Please enter name.")
            //            self.showAlert(self, title1: "Message", msg: "Please enter name.")
        }
        else  if (txtEmail.text?.isEmpty == true)
        {
            SVProgressHUD.showError(withStatus: "Please enter email.")
            
            //                self.showAlert(self, title1: "Message", msg: "Please enter email.")
        }
        else  if (txtPassword.text?.isEmpty == true)
        {
            //            self.showAlert(self, title1: "Message", msg: "Please enter password.")
            SVProgressHUD.showError(withStatus: "Please enter password.")
            
        }
        else  if (txtUserName.text?.isEmpty == true)
        {
            SVProgressHUD.showError(withStatus: "Please enter username.")
            
            //                self.showAlert(self, title1: "Message", msg: "Please enter username.")
        }
        else if (txtEmail.text?.isValidEmail()) == false
        {
            SVProgressHUD.showError(withStatus: "Please enter valid email.")
            
            //            self.showAlert(self, title1: "Message", msg: "Please enter valid email.")
        }
        else if (txtPhoneNumber.text!.count < 10)
        {
            SVProgressHUD.showError(withStatus: "Please enter valid Phone Number.")
        }
        else if (txtPassword.text!.count < 6)
        {
            SVProgressHUD.showError(withStatus: "Password should be atleast six characters long.")
            
            //            self.showAlert(self, title1: "Message", msg: "Password should be atleast six characters long.")
        }
        else if (txtUserName.text!.count < 4)
        {
            SVProgressHUD.showError(withStatus: "Username should be atleast four characters long.")
            
            //  self.showAlert(self, title1: "Message", msg: "Username should be atleast four characters long.")
        }
//        else if selectedUserTypeIndex == -1
//        {
//            SVProgressHUD.showError(withStatus: "Please select industry.")
//            
//            //  self.showAlert(self, title1: "Message", msg: "Username should be atleast four characters long.")
//        }
//       else if (btnAreYouIndustry.currentImage == UIImage.init(named: "tick") && txtCountry.text?.isEmpty == true  && ( txtWorkingat.text == "Bar Tender" || txtWorkingat.text == "Liquor Store"))
                
                
                
//        {
//            SVProgressHUD.showError(withStatus: "Please choose country.")
//        }
//        else if (btnAreYouIndustry.currentImage == UIImage.init(named: "tick") &&  txtWorkingat.text?.isEmpty == true &&  ( txtWorkingat.text == "Bar Tender" || txtWorkingat.text == "Liquor Store"))
//        {
//            SVProgressHUD.showError(withStatus: "Please choose working as.")
//        }
//        else if (btnAreYouIndustry.currentImage == UIImage.init(named: "tick") && txtBarName.text?.isEmpty == true &&  ( txtWorkingat.text == "Bar Tender" || txtWorkingat.text == "Liquor Store"))
//        {
//            SVProgressHUD.showError(withStatus: "Please search and select your work place.")
//        }
//       else if (btnAreYouIndustry.currentImage == UIImage.init(named: "tick") && txtState.text?.isEmpty == true &&  ( txtWorkingat.text == "Bar Tender" || txtWorkingat.text == "Liquor Store"))
//        {
//            SVProgressHUD.showError(withStatus: "Please choose state or provinces.")
//        }
//        else if (btnAreYouIndustry.currentImage == UIImage.init(named: "tick") && txtBarName.text?.isEmpty == true &&  ( txtWorkingat.text == "Bar Tender" || txtWorkingat.text == "Liquor Store"))
//        {
//            SVProgressHUD.showError(withStatus: "Please choose state or provinces.")
//        }
        else
        {
            //hit api for login
            self.hitRegistrationApi()
        }
        
    }
    
//
    
    //MARK:- GET CITY API

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
               params.setValue((statesArrray.object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state_code")
           }
           else
           {
               params.setValue((provincesArray.object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state_code")
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
    
    //MARK:-  GET STATE API ACCORDING TO COUNTRY
    func getAllCountriesAndStatesAPI()
    {
        let params = NSMutableDictionary()
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
        ApiManager.sharedManager.getDataFromserver(params: params, postUrl: Constant.GETCOUNTRIESANDSTATESAPI as NSString, currentView: self.view)
        }
    }

    
    //MARK:-  hit sign up api
    func hitRegistrationApi()
    {
        let params = NSMutableDictionary()
        params.setValue(RandomObjects.getDeviceToken(), forKey: "device_token")
        params.setValue(txtName.text!, forKey: "name")
        params.setValue(txtEmail.text!, forKey: "email")
        params.setValue(txtUserName.text!, forKey: "username")
        params.setValue(txtPassword.text!, forKey: "password")
        params.setValue(txtPhoneNumber.text!, forKey: "phone")
        params.setValue("", forKey: "fav_liquor")
        params.setValue("", forKey: "fav_alcohol")
        
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
            params.setValue((statesArrray.object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state")
        }
        else
        {
            params.setValue((provincesArray.object(at: selectedStateIndex) as! NSDictionary).value(forKey: "abbreviation"), forKey: "state")
        }
        
        params.setValue(txtCity.text!, forKey: "city")
            params.setValue("3", forKey: "role")
            params.setValue("0", forKey: "work_at")
        
        params.setValue("", forKey: "outing_day")

        params.setValue("", forKey: "alcohol_online")
     
        print("registration parameters : \(params)")
        
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
            SVProgressHUD.show(withStatus: "Registeration in progress ...")
            ApiManager.sharedManager.postDataOnserver(
                params: params,
                postUrl:Constant.SIGNUPAPI as NSString,
                currentView: self.view)
        }
    }
    
    //MARK:- EMPTY SIGNUP SCREEN
    func emptySignUpScreen()
    {
        self.txtName.text = ""
            self.txtEmail.text = ""
            self.txtPassword.text = ""
            self.txtPhoneNumber.text = ""
            self.txtUserName.text = ""
        self.txtCountry.text = ""
        self.txtState.text = ""
        self.txtCity.text = ""
        self.selectedStateIndex = 0
        self.selectedfavSpiritIndex = 0
        self.selectedCountryIndex = 0
       self.view.isHidden = true
        
    }
    
        //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
    {
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            do {
                if serviceurl as String == Constant.SIGNUPAPI
                {
                    let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                        
                    if (jsonDictionary.value(forKey: "status") as! Bool) == true
                    {
                        
                        self.emptySignUpScreen()
                        
                        
                        SVProgressHUD.showSuccess(withStatus: "Registered Successfully.")
                        
                        self.savedataInstance.saveUserDetails(userdataDict: jsonDictionary["data"] as! NSDictionary)
                        
                        let dict = self.savedataInstance.getUserDetails()
                        self.view.isHidden = true
                        
                        self.delegate!.successFullSignupOpenStep()
                        
                    }
                    else
                    {
                        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                    }
                }
               else if serviceurl as String == Constant.GETCOUNTRIESANDSTATESAPI
                {
           let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                               
         if (jsonDictionary.value(forKey: "status") as! Bool) == true
         {
            
            
            if jsonDictionary.value(forKey: "data") != nil
            {
                
                self.provincesArray.removeAllObjects()
                self.statesArrray.removeAllObjects()
                
                self.provincesArray.addObjects(from: (jsonDictionary["data"] as! NSDictionary).value(forKey: "ProvincesAndTerritories") as! [Any])
                
                self.statesArrray.addObjects(from: (jsonDictionary["data"] as! NSDictionary).value(forKey: "States")as! [Any])
            }
         }
         else
         {
            RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
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
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //:-MARK PICKER VIEW DATA SOURCE AND DELEGATES :
    //MARK:- UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    //
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == countryPickerView
        {
            return countryArrray.count
        }
        else if pickerView == statesPickerView
        {
        if txtCountry.text! == "USA"
        {
        return statesArrray.count
        }
        else
        {
        return provincesArray.count
        }
        }
        else if pickerView == favSpiritPicker {
            return favSpiritArray.count
        }
        return 0
    }
    //
    //          //MARK:- UIPickerViewDelegates methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if pickerView == favSpiritPicker
        {
            return (favSpiritArray[row] as! String)
        }

        else if pickerView == countryPickerView
        {
            return (countryArrray[row] as! String)
        }
        else if pickerView == statesPickerView
        {
            if txtCountry.text! == "USA"
            {
                return ((self.statesArrray[row] as! NSDictionary).value(forKey: "full_name") as! String)
            }
            else
            {
            return ((provincesArray[row] as! NSDictionary).value(forKey: "full_name") as! String)
            }
        }
        else
        {
            print("else case run for picker string title fir riw ")
            return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
           if pickerView == favSpiritPicker
           {
               selectedfavSpiritIndex = row
           }
           else if pickerView == countryPickerView{
            selectedCountryIndex = row
           }
           else if pickerView == statesPickerView{
            selectedStateIndex = row
            }

    }
    
    
    //MARK:- TEXT FIELD DELEGATES

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    //UITEXTFIELD DELEGATS
    func textFieldDidEndEditing(_ textField: UITextField)
    {

        if textField  == txtCountry
        {
            cityArray.removeAllObjects()
            filteredCityArray.removeAllObjects()
            txtCity.text = ""
            citySelectionSuperView.isHidden = true
            
    self.txtState.isUserInteractionEnabled = true
    self.txtCity.isUserInteractionEnabled = true
            
            txtCountry.text = (countryArrray.object(at: selectedCountryIndex) as! String).uppercased()
                    
            txtState.inputView = statesPickerView
        
        if (txtCountry.text!).lowercased() == "usa"
        {
            txtState.text = ((statesArrray[0] as! NSDictionary).value(forKey: "full_name") as! String)
        }
        else
        {
        txtState.text = ((provincesArray[0] as! NSDictionary).value(forKey: "full_name") as! String)
        }
            self.getCitiesAccordingtoStateandCountry()

        }
        else  if textField  == txtState
        {
        if txtCountry.text?.isEmpty == true
        {
            return
        }
        if txtCountry.text! == "USA"
        {
            txtState.text = ((statesArrray[selectedStateIndex] as! NSDictionary).value(forKey: "full_name") as! String)
        }
        else
        {
            txtState.text = ((provincesArray[selectedStateIndex] as! NSDictionary).value(forKey: "full_name") as! String)
        }
            cityArray.removeAllObjects()
            filteredCityArray.removeAllObjects()
            txtCity.text = ""
            citySelectionSuperView.isHidden = true
            
        self.getCitiesAccordingtoStateandCountry()
            
    }
    }
    
    
    
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          
          if textField ==  txtPhoneNumber
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
                if cityStr.contains(textField.text!.lowercased())
                {
                    filteredCityArray.add(dict)
                }
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
    

}
