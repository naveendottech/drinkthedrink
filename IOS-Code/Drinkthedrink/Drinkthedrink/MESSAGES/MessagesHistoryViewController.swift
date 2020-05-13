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


class MessagesHistoryViewController: UIViewController,WebServiceDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet  var imgViewEmptyState : UIImageView!

    //LIST OF RECENT CHATS WITH LAST MESSAGE
    var messageHistoryArray  = [MessagesHistory]()
    var searchedMessageHistoryArray  = [MessagesHistory]()

    let savedataInstance = SaveDataClass.sharedInstance
    @IBOutlet  var viewShadow : UIView!
    @IBOutlet  var btnSearchOnMessageHistory : UIButton!
    @IBOutlet  var btnEditOnMessageHistory : UIButton!
    @IBOutlet  var tblMessagesHistory : UITableView!
    @IBOutlet  var btnforMesaagesSuperView: UIButton!
    @IBOutlet  var btnCrossOnMesaagesHistoryScreen : UIButton!
    @IBOutlet  var txtSearchMessagesHistoryUsers : UITextField!

    //BAR TENDER VIEW CONSTRAINTS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadUI()
    {
        RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.viewShadow)
        self.tblMessagesHistory.dataSource = self
//        self.tblMessagesHistory.delegate = self
        self.tblMessagesHistory.estimatedRowHeight = 80
        self.getMessagesHistory()
        
    self.txtSearchMessagesHistoryUsers.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    self.txtSearchMessagesHistoryUsers.autocorrectionType = UITextAutocorrectionType.no
        
        self.txtSearchMessagesHistoryUsers.clearButtonMode = .always


    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        searchedMessageHistoryArray.removeAll()
        
        if textField.text?.isEmpty == false
        {
            
            for i in 0..<messageHistoryArray.count
            {
            if "\(messageHistoryArray[i].from_id ?? "")" == "\(savedataInstance.id!)"
            {
                if "\(messageHistoryArray[i].to_name ?? "")".lowercased().contains(textField.text!.lowercased()) == true
                {            searchedMessageHistoryArray.append(messageHistoryArray[i])
                }
                else if "\(messageHistoryArray[i].message ?? "")".lowercased().contains(textField.text!.lowercased()) == true
                {
                searchedMessageHistoryArray.append(messageHistoryArray[i])
                }
            }
            else
            {
                if "\(messageHistoryArray[i].from_name ?? "")".lowercased().contains(textField.text!.lowercased()) == true
                {            searchedMessageHistoryArray.append(messageHistoryArray[i])
                }
                else if "\(messageHistoryArray[i].message ?? "")".lowercased().contains(textField.text!.lowercased()) == true
                {
                searchedMessageHistoryArray.append(messageHistoryArray[i])
                }
                
            }
            }
        }
        tblMessagesHistory.reloadData()
        
    }
    
    //MARK:- GET MESSAGE HISTORY
       func getMessagesHistory(){
               
        let params = NSMutableDictionary()
//        params.setValue(savedataInstance.id, forKey: "user_id")
        params.setValue(savedataInstance.id!, forKey: "user_id")
        
        print(params)
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
        SVProgressHUD.show(withStatus: "Loading Messages...")
        ApiManager.sharedManager.postDataOnserver(
               params: params,
               postUrl:Constant.GETMESSAGESHISTORYAPI as NSString,
               currentView: self.view)
        }
    }
    
    //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
       {
               SVProgressHUD.dismiss()
               DispatchQueue.main.async {
                   do {
               if serviceurl as String == Constant.GETMESSAGESHISTORYAPI
               {
                   let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary

            if self.messageHistoryArray.count > 0
            {
                self.messageHistoryArray.removeAll()
            }
                   
           if (jsonDictionary.value(forKey: "status") as! Bool) == true
           {
                   
           
            let messageArr = (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "data") as? NSArray
                               
            for i in 0..<messageArr!.count
            {
                                   
           var dict = NSDictionary()
            dict = messageArr![i] as! NSDictionary
           
            let messageHistoryObj = MessagesHistory.init(
                    created_at: dict["created_at"],
                    from_id: dict["from_id"],
                    from_name: dict["from_name"],
                    from_profileImage: dict["from_profileImage"],
                    img_base_url: dict["img_base_url"],
                    message: dict["message"],
            profile_folder_name: dict["profile_folder_name"],
                    to_id: dict["to_id"],
                    to_name: dict["to_name"],
                    to_profileImage: dict["to_profileImage"])
                
           self.messageHistoryArray.append(messageHistoryObj)
           }
           
       if self.messageHistoryArray.count == 0
       {
           SVProgressHUD.showError(withStatus: "No Messages Found")
        self.tblMessagesHistory.isHidden = true
        self.imgViewEmptyState.isHidden = false
       }
       else
       {
        self.tblMessagesHistory.isHidden = false
        self.imgViewEmptyState.isHidden = true
        }
            
            
        self.tblMessagesHistory.reloadData()
       }
       else
       {
        if self.messageHistoryArray.count == 0
        {
            self.tblMessagesHistory.isHidden = true
            self.imgViewEmptyState.isHidden = false
        }
        else
        {
            self.tblMessagesHistory.isHidden = false
            self.imgViewEmptyState.isHidden = true
        }
    RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
        self.tblMessagesHistory.reloadData()
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
            SVProgressHUD.dismiss()
       }
       

    
          //MARK:- TABLEVIEW DELEGATE AND DATASOURCE
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
          {
            
            if txtSearchMessagesHistoryUsers.text?.isEmpty == false
            {
            return searchedMessageHistoryArray.count
            }
            else
            {
            return messageHistoryArray.count
            }
            
          }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell : MessageHistoryCell = tableView.dequeueReusableCell(withIdentifier: "MessageHistoryCell") as! MessageHistoryCell
        cell.selectionStyle = .none

        var messageDetailObj : MessagesHistory?
        
        if txtSearchMessagesHistoryUsers.text?.isEmpty == true
        {
            if messageHistoryArray.count > 0 {
            messageDetailObj = messageHistoryArray[indexPath.row]
            }
        }
        else
        {
            if searchedMessageHistoryArray.count > 0 {
            messageDetailObj = searchedMessageHistoryArray[indexPath.row]
            }
        }
        
        if messageDetailObj != nil
        {
        if "\(messageDetailObj?.from_id ?? "")" == "\(savedataInstance.id!)"
        {
            print("came om same from id ")
            cell.lblName.text = "\(messageDetailObj?.to_name ?? "")"
            cell.lblMessage.text = "\(messageDetailObj?.message ?? "")"
            
            var imgStr = "\(messageDetailObj?.img_base_url ?? "")" + "\(messageDetailObj?.profile_folder_name ?? "")" + "\(messageDetailObj?.to_profileImage ?? "")"
                       
            imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                                
            cell.imgViewUser.contentMode = .scaleToFill
            cell.imgViewUser.sd_imageIndicator = SDWebImageActivityIndicator.gray

            cell.imgViewUser.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
            
        }
        else if "\(messageDetailObj?.to_id ?? "")" == "\(savedataInstance.id!)"
        {
            print("came om same to id ")
            cell.lblName.text = "\(messageDetailObj?.from_name ?? "")"
            
            cell.lblMessage.text = "\(messageDetailObj?.message ?? "")"
            
            var imgStr = "\(messageDetailObj?.img_base_url ?? "")" + "\(messageDetailObj?.profile_folder_name ?? "")" + "\(messageDetailObj?.from_profileImage ?? "")"
            
            imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                     
            cell.imgViewUser.contentMode = .scaleToFill
            cell.imgViewUser.sd_imageIndicator = SDWebImageActivityIndicator.gray

            cell.imgViewUser.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
            
        }
            cell.imgViewUser.layer.cornerRadius =  51 / 2
            cell.imgViewUser.clipsToBounds = true
            cell.imgViewUser.layer.masksToBounds = true
        }
        
        return cell
    }
  
    
}
