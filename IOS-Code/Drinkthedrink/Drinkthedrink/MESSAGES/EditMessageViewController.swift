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

class EditMessageViewController: UIViewController ,WebServiceDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    @IBOutlet  var bottomScrollView : UIView!

    
    var otherUserDeviceToken : String = ""
    var imageData : NSData? = nil
    
    //LIST OF RECENT CHATS WITH LAST MESSAGE
    var peopleArray  = [PeopleList]()
    var messagesArray  = [SingleUserMessages]()
    var selectedPeopleObj  :PeopleList?

    let savedataInstance = SaveDataClass.sharedInstance
    @IBOutlet  var viewShadow : UIView!
    @IBOutlet  var btnSendMessage  : UIButton!
    @IBOutlet  var btnBackArrow  : UIButton!
    


    @IBOutlet  var lbldateforMessages : UILabel!

    @IBOutlet  var selectedUserViewOnEditMessages : UIView!
    @IBOutlet  var lblSelectedUserName : UILabel!
    @IBOutlet  var imgSelectedUser: UIImageView!
    @IBOutlet  var searchBarView : UIView!
    
    
    @IBOutlet  var txtMessageonEditMessage : UITextView!
    @IBOutlet weak var bottomViewSuperViewofEditMessages: UIView!
    @IBOutlet  var btnSearchOnEditMessage : UIButton!
    @IBOutlet  var tblUsersOnEditMessage : UITableView!
    @IBOutlet  var btnforEditMesaageSuperView: UIButton!
    @IBOutlet  var btnCrossOnEditMesaagesScreen : UIButton!
    @IBOutlet  var txtSearchEditMessagesUsers : UITextField!
    @IBOutlet weak var  bottomViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintofScrollView: NSLayoutConstraint!
    var  keyboardHeight : Int = 0
    var isCreatingNewMessage : Bool = false
    
    @IBOutlet weak var txtViewHeightConstraint: NSLayoutConstraint!

    //BAR TENDER VIEW CONSTRAINTS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if self.view.isHidden == true {
//         print("view is hidden now")
            return
        }
        else{
//         print("view is not hidden now")
        }
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = Int(keyboardSize.height)
                 keyboardHeight = ((keyboardHeight + 30) - 165 )
            
            self.view.layoutIfNeeded()
