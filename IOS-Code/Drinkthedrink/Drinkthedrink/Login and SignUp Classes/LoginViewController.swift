//
//  LoginViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController,WebServiceDelegate
{

    let savedataInstance = SaveDataClass.sharedInstance
    
    @IBOutlet  var btnBackOnLoginScreen : UIButton!

    @IBOutlet  var btnForgotPassword : UIButton!
    @IBOutlet  var mainLoginViewSuperView: UIView!
    @IBOutlet  var btnmainLoginSuperViewDismiss: UIButton!
    @IBOutlet  var txtEmail: UITextField!
    @IBOutlet  var txtPassword: UITextField!
    @IBOutlet  var btnLogin: UIButton!
    @IBOutlet  var btnCrossLogin: UIButton!
    @IBOutlet  var shadowView: UIView!

    override func viewDidLoad()
    {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
 
    
    //MARK:-  LOGIN API HIT
    func hitLoginApi(){
            
        let params = NSMutableDictionary()
        params.setValue(RandomObjects.getDeviceToken(), forKey: "device_token")
        params.setValue(txtEmail.text!, forKey: "email")
        params.setValue(txtPassword.text!, forKey: "password")
        print("login parameters : \(params)")
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
        SVProgressHUD.show(withStatus: "Logging in...")
        ApiManager.sharedManager.postDataOnserver(
            params: params,
            postUrl:Constant.LOGINAPI as NSString,
            currentView: self.view)
            }
        }
    
       //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
    {
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                do {
            if serviceurl as String == Constant.LOGINAPI
            {
                let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                
                if (jsonDictionary.value(forKey: "status") as! Bool) == true
                {
                 
                    if jsonDictionary["data"] != nil
                    {
                    let dataDict = jsonDictionary["data"] as! NSDictionary
                    if "\(dataDict["role"] ?? "")" == "2" ||   "\(dataDict["role"] ?? "")" == "1"
                    {
                    SVProgressHUD.showError(withStatus: "Please try creating user in app.")

                    print("role is 2")
                        return
                    }
                    }
                    
                    
        SVProgressHUD.showSuccess(withStatus: "Login Successfully.")
                    
        self.savedataInstance.saveUserDetails(userdataDict: jsonDictionary["data"] as! NSDictionary)
                    
        let dict = self.savedataInstance.getUserDetails()
                    print(dict)
                    
        self.view.isHidden = true
                    
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
    
    
    @IBAction func loginButtonAction(_ sender: Any)
    {
        
    self.view.endEditing(true)
  
        if (txtEmail.text?.isEmpty == true && txtPassword.text?.isEmpty == true)
        {
            SVProgressHUD.showError(withStatus: "Please enter email and password.")
//            self.showAlert(self, title1: "Message", msg: "Please enter email and password.")
        }
        else if (txtEmail.text?.isValidEmail()) == false
        {
            SVProgressHUD.showError(withStatus: "Please enter valid email.")

//            self.showAlert(self, title1: "Message", msg: "Please enter valid email.")

        }
        else if (txtPassword.text!.count < 6)
        {
            SVProgressHUD.showError(withStatus: "Password should be minimum six characters long.")

//            self.showAlert(self, title1: "Message", msg: "Password should be minimum six characters long.")

        }
        else
        {
            //hit api for login
            self.hitLoginApi()
        }
        
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

