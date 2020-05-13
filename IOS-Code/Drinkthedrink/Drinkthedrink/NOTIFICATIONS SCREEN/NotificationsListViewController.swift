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


class NotificationsListViewController: UIViewController,WebServiceDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    var selectedIndexforAcceptingRequest : Int = -1
    var selectedIndexforDecliningRequest : Int = -1
    
    let savedataInstance = SaveDataClass.sharedInstance

    //LIST OF RECENT CHATS WITH LAST MESSAGE

    var notificationsListArray : [NotificationsList] = NSMutableArray() as! [NotificationsList]

    @IBOutlet  var imgViewEmptyState : UIImageView!
    
    @IBOutlet  var viewShadow : UIView!
    @IBOutlet  var tblNotifications : UITableView!
    @IBOutlet  var btnCrossOnNotificationScreen : UIButton!

    //BAR TENDER VIEW CONSTRAINTS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadUI()
    {
        //MARK:- ADD SHADOW COMMON
        RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.viewShadow)
        
        self.tblNotifications.dataSource = self
        self.tblNotifications.delegate = self
        self.tblNotifications.estimatedRowHeight = 80
        self.getNotificationsListAPI()
    
    }

    //MARK:- getNotificationsListAPI
       func getNotificationsListAPI(){
               
        let params = NSMutableDictionary()
        params.setValue(savedataInstance.id, forKey: "id")
        
        let status = Reach().connectionStatus()
           switch status {
        case .unknown, .offline:
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Please check your internet connection.")
        break
            
        default:
        ApiManager.sharedManager.delegate=self
        SVProgressHUD.show(withStatus: "Loading Notifications...")
        ApiManager.sharedManager.postDataOnserver(
               params: params,
               postUrl:Constant.GETALLNOTIFICATIONSAPI as NSString,
               currentView: self.view)
        }
    }

        //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
       {
               SVProgressHUD.dismiss()
               DispatchQueue.main.async {
                   do {
               if serviceurl as String == Constant.GETALLNOTIFICATIONSAPI
               {
                  let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                //MARK:- CLEAR NOTIFICATION WHEN NOTIFICATION API HIT
                UIApplication.shared.applicationIconBadgeNumber = 1
                UIApplication.shared.applicationIconBadgeNumber = 0
                UIApplication.shared.cancelAllLocalNotifications()
                
            if self.notificationsListArray.count > 0
            {
                self.notificationsListArray.removeAll()
            }
           if (jsonDictionary.value(forKey: "status") as! Bool) == true
           {

            let notifyArr = (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "data") as? NSArray

            for i in 0..<notifyArr!.count
            {

        var dict = NSDictionary()
                
        dict = notifyArr![i] as! NSDictionary
                  
        let messageHistoryObj = NotificationsList.init(
                follow_device_token: dict["follow_device_token"],
                follow_email: dict["follow_email"],
                 follow_by: dict["follow_by"],
                 follow_name: dict["follow_name"],
                 follow_profile_image: dict["follow_profile_image"],
                 follow_role: dict["follow_role"],
                 follow_username: dict["follow_username"],
                 notifications: dict["notifications"],
                 updated_at: dict["updated_at"])
            
        self.notificationsListArray.append(messageHistoryObj)
            
        }

       if self.notificationsListArray.count == 0
       {
           SVProgressHUD.showError(withStatus: "No notifications found.")
        self.imgViewEmptyState.isHidden = false
        self.tblNotifications.isHidden = true
       }
       else
       {
        self.tblNotifications.isHidden = false
        self.imgViewEmptyState.isHidden = true

        }

        self.tblNotifications.reloadData()
       }
       else
       {
        
        if self.notificationsListArray.count == 0
        {
         self.imgViewEmptyState.isHidden = false
         self.tblNotifications.isHidden = true
        }
        else
        {
         self.tblNotifications.isHidden = false
         self.imgViewEmptyState.isHidden = true
        }
        self.tblNotifications.reloadData()
        
        
    RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
        self.tblNotifications.reloadData()
       }
    }
    
    }catch let _error
    {
            print(_error)
    }
    }
    }
    
       //MARK:- ERROR RESPONSE
    func failureRsponseError(failureError: NSError?, serviceurl: NSString)
    {
    if self.notificationsListArray.count == 0
    {
        self.imgViewEmptyState.isHidden = false
        self.tblNotifications.isHidden = true
    }
    else
    {
        self.imgViewEmptyState.isHidden = true
        self.tblNotifications.isHidden = false
    }
    SVProgressHUD.dismiss()
    }
    
           //MARK:- UITABLE VIEW DELEGATE AND DATASOURCE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notificationsListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         
    let cell : NotificationRequestCell = tableView.dequeueReusableCell(withIdentifier: "NotificationRequestCell") as! NotificationRequestCell
    cell.selectionStyle = .none
    cell.btnAccept.tag = indexPath.row
    cell.btnDecline.tag = indexPath.row
        
    if indexPath.row % 2 == 0
    {
    cell.contentView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 242/255.0, alpha: 1.0)
    }
    else
    {
    cell.contentView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 254/255.0, alpha: 1.0)
    }
        
    cell.heightConstraintOfButtonAccept.constant = 0.0

    cell.btnAccept.isHidden = true
    cell.btnDecline.isHidden = true
        var messageStr : NSString? = ""
        if  "\(notificationsListArray[indexPath.row].notifications ?? "")" == "Followed"
        {
            if RandomObjects.checkValueisNilorNull(value: notificationsListArray[indexPath.row].follow_username) == false
            {
                messageStr = "You have started following " + "\(notificationsListArray[indexPath.row].follow_username ?? "")" as NSString

            }
            else if RandomObjects.checkValueisNilorNull(value: notificationsListArray[indexPath.row].follow_name) == false
            {
                messageStr = "You have started following " + "\(notificationsListArray[indexPath.row].follow_name ?? "")" as NSString
            }

        }
        else if "\(notificationsListArray[indexPath.row].notifications ?? "")" == "Following"
        {
            
            if RandomObjects.checkValueisNilorNull(value: notificationsListArray[indexPath.row].follow_username) == false
            {
                
                messageStr = "\(notificationsListArray[indexPath.row].follow_username ?? "")" + " has started following you" as NSString

            }
            else if RandomObjects.checkValueisNilorNull(value: notificationsListArray[indexPath.row].follow_name) == false
            {
                messageStr = "\(notificationsListArray[indexPath.row].follow_name ?? "")" + " has started following you" as NSString
            }

//            let messageStr = "\(notificationsListArray[indexPath.row].follow_username ?? "")" + "has started following"
        }
        
//    let message = NSString.init(format: "%@ has started following you.","\(notificationsListArray[indexPath.row].follow_username ?? "")")
                
    cell.lblStatus.text = ""
    cell.heightConstraintOfStatusLabel.constant = 20.0
        cell.lblMessage.text = messageStr as! String

        return cell
    }
    

    

    
    


    
}
