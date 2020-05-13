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


class FollowersFollowingViewController: UIViewController,WebServiceDelegate,UITableViewDelegate,UITableViewDataSource
{

    var followersArray = NSMutableArray()
    var followingArray = NSMutableArray()
    
    var imageData : NSData? = nil
    let savedataInstance = SaveDataClass.sharedInstance
    
    @IBOutlet  var viewShadow : UIView!
    @IBOutlet  var lblFollowersCount : UILabel!
    @IBOutlet  var lblFollowingCount : UILabel!
    
    @IBOutlet  var tblFollowers : UITableView!
    @IBOutlet  var tblFollowing : UITableView!

    @IBOutlet  var btnforFollowerFollowingSuperView: UIButton!
    
    @IBOutlet  var btnCrossOnFollowScreen : UIButton!

    //BAR TENDER VIEW CONSTRAINTS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadUI()
    {
        
        RandomObjects.addcustomizeShadowforPopUp(viewShadow: self.viewShadow)
        
        
        if  self.savedataInstance.follow_by  != nil
        {
        lblFollowersCount.text = "\(self.savedataInstance.follow_by!)"
        }
                   
        if  self.savedataInstance.follow_to != nil
        {
            lblFollowingCount.text = "\(self.savedataInstance.follow_to!)"
        }
        
        
        
        self.getFollowersApi(page: 0)
        self.getFollowingApi(page: 0)
    }
    
    
    