//            65 done bar
//            165 already given bottom constraint
          }

    }
    
    @objc func loadUI()
    {
    self.txtSearchEditMessagesUsers.clearButtonMode = .always

    bottomConstraintofScrollView.constant = 10.0
    RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.viewShadow)
        self.txtMessageonEditMessage.delegate = self

        
        if isCreatingNewMessage == true
        {
            selectedPeopleObj = nil
            selectedUserViewOnEditMessages.isHidden = true
            searchBarView.isHidden = false

            peopleArray.removeAll()
            txtSearchEditMessagesUsers.text = ""
            tblUsersOnEditMessage.reloadData()
        }
        else
        {
        searchBarView.isHidden = true
        selectedUserViewOnEditMessages.isHidden = false
        peopleArray.removeAll()

        lblSelectedUserName.text = "\(selectedPeopleObj?.username ??  selectedPeopleObj?.name ?? selectedPeopleObj?.email ?? "")"
            
        var imgStr = "\(Constant.FollowersprofilePictureBaseUrl)" + "\(selectedPeopleObj?.profile_image ?? "")"
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                      
        imgSelectedUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
        imgSelectedUser.contentMode = .scaleToFill
        imgSelectedUser.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
        imgSelectedUser.layer.cornerRadius =  51 / 2
        imgSelectedUser.clipsToBounds = true
        imgSelectedUser.layer.masksToBounds = true
        self.getMessagesWithParticularUserAPI()
            
        }
        lbldateforMessages.textColor = UIColor.init(red: 218/255.0, green: 219/255.0, blue: 214/255.0, alpha: 1.0)
        //SHADOW WORK FOLLOWING SCREEN
       
        self.tblUsersOnEditMessage.estimatedRowHeight = 80
        
        self.txtSearchEditMessagesUsers.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        self.txtMessageonEditMessage.autocorrectionType = UITextAutocorrectionType.no
        self.txtSearchEditMessagesUsers.autocorrectionType = UITextAutocorrectionType.no
                
        var otherUserId: Int = 5
            
        if selectedPeopleObj != nil{
            otherUserId = selectedPeopleObj?.user_id as! Int
        }
        print(otherUserId)
        

        if  otherUserId != 1
            {
        self.perform(#selector(openTextFieldofMessage), with: nil, afterDelay: 0.5)
        }
//
//
        
        if otherUserId != 1
        {
            bottomScrollView.isHidden = false
        }
        else
        {
            bottomScrollView.isHidden = true
        }
        
    }
    
   @objc func openTextFieldofMessage()
   {
    if isCreatingNewMessage == true
    {
    txtSearchEditMessagesUsers.becomeFirstResponder()
    }
    else{
    txtMessageonEditMessage.becomeFirstResponder()
    }
   }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        
        if textField.text?.isEmpty == false
        {
            tblUsersOnEditMessage.isHidden = false
        }
        else
        {
            tblUsersOnEditMessage.isHidden = true
        }
        
        tblUsersOnEditMessage.reloadData()
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        bottomConstraintofScrollView.constant = 10.0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        print(keyboardHeight)
            //165 is bottom constraint already given
        
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: Double(0.3), animations: {
            self.bottomConstraintofScrollView.constant = CGFloat(self.keyboardHeight  + 10)
                self.view.layoutIfNeeded()
            })
        
        self.perform(#selector(scrolltoLastRow), with: nil, afterDelay: 0.7)

        
        
        
    }
    
    
    @objc   func scrolltoLastRow(){
                if isCreatingNewMessage == false
                {
                if messagesArray.count > 0
                {
                    
//                    IndexPath.init(row: (messagesArray.count - 1), section: 0)
                    
                    
                    
                    
        tblUsersOnEditMessage.scrollToRow(at: IndexPath.init(row: (messagesArray.count - 1), section: 0), at: .bottom, animated: true)
                }
        
                }
                
    }
    
    func textViewDidChange(_ textView: UITextView) {
           if bottomViewSuperViewofEditMessages.frame.size.height == 100
           {
             txtViewHeightConstraint.constant = textView.contentSize.height
               txtMessageonEditMessage.isScrollEnabled = true
           }
           else{
              txtViewHeightConstraint.constant = 34
               txtMessageonEditMessage.isScrollEnabled = false
           }
           print(txtViewHeightConstraint.constant)
           print(textView.contentSize)
       }
    

    
    @IBAction func searchPeopleClicked(_ sender: Any)
    {
        if txtSearchEditMessagesUsers.text!.isEmpty == true {
            SVProgressHUD.showError(withStatus: "Please enter text.")
        }
        else{
            self.searchUsersForSendMessage()
        }
    }

    
        @IBAction func sendMessageAction(_ sender: Any)
        {
    //        self.view.endedit
            
            if selectedPeopleObj  == nil {
                  SVProgressHUD.showError(withStatus: "Please search and select user to send message.")
            }
            
            else if txtMessageonEditMessage.text?.isEmpty == true
            {
                SVProgressHUD.showError(withStatus: "Please enter message to send.")
                
            }
            else
            {
                self.sendMessagetoSelectedUser()
              
            }
            
        }
    
        //MARK:- SEARCH USERS FOR SEND MESSAGE
       func searchUsersForSendMessage()
       {
        let params = NSMutableDictionary()
        params.setValue(txtSearchEditMessagesUsers.text, forKey: "search")
        params.setValue(savedataInstance.id, forKey: "user_id")
        print("search people api params \(params)")
        
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
        SVProgressHUD.show(withStatus: "Searching Users...")
        ApiManager.sharedManager.postDataOnserver(
               params: params,
               postUrl:Constant.SEARCHPEOPLEAPIONEDITMESSAGES as NSString,
               currentView: self.view)
        }
    }
    //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
       {
               SVProgressHUD.dismiss()
               DispatchQueue.main.async {
                   do {
               if serviceurl as String == Constant.SEARCHPEOPLEAPIONEDITMESSAGES
               {
                   let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
                if self.peopleArray.count > 0
                {
                    self.peopleArray.removeAll()
                }
                
           if (jsonDictionary.value(forKey: "status") as! Bool) == true
           {
            
            
            if let arrUsers: NSArray =  ((jsonDictionary["data"] as? NSDictionary)?.value(forKey: "data")) as? NSArray
            {
                if arrUsers.count > 0
                {
                    
                  for i in 0..<arrUsers.count
                  {
                      var dict = NSDictionary()
                      dict = arrUsers[i] as! NSDictionary
   var user_blocked_id :Int = 0
    let myIdStr :String = "\(self.savedataInstance.id!)"
        let myId :Int = Int(myIdStr)!

             if dict.value(forKey:  "user_blocked_id") != nil
             {
                user_blocked_id  = dict.value(forKey:  "user_blocked_id") as! Int
             }
    print("user_blocked_id is \(user_blocked_id)")
    print("myId is \(myId)")

    if user_blocked_id != myId{
    
        print("device token is available \(dict["device_token"] ?? "EMPTY DEVICE TOKEN ")")
        if "\(dict["user_id"]!)" != "\(self.savedataInstance.id!)"
        {
                                
    let peopleObj = PeopleList.init(
        user_blocked_by:  dict["user_blocked_by"],
        user_blocked_id:  dict["user_blocked_id"],
        block_id:  dict["block_id"],
        user_1: dict["user_1"],
        user_2: dict["user_2"],
        device_token: dict["device_token"],
        initiate_id: dict["initiate_id"],
        address: dict["address"],
        city:  dict["city"],
        country: dict["country"],
        distance: dict["distance"],
        email: dict["email"],
        fav_cocktail: dict["fav_cocktail"],
        fav_drink: dict["fav_drink"],
        fav_spirit: dict["fav_spirit"],
        follow_by: dict["follow_by"],
        follow_to: dict["follow_to"],
        follower: dict["follower"],
        following: dict["following"],
        my_status: dict["my_status"],
        name: dict["name"],
        phone: dict["phone"],
        profile_image: dict["profile_image"],
        public_user: dict["public_user"],
        requested: dict["requested"],
        role: dict["role"],
        state: dict["state"],
        user_id: dict["user_id"],
        username: dict["username"],
        user_latitude: dict["user_latitude"],
        user_longitude: dict["user_longitude"],
        visible_bar: dict["visible_bar"],
        visible_for: dict["visible_for"],
        visibility_status: dict["visibility_status"],
        person_status: dict["person_status"])
           
        self.peopleArray.append(peopleObj)
            }
            }
            }
            }
            print(arrUsers)
            }
                        
            if self.peopleArray.count == 0
            {
                SVProgressHUD.showError(withStatus: "No Users found")
            }
            else
            {
                
            }
            self.tblUsersOnEditMessage.reloadData()

       }
       else
       {
       
        if self.peopleArray.count > 0
        {
            self.peopleArray.removeAll()
        }
        
        self.tblUsersOnEditMessage.reloadData()
    RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
       }

    }
    else if serviceurl as String == Constant.SENDMESSAGEAPI
        {
        let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                        
        if (jsonDictionary.value(forKey: "status") as! Bool) == true
        {
            SVProgressHUD.showSuccess(withStatus: "Message sent successfully.")
            
            self.txtMessageonEditMessage.text = ""
            self.isCreatingNewMessage = false
            
            self.getMessagesWithParticularUserAPI()
        }
        else
        {
        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
     //        self.tblMessagesHistory.reloadData()
        }

         }
       else if serviceurl as String == Constant.GETMESSAGESWITHPARTICULARUSER
        {
           let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
      
      
            if self.messagesArray.count > 0
            {
                self.messagesArray.removeAll()
            }
       
            
            if (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey:"follow_device_token") != nil
            {
                self.otherUserDeviceToken = (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey:"follow_device_token") as! String
            }
            print("other user device token is \(self.otherUserDeviceToken)")
                        
            
           if (jsonDictionary.value(forKey: "status") as! Bool) == true
           {
                       
        if let messagearr: NSArray =  (jsonDictionary["data"] as? NSDictionary)?.value(forKey: "data") as? NSArray
        {
        if messagearr.count > 0
        {
                               
        for i in 0..<messagearr.count
        {
        var dict = NSDictionary()
        dict = messagearr[i] as! NSDictionary
                                 
            let messageObj = SingleUserMessages.init(
                chat: dict["chat"],
                date: dict["date"],
                from: dict["from"],
                to: dict["to"],
                img_base_url: dict["img_base_url"],
                message_image: dict["message_image"])
            
        self.messagesArray.append(messageObj)
            }
            
            
        }
                           
        print(messagearr)
        }
                                   
        if self.messagesArray.count == 0
        {
    SVProgressHUD.showError(withStatus: "No Messages found")
            self.lbldateforMessages.text = ""
            self.tblUsersOnEditMessage.isHidden = true
        }
        else
        {
            self.tblUsersOnEditMessage.isHidden = false
        }
        
        self.tblUsersOnEditMessage.reloadData()
            
            
        if self.messagesArray.count > 0
       {
        self.tblUsersOnEditMessage.scrollToRow(at: IndexPath.init(row: (self.messagesArray.count - 1), section: 0), at: .bottom, animated: true)
        }
            
    }
    else
    {
        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
    }
               }
                    else   if serviceurl as String == Constant.followUnFollowApi
                    {
                        let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                                                             
                            if (jsonDictionary.value(forKey: "status") as! Bool) == true
                                 {

                                  SVProgressHUD.dismiss()
                                    
//                                    self.getMyProfileandUpdateData()

                                  SVProgressHUD.showSuccess(withStatus: "User followed successfully")
                                    
                                self.searchUsersForSendMessage()

                      
                                 }
                                 else
                                 {
                                     SVProgressHUD.dismiss()
                                 RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                                 }
                                }
                                        else   if serviceurl as String == Constant.blockUnblockAPI
                                        {
                                            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                                        
                                            print("jsondictionary for api :\(Constant.followUnFollowApi) and response is \(jsonDictionary)")
                                                             
                                                if (jsonDictionary.value(forKey: "status") as! Bool) == true
                                                     {

                                                      SVProgressHUD.dismiss()
                                                                              
                                                    self.searchUsersForSendMessage()

                                          
                                                     }
                                                     else
                                                     {
                                                         SVProgressHUD.dismiss()
                                                     RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                                                     }
                                                    }
                    
    }catch let _error
    {
            print(_error)
    }
    }
        }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")

        if isCreatingNewMessage == false
        {
            self.setvalueofdate()
        }
        else
        {
            lbldateforMessages.text = ""
        }
    }
    func setvalueofdate(){
        let indexpatharray = (self.tblUsersOnEditMessage.indexPathsForVisibleRows! as NSArray)
        if indexpatharray.count > 0
        {
            let indexpathfirst : IndexPath = indexpatharray[0] as! IndexPath
            
            let dateformatter = DateFormatter()
                      dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let fullDate = dateformatter.date(from: messagesArray[indexpathfirst.row].date! as! String)
            print("fullDate is \(fullDate)")
            dateformatter.dateFormat = "yyyy-MM-dd"
            let onlydateStr = dateformatter.string(from: fullDate!)
            print("onlydateStr is \(onlydateStr)")
            lbldateforMessages.text = onlydateStr
            
        }
        else
        {
//            lbldateforMessages.text = ""
        }
    //        print("count of visible rows\(indexpatharray.count)")
        }
