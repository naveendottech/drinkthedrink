//
//  LoginViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdatePasswordForgotViewController: UIViewController,WebServiceDelegate
{
    var user_id : Any? = nil
    
    let savedataInstance = SaveDataClass.sharedInstance
    @IBOutlet  var txtPasswordonUpdatePassword: UITextField!
    @IBOutlet  var btnsubmitUpdatePassword: UIButton!
    @IBOutlet  var btncrossUpdatePassword: UIButton!
    @IBOutlet  var shadowView: UIView!

    override func viewDidLoad()
    {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadUI ()
    {
    RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.shadowView)
    txtPasswordonUpdatePassword.isSecureTextEntry = true
    }
    
    //MARK:-  UPDATE PASSWORD API
    func hitUpdatePasswordApi()
    {
        print(savedataInstance.getUserDetails() as Any)
        
        let params = NSMutableDictionary()
        params.setValue("123456", forKey: "old_password")
        params.setValue(txtPasswordonUpdatePassword.text!, forKey: "password")
        params.setValue("forget", forKey: "key")

        if savedataInstance.id == nil
        {
            params.setValue(user_id, forKey: "user_id")
            print("id is nil in this case")
        }
        else{
        params.setValue(savedataInstance.id, forKey: "user_id")
        }
        
        print("update passwords parameters : \(params)")
        print("update passwords api   : \(Constant.UPDATEPASSWORDAPI)")

        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "Please check your internet connection.")
        break
            // Show alert if internet not available.
        default:
        ApiManager.sharedManager.delegate=self
        SVProgressHUD.show(withStatus: "Updating password...")
        ApiManager.sharedManager.postDataOnserver(
            params: params,
            postUrl:Constant.UPDATEPASSWORDAPI as NSString,
            currentView: self.view)
            }
        }
    
       //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
    {
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                do {
            if serviceurl as String == Constant.UPDATEPASSWORDAPI
            {
                let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                
                if (jsonDictionary.value(forKey: "status") as! Bool) == true
                {
                    self.txtPasswordonUpdatePassword.text = ""
                    SVProgressHUD.showSuccess(withStatus: "New Password updated successfully.")
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
    
    //MARK:-   ERROR SERVER RESPONSE
    func failureRsponseError(failureError: NSError?, serviceurl: NSString) {
    }
    
    //MARK:-  CROSS BUTTON ON UPDATE PASSWORD
    @IBAction func crossButtonClickedonUpdatePasswordScreen(_ sender: Any)
    {
        self.view.endEditing(true)
        self.view.isHidden = true
        self.txtPasswordonUpdatePassword.text = ""
    }

    //MARK:-  UPDATE PASSWORD ACTION CLICK
    @IBAction func updatePasswordAction(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if txtPasswordonUpdatePassword.text?.isEmpty == true {
        SVProgressHUD.showError(withStatus: "Please enter new password.")
        }
        else if (txtPasswordonUpdatePassword.text!.count < 6)
        {
        SVProgressHUD.showError(withStatus: "Password should be atleast six characters long.")
        }
        else
        {
            //hit api for login
            self.hitUpdatePasswordApi()
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


