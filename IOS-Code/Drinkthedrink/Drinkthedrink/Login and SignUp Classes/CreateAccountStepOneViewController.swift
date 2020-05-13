//
//  SignUpViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateAccountStepOneViewController: UIViewController,WebServiceDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    var selectedUserTypeIndex : Int = 0

    @IBOutlet  var collectionViewUserTypeOnSignUpScreen: UICollectionView!
    @IBOutlet  var viewSpeciality: UIView!

//    @IBOutlet  var lblthisAppWillsendcustomers: UILabel!
    
     var workingAtArray = NSArray()
    
     var purchaseAlcoholArray = NSArray()
    var purchaseAlcoholPicker = UIPickerView()
    var selectedpurchaseAlcoholIndex : Int = 0
    @IBOutlet  var txtPurchaseAlcohol: UITextField!
    
    var selectedfavAlcohol: Int = 0
     var favAlcoholPicker = UIPickerView()
     var favAlcoholArray = NSArray()
    @IBOutlet  var txtFavAlcohol: UITextField!

    var selectedDayIndex: Int = 0
    var dayPicker = UIPickerView()
    var dayArray = NSArray()
    @IBOutlet  var txtDay: UITextField!

    //bars picker for search

    
    
    let savedataInstance = SaveDataClass.sharedInstance

    @IBOutlet  var shadowView: UIView!
    
    @IBOutlet  var btnonmainSignUpViewSuperView: UIButton!
    @IBOutlet  var mainSignUpViewSuperView: UIView!
    @IBOutlet  var scrollViewforSignUp: UIScrollView!
    @IBOutlet  var btnCrossCreateAccount: UIButton!
    //new things
    @IBOutlet  var txtSpeciality: UITextField!

 
    
    @IBOutlet  var btnSignUp: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createUIonCreateAccount()
    {
        txtDay.text = ""
        txtFavAlcohol.text = ""
        txtPurchaseAlcohol.text = ""
        txtSpeciality.text = ""
//        workingAtArray = NSArray.init(objects: "Bar Tender","Liquor Store","Promoter","Other")
        workingAtArray = NSArray.init(objects: "Hospitality","Retail Liquor","Event")
        
        
        
        favAlcoholArray = NSArray.init(objects: "Vodka","Gin","Rum","Bourbon", "Tequila")
        favAlcoholPicker = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        favAlcoholPicker.backgroundColor = UIColor.white
        favAlcoholPicker.delegate = self
        favAlcoholPicker.dataSource = self
        txtFavAlcohol.inputView = favAlcoholPicker
        txtFavAlcohol.delegate = self

        purchaseAlcoholArray = NSArray.init(objects: "YES","NO")
        purchaseAlcoholPicker = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        
            purchaseAlcoholPicker.backgroundColor = UIColor.white
            purchaseAlcoholPicker.delegate = self
            purchaseAlcoholPicker.dataSource = self
            txtPurchaseAlcohol.inputView = purchaseAlcoholPicker
            txtPurchaseAlcohol.delegate = self
                
        dayArray = NSArray.init(objects: "MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY","SUNDAY")
        dayPicker = UIPickerView(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.size.width, height: 150))
        
        dayPicker.backgroundColor = UIColor.white
        dayPicker.delegate = self
        dayPicker.dataSource = self
        txtDay.inputView = dayPicker
        txtDay.delegate = self
        
        collectionViewUserTypeOnSignUpScreen.reloadData()
        
    }
    
    @IBAction func signUpButtonAction(_ sender: Any)
    {
        self.view.endEditing(true)
        self.hitCreateAccountApi()
    }
    
    @IBAction func crossButonClicked(_ sender: Any)
    {
        self.view.endEditing(true)
               
             selectedfavAlcohol = 0
             selectedDayIndex = 0
             selectedpurchaseAlcoholIndex = 0
             txtDay.text = ""
             txtFavAlcohol.text = ""
             txtDay.text = ""
             txtSpeciality.text = ""
        self.view.isHidden = true
    }

    
    @IBAction func continueButtonAction(_ sender: Any)
       {
        selectedfavAlcohol = 0
        selectedDayIndex = 0
        selectedpurchaseAlcoholIndex = 0
        txtDay.text = ""
        txtFavAlcohol.text = ""
        txtDay.text = ""
        txtSpeciality.text = ""
        
        self.view.endEditing(true)
        self.view.isHidden = true
    
       }
    
    //MARK:- CREATE ACCOUNT API
        func hitCreateAccountApi()
        {
            let params = NSMutableDictionary()

                 if selectedUserTypeIndex == 0
                    {
                        //hospatility :
                        params.setValue("7", forKey: "role")

                    }
                    else  if selectedUserTypeIndex == 1
                    {
                        params.setValue("8", forKey: "role")
            
                    }
                    else  if selectedUserTypeIndex == 2
                    {
                        params.setValue("4", forKey: "role")
            
                    }
                    
            
            params.setValue(savedataInstance.id!, forKey: "user_id")
            params.setValue(txtFavAlcohol.text!, forKey: "fav_alcohol")
            params.setValue(txtDay.text!, forKey: "outing_day")
            
            if selectedpurchaseAlcoholIndex == 0
            {
                params.setValue("yes", forKey: "alcohol_online")
            }
            else if selectedpurchaseAlcoholIndex == 1
            {
                params.setValue("no", forKey: "alcohol_online")
            }

            params.setValue(txtSpeciality.text!, forKey: "speciality")

            
         
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
                    postUrl:Constant.updateRoleApi as NSString,
                    currentView: self.view)
            }
        }
    
    

    
    func serverReponse(responseData: Data?, serviceurl: NSString)
    {
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            do {
                if serviceurl as String == Constant.updateRoleApi
                {
                    let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    if (jsonDictionary.value(forKey: "status") as! Bool) == true
                    {
                                                
                        SVProgressHUD.showSuccess(withStatus: "Registered Successfully.")
                        
                        self.savedataInstance.saveUserDetails(userdataDict: jsonDictionary["data"] as! NSDictionary)
                        
                        let dict = self.savedataInstance.getUserDetails()
                        print(dict)
                        self.view.isHidden = true
                        self.selectedfavAlcohol = 0
                        self.selectedDayIndex = 0
                        self.selectedpurchaseAlcoholIndex = 0
                        self.txtDay.text = ""
                        self.txtFavAlcohol.text = ""
                        self.txtDay.text = ""
                        self.txtSpeciality.text = ""
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
                
//                self.provincesArray.removeAllObjects()
//                self.statesArrray.removeAllObjects()
//
//                self.provincesArray.addObjects(from: (jsonDictionary["data"] as! NSDictionary).value(forKey: "ProvincesAndTerritories") as! [Any])
//
//                self.statesArrray.addObjects(from: (jsonDictionary["data"] as! NSDictionary).value(forKey: "States")as! [Any])
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
        
        if pickerView == favAlcoholPicker
        {
            return favAlcoholArray.count
        }
        else if pickerView == dayPicker
        {
            return dayArray.count
        }
        else if pickerView == purchaseAlcoholPicker
        {
            return purchaseAlcoholArray.count
        }
        return 0
    }
    //
    //          //MARK:- UIPickerViewDelegates methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == favAlcoholPicker
        {
            return (favAlcoholArray[row] as! String)
        }
        else if pickerView == dayPicker
        {
            return (dayArray[row] as! String)
        }
        else if pickerView == purchaseAlcoholPicker
        {
            return (purchaseAlcoholArray[row] as! String)
        }
        else
        {
            print("else case run for picker string title fir riw ")
            return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == favAlcoholPicker
        {
            selectedfavAlcohol = row
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
    
   
    //MARK:- UITEXTFIELD DELEGATS
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtFavAlcohol
        {
            txtFavAlcohol.text  = favAlcoholArray[selectedfavAlcohol] as? String
        }
        else if textField == txtDay
        {
            txtDay.text  = dayArray[selectedDayIndex] as? String
        }
        else if textField == txtPurchaseAlcohol
        {
            txtPurchaseAlcohol.text = purchaseAlcoholArray[selectedpurchaseAlcoholIndex] as? String
        }
        
    }
    
    
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
      {
              return true
      }
    
        //MARK:- UICOLLECTION VIEW DELEGATES AND DATA SOURCE
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserTypeSignUpCell", for: indexPath) as! UserTypeSignUpCell
        
        cell.lblFilterName.text = "\(workingAtArray.object(at: indexPath.item))"
        
        if selectedUserTypeIndex == indexPath.item
        {
            cell.btnFilterInCollectionView.setImage(UIImage.init(named: "selectionon"), for: .normal)
        }
        else
        {
            cell.btnFilterInCollectionView.setImage(UIImage.init(named: "selectionoff"), for: .normal)

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workingAtArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: collectionView.frame.size.width / 2.2, height: 35)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.item != selectedUserTypeIndex || selectedUserTypeIndex == -1
        {
            selectedUserTypeIndex = indexPath.item
            collectionView.reloadData()
        }
    }
}