//
    

    
    
    //MARK:- ERROR RESPONSE
    func failureRsponseError(failureError: NSError?, serviceurl: NSString)
    {        
    }
       
        //MARK:- TABLE VIEW DELEGATE AND DATASOURCE 
    
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
       {
        if isCreatingNewMessage == true {
            return 71
        }
        else
        {
        return UITableView.automaticDimension
        }
       }
    
          //MARK:- TABLEVIEW DELEGATE AND DATASOURCE
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
          {
            if isCreatingNewMessage == false
            {
            return messagesArray.count
            }
            else
            {
           return peopleArray.count
            }
          }
    

    
    
    
    func setFollowButtonTextAccordingtoCases(btnFollow:UIButton,index:Int)
    {
        
        var user_1 :Int = 0
        var user_2 :Int = 0

        if peopleArray[index].user_1 != nil{
        user_1  = peopleArray[index].user_1 as! Int
        }
        if peopleArray[index].user_2 != nil
        {
        user_2  = peopleArray[index].user_2 as! Int
        }
        
        let myIdStr :String = "\(savedataInstance.id!)"
        let myId :Int = Int(myIdStr)!
        print("my id check crashing previously\(myId)")
        let blueAppColor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)

        
        //new cases start
        if user_1 == 0 && user_2 == 0
        {
            print("PUBLIC USER == 1 CASE 1 \(index)")
                       btnFollow.backgroundColor = blueAppColor
                       btnFollow.setTitle("Follow", for: .normal)
                       print("follow to api case 1")
        }
        else if myId == user_1
        {
            
            btnFollow.backgroundColor = blueAppColor
            btnFollow.setTitle("Follower", for: .normal)
            print("follow to api case 1")
        }
        else
        {
            btnFollow.backgroundColor = blueAppColor
            btnFollow.setTitle("Follow", for: .normal)
            print("follow to api case 1")
        }
       
    }
    
    //MARK:- FOLLOW UNFOLLOW SEARCH PEOPLE
     @objc func followUnfollowActiononSearchPeople(_ sender: UIButton)
     {
          let params = NSMutableDictionary()
     params.setValue(savedataInstance.id, forKey: "id")
         params.setValue(savedataInstance.device_token, forKey: "user_device_token")

     params.setValue(peopleArray[sender.tag].user_id, forKey: "follow_id")
     if sender.currentTitle == "Follow"
     {
     params.setValue(1, forKey: "followStatus")
     }
     else if sender.currentTitle == "Follower"
     {
     params.setValue(0, forKey: "followStatus")
     }
    params.setValue(peopleArray[sender.tag].device_token, forKey: "device_token")
          params.setValue(savedataInstance.id, forKey: "user_id")

         print("params for FOLLOW PEOPLE API api \(params)")
          let status = Reach().connectionStatus()
          switch status
          {
          case .unknown, .offline:
              SVProgressHUD.dismiss()
              SVProgressHUD.showError(withStatus: "Please check your internet connection.")
              break
              // Show alert if internet not available.
              //show alert
          default:
              ApiManager.sharedManager.delegate=self
              SVProgressHUD.show(withStatus: "Loading...")
          ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.followUnFollowApi as NSString,currentView: self.view)
          }
      }
    
    //MARK:- BLOCK UNBLOCK SEARCH PEOPLE
    @objc func blockUnblockActionOnSearchPeople(_ sender: UIButton)
        {
        let params = NSMutableDictionary()
            
         params.setValue(savedataInstance.id, forKey: "user_id")
            
         params.setValue(peopleArray[sender.tag].user_id, forKey: "block_id")
         if sender.currentTitle == "Block"
         {
         params.setValue(1, forKey: "block_status")
         }
         else if sender.currentTitle == "Unblock"
         {
         params.setValue(0, forKey: "block_status")
         }
             print("params for FOLLOW PEOPLE API api \(params)")
              let status = Reach().connectionStatus()
              switch status
              {
              case .unknown, .offline:
                  SVProgressHUD.dismiss()
                  SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                  break
                  // Show alert if internet not available.
                  //show alert
              default:
                  ApiManager.sharedManager.delegate=self
                  SVProgressHUD.show(withStatus: "Loading...")
              ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.blockUnblockAPI as NSString,currentView: self.view)
              }
          }
    
    //MARK:- TABLEVIEW DELEGATES AND DATASOURCE

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isCreatingNewMessage == true
        {
            lbldateforMessages.isHidden = true
           
            //users list here
            let cell : GetPeopleCell = tableView.dequeueReusableCell(withIdentifier: "GetPeopleCell") as! GetPeopleCell
           //users list here PREVIOUS ONE 
           // let cell : FollwersCell = tableView.dequeueReusableCell(withIdentifier: "FollwersCell") as! FollwersCell
            cell.selectionStyle = .none
            

                var user_blocked_by :Int = 0
                       let myIdStr :String = "\(savedataInstance.id!)"
                       let myId :Int = Int(myIdStr)!
                cell.btnBlockUnblock.tag = indexPath.row
                cell.btnBlockUnblock.addTarget(self, action: #selector(blockUnblockActionOnSearchPeople(_:)), for: .touchUpInside)


                if peopleArray[indexPath.row].user_blocked_by != nil
                {
                       user_blocked_by  = peopleArray[indexPath.row].user_blocked_by as! Int
                }
                      
            let blueAppColor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)

                if myId == user_blocked_by
                {
                    cell.btnBlockUnblock.backgroundColor = blueAppColor
                    cell.btnBlockUnblock.setTitle("Unblock", for: .normal)
                    print("follow to api case 1")
                    
                    cell.btnFollowUnfollow.backgroundColor = UIColor.lightGray
                    cell.btnFollowUnfollow.isUserInteractionEnabled = false
                    cell.btnFollowUnfollow.setTitle("Follow", for: .normal)
                }
                else
                {
                    cell.btnBlockUnblock.backgroundColor = blueAppColor
                    cell.btnBlockUnblock.setTitle("Block", for: .normal)
                    cell.btnFollowUnfollow.isUserInteractionEnabled = true

                    self.setFollowButtonTextAccordingtoCases(btnFollow: cell.btnFollowUnfollow, index: indexPath.row)
                    print("follow to api case 1")
                }
            
            cell.btnFollowUnfollow.tag = indexPath.row
            cell.btnFollowUnfollow.addTarget(self, action: #selector(followUnfollowActiononSearchPeople(_:)), for: .touchUpInside)
                  
            if "\(peopleArray[indexPath.row].username!)".isEmpty == false
            {
                cell.lblName.text = "\(peopleArray[indexPath.row].username!)"
            }
        else if "\(peopleArray[indexPath.row].name!)".isEmpty == false
            {
            cell.lblName.text = "\(peopleArray[indexPath.row].name!)"
            }
          else if "\(peopleArray[indexPath.row].email!)".isEmpty == false
            {
              cell.lblName.text = "\(peopleArray[indexPath.row].email!)"
            }
          else
          {
            cell.lblName.text = "no email name, username"

            print("EVERYTHING IS EMPTY \(indexPath.row)")
        }
                  
        var imgStr = "\(Constant.FollowersprofilePictureBaseUrl)" + "\(peopleArray[indexPath.row].profile_image ?? "")"
                        
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)
   
        cell.imgViewFollowers.sd_imageIndicator = SDWebImageActivityIndicator.gray
   
        cell.imgViewFollowers.contentMode = .scaleToFill
   
        cell.imgViewFollowers.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
                  
    cell.imgViewFollowers.layer.cornerRadius =  51 / 2
    cell.imgViewFollowers.clipsToBounds = true
    cell.imgViewFollowers.layer.masksToBounds = true
            
        return cell
        }
        else
        {
            //GET ALL MESSAGES WITH PARTICULAR USER
            
        lbldateforMessages.isHidden = false
            
            
            if "\(messagesArray[indexPath.row].chat ?? "")".lowercased().contains("jpg")
            {
                let cell : MessageImageCell = tableView.dequeueReusableCell(withIdentifier: "MessageImageCell") as! MessageImageCell
                    cell.selectionStyle = .none
                                
                if "\(messagesArray[indexPath.row].from ?? "")" == "\(savedataInstance.id!)"
                {
                    cell.imgReceived.isHidden = true
                    cell.imgOtherUser.isHidden = true
                    cell.imgSent.isHidden = false
                    
                    print(messagesArray[indexPath.row])
                    
                    var imgStr = "\(messagesArray[indexPath.row].img_base_url ?? "")" + "\(messagesArray[indexPath.row].message_image ?? "")" + "\(messagesArray[indexPath.row].chat ?? "")"
                    
                         imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                         cell.imgSent.sd_imageIndicator = SDWebImageActivityIndicator.gray
                         cell.imgSent.contentMode = .scaleToFill
                         cell.imgSent.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))

                }
                else if "\(messagesArray[indexPath.row].to ?? "")" == "\(savedataInstance.id!)"
                {
                    cell.imgReceived.isHidden = false
                    cell.imgOtherUser.isHidden = false
                    cell.imgSent.isHidden = true
                    
                    var imgStr = "\(messagesArray[indexPath.row].img_base_url ?? "")" + "\(messagesArray[indexPath.row].message_image ?? "")" + "\(messagesArray[indexPath.row].chat ?? "")"
                    
                         imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                         cell.imgReceived.sd_imageIndicator = SDWebImageActivityIndicator.gray
                         cell.imgReceived.contentMode = .scaleToFill
                         cell.imgReceived.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
                    
                    
                    var profileimgStr = "\(Constant.FollowersprofilePictureBaseUrl)" + "\(selectedPeopleObj?.profile_image ?? "")"
                           profileimgStr = RandomObjects.geturlEncodedString(string: imgStr)
                                         
                           cell.imgOtherUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
                               
                           cell.imgOtherUser.contentMode = .scaleToFill
                           cell.imgOtherUser.sd_setImage(with: URL(string: profileimgStr), placeholderImage: UIImage(named: "profileplaceholder"))
                            cell.imgOtherUser.layer.cornerRadius =  12.5
                          cell.imgOtherUser.clipsToBounds = true
                          cell.imgOtherUser.layer.masksToBounds = true
                    
                }
                return cell
            }
            else{
            
        let cell : MessagesCell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
            cell.selectionStyle = .none

            if messagesArray.count > 0
            {
        if "\(messagesArray[indexPath.row].from ?? "")" == "\(savedataInstance.id!)"
        {
                cell.myView.isHidden = false
                cell.otherUserView.isHidden = true
                cell.txtmyMessage.text = "\(messagesArray[indexPath.row].chat ?? "")"
                 cell.txtotherUserMessage.text = "\(messagesArray[indexPath.row].chat ?? "")"
            cell.heightforImageViewOtherUser.constant = 0.0
        }
        else if"\(messagesArray[indexPath.row].to ?? "")" == "\(savedataInstance.id!)"
        {
            
            var profileimgStr = "\(Constant.FollowersprofilePictureBaseUrl)" + "\(selectedPeopleObj?.profile_image ?? "")"
            profileimgStr = RandomObjects.geturlEncodedString(string: profileimgStr)

                cell.imgOtherUser.sd_imageIndicator = SDWebImageActivityIndicator.gray

                    cell.imgOtherUser.contentMode = .scaleToFill
                    cell.imgOtherUser.sd_setImage(with: URL(string: profileimgStr), placeholderImage: UIImage(named: "profileplaceholder"))
                    cell.imgOtherUser.layer.cornerRadius =  12.5
                    cell.imgOtherUser.clipsToBounds = true
                    cell.imgOtherUser.layer.masksToBounds = true
            
            cell.heightforImageViewOtherUser.constant = 25.0
            cell.myView.isHidden = true
            cell.otherUserView.isHidden = false
            cell.txtmyMessage.text = "\(messagesArray[indexPath.row].chat ?? "")"
            cell.txtotherUserMessage.text = "\(messagesArray[indexPath.row].chat ?? "")"
        }
                

            }
        return cell
            
        }
    }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isCreatingNewMessage == false
        {
        print("user is clicking on message")
         return
        }
        else if searchBarView.isHidden == false
        {
            var user_blocked_by :Int = 0
            let myIdStr :String = "\(savedataInstance.id!)"
            let myId :Int = Int(myIdStr)!
                
            
            if peopleArray[indexPath.row].user_blocked_by != nil
                        {
                               user_blocked_by  = peopleArray[indexPath.row].user_blocked_by as! Int
                        }
                              
                    let blueAppColor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)

                        if myId == user_blocked_by
                        {
                            SVProgressHUD.showError(withStatus: "This user is blocked.")
                            return
                        }
            
            
            
            
        UIView.animate(withDuration: 0.2) {
        self.searchBarView.isHidden = true
        self.selectedUserViewOnEditMessages.isHidden = false
        }
        selectedPeopleObj = peopleArray[indexPath.row]
            
            let otherUserId = selectedPeopleObj?.user_id as! Int

                   if otherUserId != 1
                   {
                       bottomScrollView.isHidden = false
                   }
                   else
                   {
                       bottomScrollView.isHidden = true
                   }
            
            
            if "\(peopleArray[indexPath.row].username!)".isEmpty == false
            {
            lblSelectedUserName.text = "\(selectedPeopleObj!.username!)"

            }
            else   if "\(peopleArray[indexPath.row].name!)".isEmpty == false {
            lblSelectedUserName.text = "\(selectedPeopleObj!.name!)"
                   }
            else   if "\(peopleArray[indexPath.row].email!)".isEmpty == false {
                lblSelectedUserName.text = "\(selectedPeopleObj!.email!)"
            }
            else
            {
                lblSelectedUserName.text = "no email name, username"

                print("EVERYTHING IS EMPTY \(indexPath.row)")
                   }
            
        var imgStr = "\(Constant.FollowersprofilePictureBaseUrl)" + "\(selectedPeopleObj?.profile_image ?? "")"
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                      
        imgSelectedUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
        imgSelectedUser.contentMode = .scaleToFill
        imgSelectedUser.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
       imgSelectedUser.layer.cornerRadius =  51 / 2
       imgSelectedUser.clipsToBounds = true
       imgSelectedUser.layer.masksToBounds = true
       tableView.isHidden = true
       self.isCreatingNewMessage = false
        self.getMessagesWithParticularUserAPI()
        }

    }
    
    
    //MARK:- GET MESSAGES WITH PARTICULAR USER
       func getMessagesWithParticularUserAPI()
       {
        let params = NSMutableDictionary()
        
    params.setValue(savedataInstance.id, forKey: "user_id")
    params.setValue(selectedPeopleObj!.user_id, forKey: "follow_id")
    print("api name : \(Constant.GETMESSAGESWITHPARTICULARUSER) and params are \(params)")
        
        let status = Reach().connectionStatus()
           switch status
           {
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
               postUrl:Constant.GETMESSAGESWITHPARTICULARUSER as NSString,
               currentView: self.view)
        }
    }
    
    
      //MARK:-  SEND MESSAGE TO SEARCHED USER
           func sendMessagetoSelectedUser()
           {
            let params = NSMutableDictionary()
            
        params.setValue(savedataInstance.id, forKey: "from")
            
        params.setValue(selectedPeopleObj!.user_id, forKey: "to")
            
        params.setValue(self.otherUserDeviceToken, forKey: "device_token")
            
        params.setValue(savedataInstance.id, forKey: "user_id")
        params.setValue(selectedPeopleObj!.user_id, forKey: "follow_id")
            
        params.setValue(txtMessageonEditMessage.text, forKey: "message")
            
            print("params for sendmessage api \(params)")
            let status = Reach().connectionStatus       ()
               switch status
               {
            case .unknown, .offline:
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Please check your internet connection.")

            break
                       // Show alert if internet not available.
                       //show alert
            default:
            ApiManager.sharedManager.delegate=self
            SVProgressHUD.show(withStatus: "Sending Message...")
            ApiManager.sharedManager.postDataOnserver(
                   params: params,
                   postUrl:Constant.SENDMESSAGEAPI as NSString,
                   currentView: self.view)
            }
        }
    
    
    @IBAction func cameraButtonAction(_ sender: Any)
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
    
    //MARK:- IMAGE PICKER DELEGATES
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let pickedImage = info[.originalImage] as? UIImage
         {
             
         let newPickedImage = RandomObjects.resizeImage(image: pickedImage, targetSize: CGSize.init(width: 300, height: 300))
             
         imageData = newPickedImage.jpegData(compressionQuality: 0.4) as NSData?
             
//         btnImgEditProfile.setImage(newPickedImage, for: .normal)
//
//         btnImgEditProfile.layer.cornerRadius = btnImgEditProfile.frame.size.width / 2
//
//         btnImgEditProfile.layer.masksToBounds = true
//         btnImgEditProfile.clipsToBounds = true
             // imageViewPic.contentMode = .scaleToFill
         }
        self.sendImageMessage()
         picker.dismiss(animated: true, completion: nil)

     }
    
    //MARK:- SEND IMAGE MESSAGE API
    func sendImageMessage()
        {
        let manager: AFHTTPSessionManager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        let urlStr : String = "\(Constant.baseUrl)\(Constant.SENDMESSAGEAPI)"
        let params = NSMutableDictionary()
                
            params.setValue(savedataInstance.id, forKey: "from")
                
            params.setValue(selectedPeopleObj!.user_id, forKey: "to")
                
            params.setValue(self.otherUserDeviceToken, forKey: "device_token")
                
            params.setValue(savedataInstance.id, forKey: "user_id")
            params.setValue(selectedPeopleObj!.user_id, forKey: "follow_id")
                
            params.setValue("test123", forKey: "message")
                   
            print("params for edit profile are \(params)")
            let request: NSMutableURLRequest = manager.requestSerializer.multipartFormRequest(withMethod: "POST"
                , urlString: urlStr, parameters: params as? [String : AnyObject], constructingBodyWith: {(formData: AFMultipartFormData!) -> Void in
                    
            if self.imageData != nil
            {
                formData.appendPart(withFileData: self.imageData! as Data, name: "message_image", fileName: "message_image.jpg", mimeType: "image/jpeg")
            }
                    
                }, error: nil)
                                
            manager.dataTask(with: request as URLRequest) { (response, responseObject, error) -> Void in

                if((error == nil))
                {
                    
                    if ((responseObject as! NSDictionary).value(forKey: "status") as! Bool) == true
                    {
                 
                        SVProgressHUD.showSuccess(withStatus: "Image sent successfully.")
                        
                        self.txtMessageonEditMessage.text = ""
                        self.isCreatingNewMessage = false
                        
                        self.getMessagesWithParticularUserAPI()
                        
                    }
                    else
                    {
                        print("error is in UPDATE IMAGE ONN SEND MESSAGE API \(error)")
                RandomObjects.showErrorNow(jsonDictionary:responseObject as! NSDictionary )
                    }
                    
                }
                else {
                    
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Something went wrong!!!")
                    print("error is in UPDATE PROFILE API \(error)")
                }

                print(responseObject)
                }.resume()
        }
    
       
    
}