    //MARK:-  hit sign up api
    func getFollowingApi(page: Int){
        let params = NSMutableDictionary()
//        params.setValue(11930, forKey: "id")
        params.setValue(savedataInstance.id, forKey: "id")
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
        SVProgressHUD.show(withStatus: "Loading Following Data...")
        ApiManager.sharedManager.postDataOnserver(
               params: params,
               postUrl:Constant.getFollowingAPI as NSString,
               currentView: self.view)
            }
           }
    
    
    //MARK:-  GET FOLLOWERS API
       func getFollowersApi(page: Int){               
        let params = NSMutableDictionary()
        params.setValue(savedataInstance.id, forKey: "id")
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
        SVProgressHUD.show(withStatus: "Loading Followers Data...")
        ApiManager.sharedManager.postDataOnserver(
               params: params,
               postUrl:Constant.getFollowersAPI as NSString,
               currentView: self.view)
            }
    }
    
    //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
       {
               SVProgressHUD.dismiss()
               DispatchQueue.main.async {
                   do {
        if serviceurl as String == Constant.getFollowersAPI
        {
    let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary

    if (jsonDictionary.value(forKey: "status") as! Bool) == true
    {
                    
    if jsonDictionary.value(forKey: "data")  != nil
        {
    self.followersArray.removeAllObjects()
    self.followersArray.addObjects(from: (jsonDictionary.value(forKey: "data")as! NSDictionary).value(forKey:"UserFollowers" ) as! [Any])
                                                  
        }
        else
        {
            self.followersArray.removeAllObjects()

        }
                    
        if self.followersArray.count > 0
        {
            
            var newMutableFollowerArray = NSMutableArray()
            
            newMutableFollowerArray = RandomObjects.removefollowFollowingwhichDonthavedata(array: self.followersArray)
            
            self.followersArray.removeAllObjects()
            
            self.followersArray = newMutableFollowerArray.mutableCopy() as! NSMutableArray
            print("came here where it was crashing")

                     }
        else
        {
            SVProgressHUD.showError(withStatus: "No followers found")

        }
                    
        self.tblFollowers.reloadData()
        }
        else
        {
            self.followersArray.removeAllObjects()

            self.tblFollowers.reloadData()
            SVProgressHUD.showError(withStatus: "No followers found")
//    RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )

        }
        }
    else if serviceurl as String == Constant.getFollowingAPI
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary

        if (jsonDictionary.value(forKey: "status") as! Bool) == true
        {
            if jsonDictionary.value(forKey: "data")  != nil
            {
            self.followingArray.removeAllObjects()
                self.followingArray.addObjects(from: (jsonDictionary.value(forKey: "data")as! NSDictionary).value(forKey:"UserFollowing" ) as! [Any])
                                
            }
            else
            {
                self.followingArray.removeAllObjects()

            }
              if self.followingArray.count > 0
              {
                  
                  var newMutableFollowingArray = NSMutableArray()
                  
                  newMutableFollowingArray = RandomObjects.removefollowFollowingwhichDonthavedata(array: self.followingArray)
                  
                  self.followingArray.removeAllObjects()
                  
                  self.followingArray = newMutableFollowingArray.mutableCopy() as! NSMutableArray
                  print("came here where it was crashing")

            }
              else{
                SVProgressHUD.showError(withStatus: "No following found")

            }
                            
        self.tblFollowing.reloadData()
                            
    }
    else
    {
        self.followingArray.removeAllObjects()

        self.tblFollowing.reloadData()
        SVProgressHUD.showError(withStatus: "No following found")

//    RandomObjects.showErrorNow(jsonDictionary: jsonDictionary)
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
       
        //MARK:- ERROR RESPONSE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("came ")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
          //MARK:- TABLEVIEW DELEGATE AND DATASOURCE
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              if tableView == tblFollowing
              {
                
                lblFollowingCount.text = "\(followingArray.count)"
                return followingArray.count
              }
              else  if tableView == tblFollowers
              {
                lblFollowersCount.text = "\(followersArray.count)"
                  // upcoming events table view
                  return followersArray.count
              }
              else
              {
                return 0
                }
             
          }

    //MARK:- TABLEVIEW DELEGATES AND DATASOURCE

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblFollowers
        {
            let cell : FollwersCell = tableView.dequeueReusableCell(withIdentifier: "FollwersCell") as! FollwersCell
            cell.selectionStyle = .none
            var dict = NSDictionary()
        dict = followersArray.object(at: indexPath.row) as! NSDictionary
            
            let dataArray : NSArray? = dict.value(forKey: "data") as? NSArray
            
            if dataArray?.count == 0
            {
             return cell
            }
            
         let profile_image: String? = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "profile_image") as? String
              
          var imgStr = "\(Constant.FollowersprofilePictureBaseUrl)" + profile_image!
                         
          imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                         
          cell.imgViewFollowers.sd_imageIndicator = SDWebImageActivityIndicator.gray
                         
          cell.imgViewFollowers.contentMode = .scaleToFill
                         
          cell.imgViewFollowers.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
            
        cell.imgViewFollowers.layer.cornerRadius =  51 / 2
        cell.imgViewFollowers.clipsToBounds = true
        cell.imgViewFollowers.layer.masksToBounds = true
                   
    if (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "username") as! String).isEmpty == false
        {
            cell.lblName.text = (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "username") as! String)

       }
       else if (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "name") as! String).isEmpty == false
       {
           cell.lblName.text = (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "name") as! String)

       }
       else{
       
       cell.lblName.text = (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "email") as! String)
       }
            
            
        return cell
        }
         
    else if tableView == tblFollowing
        {
        let cell : FollwingCell = tableView.dequeueReusableCell(withIdentifier: "FollwingCell") as! FollwingCell
            
        cell.selectionStyle = .none
        var dict = NSDictionary()
            
            
        dict = followingArray.object(at: indexPath.row) as! NSDictionary
        let dataArray : NSArray? = dict.value(forKey: "data") as? NSArray
                       
            if dataArray?.count == 0
            {
                return cell
            }
            
            
        let profile_image: String? = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "profile_image") as? String
            
        var imgStr = "\(Constant.FollowersprofilePictureBaseUrl)" + profile_image!
                       
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                       
        cell.imgViewFollowers.sd_imageIndicator = SDWebImageActivityIndicator.gray
                       
        cell.imgViewFollowers.contentMode = .scaleToFill
                       
        cell.imgViewFollowers.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "profileplaceholder"))
        cell.imgViewFollowers.layer.cornerRadius =  51 / 2
            cell.imgViewFollowers.clipsToBounds = true
            cell.imgViewFollowers.layer.masksToBounds = true
                       
        if (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "username") as! String).isEmpty == false
            {
                cell.lblName.text = (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "username") as! String)

           }
           else if (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "name") as! String).isEmpty == false
           {
               cell.lblName.text = (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "name") as! String)

           }
           else{
           
           cell.lblName.text = (((dict.value(forKey: "data") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "email") as! String)
           }
            return cell
            }
        return UITableViewCell()
    }
}
