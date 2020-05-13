//
//  LoginViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedbackViewController: UIViewController,WebServiceDelegate,UITextViewDelegate
{

//    @IBOutlet  var lblFeedbackDummy: UILabel!

    let savedataInstance = SaveDataClass.sharedInstance
    
    @IBOutlet  var btnMakeResponder: UIButton!

    @IBOutlet  var mainFeedbackViewSuperView: UIView!
    @IBOutlet  var btnmainFeedbackSuperViewDismiss: UIButton!
    @IBOutlet  var txtfeedback: UITextView!

    @IBOutlet  var btnsubmitFeedback: UIButton!
    @IBOutlet  var btnCrossFeedback: UIButton!
    @IBOutlet  var shadowView: UIView!

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
    func sendFeedbackAPI()
    {

        let params = NSMutableDictionary()
        params.setValue(txtfeedback.text!, forKey: "feedback")

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
        SVProgressHUD.show(withStatus: "Sending feedback ...")
        ApiManager.sharedManager.postDataOnserver(
            params: params,
            postUrl:Constant.SENDFEEDBACKAPI as NSString,
            currentView: self.view)
            }
        }
    
    
        //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
    {
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
                do {
            if serviceurl as String == Constant.SENDFEEDBACKAPI
            {
                let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                if jsonDictionary.value(forKey: "status") == nil
                {
                    self.view.isHidden = true
                    
                    SVProgressHUD.showError(withStatus: "Something went wrong")

                    return
                }
                
                
                if (jsonDictionary.value(forKey: "status") as! Bool) == true
                {
                 SVProgressHUD.showSuccess(withStatus: "Feedback sent Successfully.")
                    
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
        SVProgressHUD.dismiss()
    }
    
    @IBAction func makeFeedbackTextFieldFirsrResponder(_ sender: Any)
    {
        txtfeedback.becomeFirstResponder()
    }

    @IBAction func submitFeedBackAction(_ sender: Any)
    {
        self.view.endEditing(true)
        if (txtfeedback.text?.isEmpty == true)
        {
            SVProgressHUD.showError(withStatus: "Please enter feedback.")
        }
        else
        {
            //hit api for login
            self.sendFeedbackAPI()
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {

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

