//
//  RandomObjects.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 16/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import CoreLocation

class RandomObjects {
    
         //MARK:- first time flow value  save

        class func setIsFirstTimeFlowNeeded(isNeeded: Bool)
        {
            let defaults = UserDefaults.standard
            defaults.setValue(isNeeded, forKey:"isNeeded")
        }
    
    
        //MARK:- get first time flow value stored
        class func isFirstTimeFlowNeed() -> (Bool)
        {
            let defaults = UserDefaults.standard

            if defaults.value(forKey: "isNeeded") != nil
            {
                return defaults.value(forKey: "isNeeded") as! Bool
            }
            else
            {
                return true
            }
        }
    
    
    
   class func getnow()->(String)
    {
    return ""
    }
    
    //MARK:- GET ADDRESS FROM LAT LONG
    class func getAddressfromLatLongNow() -> (String)
    {
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        var addressString : String = ""

        var location : CLLocation?
        if   appdelegate.selectedLatitude! != 0.0
        {
            location = CLLocation(latitude: appdelegate.selectedLatitude!, longitude:  appdelegate.selectedLongitude!)
        }
        else
        {
            location = CLLocation(latitude: RandomObjects.getLatitude(), longitude:  RandomObjects.getLongitude()) //changed!!!
        }

        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
            }
           else if placemarks?.count ?? 0 > 0 {
                let pm = placemarks?[0] as! CLPlacemark
                
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil
                {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil
                {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil
                {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil
                {
                    addressString = addressString + pm.postalCode! + " "
                }
                
            }
            else
            {
                
            }
        })
                return addressString

            }
    
    //MARK:- LOGOUT SET DETAILS EMPTY ON LOGOUT SUCCESS
    class func logOutNow()
       {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userdata")
        let savedataInstance = SaveDataClass.sharedInstance
        let emptydict : NSDictionary? = nil
        
        savedataInstance.saveUserDetails(userdataDict: emptydict)
       }
    
    
    
    
    
    //MARK:- SAVE LATITUDE
    class func setLatitude(lat: Double)
    {
        
        let defaults = UserDefaults.standard
        defaults.setValue(lat, forKey:"latitude")
    }
    
    //MARK:- SAVE LONGITUDE
    class func setLongitude(long: Double)
    {
        let defaults = UserDefaults.standard
        defaults.setValue(long, forKey:"longitude")
    }
    
    //MARK:- GET LATITUDE IF THERE ELSE RETURN MIAMI LAT
    class func getLatitude() -> (Double)
    {
        let defaults = UserDefaults.standard

        if defaults.value(forKey: "latitude") != nil
        {
            return defaults.value(forKey: "latitude") as! (Double)
        }
        else
        {
            return 25.7616798
        }
//        //temp himanshu
//        return 30.7373361
    }
    
    //MARK:- GET LATITUDE IF THERE ELSE RETURN MIAMI LONG
    class func getLongitude() -> (Double)
     {
let defaults = UserDefaults.standard

       if defaults.value(forKey: "longitude") != nil
       {
           return defaults.value(forKey: "longitude") as! (Double)
       }
       else
       {
           return -80.19179020000001
       }
        //temp himanshu
//        return 76.67842580000001
    }
    
    
    //MARK:- SET FOLLOWING ARRAY
    class func removefollowFollowingwhichDonthavedata(array : NSMutableArray) -> (NSMutableArray)
    {
        var mainArray = NSMutableArray()
//        mainArray = array.mutableCopy() as! NSMutableArray
        
        for i in 0..<array.count
        {
            
            if (array.object(at: i) as? NSDictionary)?.value(forKey: "data") != nil
            {
                
            if ((array.object(at: i) as? NSDictionary)?.value(forKey: "data") as? NSArray)?.count == 0
            {
            }
            else
            {
                mainArray.add(array.object(at: i))
            }
            }
            else
            {
            }
        }
        
        return mainArray.mutableCopy() as! (NSMutableArray)
       
    }
    
    class func setDeviceToken(device_token: String)  {
        let defaults = UserDefaults.standard
        defaults.setValue(device_token, forKey:"device_token")
    }
    
    
    class func getDeviceToken() ->(String)  {
           let defaults = UserDefaults.standard
        if defaults.value(forKey: "device_token") != nil
        {
            
            return defaults.value(forKey: "device_token") as? String ?? ""
        }
        else
        {
            return "Nodevicetoken"

        }
           
       }

        //MARK:- SHOW ERROR COMMON DYNAMIC
   class func showErrorNow(jsonDictionary: NSDictionary)  {
        SVProgressHUD.dismiss()

        if let errorObject = (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "message") as? NSArray{
            print(errorObject)
            SVProgressHUD.showError(withStatus: "\(errorObject[0])")
        }
        else if let errorObject = (jsonDictionary.value(forKey: "message") as? NSArray)?.object(at: 0) as? String
        {
            SVProgressHUD.showError(withStatus: "\(errorObject)")
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Something went wrong!!!")
        }
        
    }
    
    //MARK:- ADD SHADOW COMMON
    class func addcustomizeShadowforPopUp(viewShadow:UIView)
    {
        viewShadow.layer.borderColor = UIColor.white.cgColor
        viewShadow.backgroundColor = UIColor.black .withAlphaComponent(0.5)
        viewShadow.layer.cornerRadius = 15.0
        viewShadow.clipsToBounds = true
        viewShadow.layer.shadowColor = UIColor.lightGray.cgColor
        viewShadow.layer.shadowOpacity = 1
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 10
    }
    
    //MARK:- GET OTHER USER PROFILE IMAGE
    //WORKS IF USER OWN PROFILE ONLY
    class func getOtherUserProfileImage(imgStrName:String) ->(String)
    {
        let savedataInstance = SaveDataClass.sharedInstance

        var imgStr: String
        if  savedataInstance.profile_folder_name != nil{
            if   (savedataInstance.profile_folder_name as? String)?.isEmpty == false
            {
                 imgStr = Constant.imageBaseUrl + "\(savedataInstance.profile_folder_name as? String ?? "")" + "\(imgStrName)"
            }
            else{
                  imgStr = Constant.imageBaseUrl + "\(imgStrName)"
            }
        }
        else{
            imgStr = Constant.imageBaseUrl + "\(imgStrName)"

        }
        
        imgStr = imgStr.replacingOccurrences(of: " ", with: "%20")
        imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return imgStr
    }
    
    
    
    //MARK:- GET URL ENCODED STRING MAKE A WORKING URL//WORKS IF USER OWN PROFILE ONLY
    class func getUserOwnProfileImageStr() ->(String)
    {
        let savedataInstance = SaveDataClass.sharedInstance

        var imgStr: String
        if  savedataInstance.profile_folder_name != nil{
            if   (savedataInstance.profile_folder_name as? String)?.isEmpty == false
            {
                 imgStr = Constant.imageBaseUrl + "\(savedataInstance.profile_folder_name as? String ?? "")" + "\(savedataInstance.profile_image as? String ?? "")"
            }
            else{
                  imgStr = Constant.imageBaseUrl + "\(savedataInstance.profile_image as? String ?? "")"
            }
        }
        else{
            imgStr = Constant.imageBaseUrl + "\(savedataInstance.profile_image as? String ?? "")"

        }
        
        imgStr = imgStr.replacingOccurrences(of: " ", with: "%20")
        imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return imgStr
    }
    
    //MARK:- GET URL ENCODED STRING MAKE A WORKING URL
    class func geturlEncodedString(string : String) ->(String){
        var newStr : String = string
        newStr = string.replacingOccurrences(of: " ", with: "%20")
        newStr = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return newStr
    }
    
    
    //MARK:- BASE URL + IMAGE FOR USER PROFILE IMAGE ONLY
    class func getUserFollowingImageString(folderName:String , imgName: String) ->(String)
    {
        let savedataInstance = SaveDataClass.sharedInstance

        var imgStr: String
        if  savedataInstance.profile_folder_name != nil{
            if   (savedataInstance.profile_folder_name as? String)?.isEmpty == false
            {
                 imgStr = Constant.imageBaseUrl + "\(savedataInstance.profile_folder_name as? String ?? "")" + "\(savedataInstance.profile_image as? String ?? "")"
            }
            else{
                  imgStr = Constant.imageBaseUrl + "\(savedataInstance.profile_image as? String ?? "")"
            }
        }
        else{
            imgStr = Constant.imageBaseUrl + "\(savedataInstance.profile_image as? String ?? "")"

        }
        
        imgStr = imgStr.replacingOccurrences(of: " ", with: "%20")
        imgStr = imgStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return imgStr
    }
    
    //MARK:- RESIZE IMAGE COMMON FUNCTION
       class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size

            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height

            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
            } else
            {
                newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
            }

            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
    //            CGRectMake(0, 0, newSize.width, newSize.height)

            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!
        }
    
    //MARK:- CHECK VARIABLES ARE NIL OR NULL OR NOT COMMON
    class func checkValueisNilorNull(value:Any?) ->(Bool)
    {
        if  value != nil && value is NSNull == false
        {
            return false
        }
        else if (value as? String) == ""
        {
            return true
        }
        else if (value as? String)?.contains("null") ?? false
        {
            return true
        }
        else
        {
            return true
        }
    }
    
    //MARK:- HEIGHT OF LABEL ACCORDING TO TEXT SIZE AND CHARACTERS COUNT
  class  func estimatedLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {

        let size = CGSize(width: width, height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font: font]

        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return rectangleHeight
    }
  
    class func scrolltoRow(index:Int, section : Int, tableview:UITableView)
    {
        tableview.scrollToRow(at: IndexPath.init(row: index, section: section), at: .top, animated: true)
        
    }

}

//MARK:- SHADOW
extension UIView {
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
}

//MARK:- SHADOW
class ViewWithRoundedcornersAndShadow: UIView {
    private var theShadowLayer: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.theShadowLayer == nil {
            let rounding = CGFloat.init(15.0)

            let shadowLayer = CAShapeLayer.init()
            self.theShadowLayer = shadowLayer
            shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: rounding).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor

            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowRadius = CGFloat.init(3.0)
            shadowLayer.shadowOpacity = Float.init(0.2)
            shadowLayer.shadowOffset = CGSize.init(width: 0.0, height: 4.0)

            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

//MARK:- CHECK EMAIL VALIDATION

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

//MARK:- ALERT EXTENSION
extension UIViewController
{
    func showAlert(_ controller : UIViewController, title1: String, msg : String)
    {
        let uiAlert = UIAlertController(title: title1, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            
        }))
        DispatchQueue.main.async {
                    self.present(uiAlert, animated: true, completion: nil)
        }
    }
}

//MARK:- OTHER USER PEOPLE

class OtherUserData
{
    
    let fav_liquor: Any?
    let fav_alcohol: Any?

    let work_at: Any?
    let role: Any?
    let address: Any?
    let api_token: Any?
    let city: Any?
    let country: Any?
    let device_token: Any?
    let drink_image_1: Any?
    let drink_image_2: Any?
    let drink_image_3: Any?
    let drinks_folder_name: Any?
    let email: Any?
    let fav_cocktail: Any?
    let fav_drink: Any?
    let fav_spirit: Any?
    let follow_by: Any?
    let follow_to: Any?
    let message: Any?
    let my_status: Any?
    let name: Any?
    let phone: Any?
    let profile_folder_name: Any?
    let profile_image: Any?
    let state: Any?
    let user_latitude: Any?
    let user_longitude: Any?
    let username: Any?
    let visibility_status: Any?
    let visible_bar: Any?
    let visible_for: Any?

    init(fav_alcohol:Any?,fav_liquor:Any?,work_at:Any? , role:Any?,address : Any?,api_token:Any?, city: Any?,country: Any?,device_token: Any?, drink_image_1: Any? , drink_image_2 : Any?, drink_image_3 : Any? , drinks_folder_name : Any? , email: Any? , fav_cocktail:Any? , fav_drink : Any?,fav_spirit : Any?,follow_by : Any? ,follow_to : Any?,message:Any?,my_status:Any?,name:Any?,phone:Any?,profile_folder_name:Any?,profile_image:Any?,state:Any?,user_latitude:Any?,user_longitude:Any?,username:Any?,visibility_status:Any?,visible_bar:Any?,visible_for:Any?)
    {
        self.fav_alcohol = fav_alcohol

        self.fav_liquor = fav_liquor
        self.work_at = work_at
        self.role = role
         self.address = address
        self.api_token = api_token
        self.city = city
        self.country = country
        self.device_token = device_token
        self.drink_image_1 = drink_image_1
        self.drink_image_2 = drink_image_2
        self.drink_image_3 = drink_image_3
        self.drinks_folder_name = drinks_folder_name
        self.email = email
        self.fav_cocktail = fav_cocktail
        self.fav_drink = fav_drink
        self.fav_spirit = fav_spirit
        self.follow_by = follow_by
        self.follow_to = follow_to
        self.message = message
        self.my_status = my_status
        self.name = name
        self.phone = phone
        self.profile_folder_name = profile_folder_name
        self.profile_image = profile_image
        self.state = state
        self.user_longitude = user_longitude
        self.user_latitude = user_latitude
        self.username = username
        self.visibility_status = visibility_status
        self.visible_bar = visible_bar
        self.visible_for = visible_for
    }
}





//# MARK :- APP MODEL CLASSES FOR


//SELECTED BARS DETAILS
class BarsDetails {
    
    let bar_website : Any?

    let bar_follow : Any?
    let bar_team : Any?
    let bar_desc: Any?
    let bar_gallery: Any?
    let bar_image: Any?
    let bar_latitude: Any?
    let bar_longitude: Any?
    let bar_name: Any?
    let bar_street_address: Any?
    let bar_tags: Any?
    let dollar: Any?
    let features: Any?
    let id: Any?
    let miles: Any?
    let other_tags: Any?
    let user_id: Any?
    let todayEvent: Any?
    let comingEvents: Any?
    let bar_timing: Any?
    let owner_phone: Any?

    init(bar_website:Any?,bar_follow:Any? , bar_team:Any? , bar_desc : Any?,bar_gallery:Any?, bar_image: Any?,bar_latitude: Any?,bar_longitude: Any?, bar_name: Any? , bar_street_address : Any?, bar_timing : Any? , bar_tags : Any? , dollar: Any? , features:Any? , id : Any?,miles : Any?,other_tags : Any? ,user_id : Any?,todayEvent:Any?,comingEvents:Any?,owner_phone:Any?)
    {
        self.bar_website = bar_website
        self.bar_follow = bar_follow
        self.bar_team = bar_team
        self.bar_latitude = bar_latitude
        self.bar_longitude = bar_longitude
        self.owner_phone = owner_phone
        self.comingEvents = comingEvents
        self.todayEvent = todayEvent
        self.bar_desc = bar_desc
        self.bar_gallery = bar_gallery
        self.bar_image = bar_image
        self.bar_name = bar_name
        self.bar_street_address = bar_street_address
        self.bar_tags = bar_tags
        self.dollar = dollar
        self.features = features
        self.id = id
        self.miles = miles
        self.other_tags = other_tags
        self.user_id = user_id
        self.bar_timing = bar_timing
    }
}

//not available in getstores api
//current_date_time , events_dollar , Features , product_types , special_drink_price , today_event , user_id , vibes

class BarsList
{
    
    let bar_city: Any?
    let bar_country: Any?
    let bar_image: Any?
    let bar_latitude: Any?
    let bar_longitude: Any?
    let bar_name: Any?
    let bar_state: Any?
    let bar_status: Any?
    let bar_street_address: Any?
    let bar_zipcode: Any?
    let busiest_day: Any?
    let current_date_time: Any?
    let current_usa_date_time: Any?
    let distance: Any?
    let events_detail: Any?
    let events_dollar: Any?
    let features: Any?
    let id: Any?
    let order: Any?
    let product_types: Any?
    let special_drink_price: Any?
    let today_event: Any?
    let user_id: Any?
    let vibes: Any?
    let dollars: Any?
    let bar_marker: Any?

  
    init(bar_city : Any?,dollars:Any?, bar_country: Any?, bar_image: Any? , bar_latitude : Any? , bar_longitude : Any? , bar_name: Any? , bar_state:Any? , bar_status : Any?,bar_street_address : Any?,bar_zipcode : Any? ,busiest_day : Any?,current_date_time : Any?,current_usa_date_time : Any? ,distance : Any?, events_detail : Any?,events_dollar : Any? , features : Any?,id : Any?,order: Any? , product_types: Any?, special_drink_price : Any? , today_event:Any?
        ,user_id: Any?,vibes:Any?,bar_marker:Any?)
    {
        
        self.bar_marker = bar_marker
        self.dollars = dollars
        self.bar_city = bar_city
        self.bar_country = bar_country
        self.bar_image = bar_image
        self.bar_latitude = bar_latitude
        self.bar_longitude = bar_longitude
        self.bar_name = bar_name
        self.bar_state = bar_state
        self.bar_status = bar_status
        self.bar_street_address = bar_street_address
        self.bar_zipcode = bar_zipcode
        self.busiest_day = busiest_day
        self.current_date_time = current_date_time
        self.current_usa_date_time = current_usa_date_time
        self.distance = distance
        self.events_detail = events_detail
        self.events_dollar = events_dollar
        self.features = features
        self.id = id
        self.order = order
        self.product_types = product_types
        self.special_drink_price = special_drink_price
        self.today_event = today_event
        self.user_id = user_id
        self.vibes = vibes
    }
    
    
    

    
    
    
}

//STORES LIST POPULATED  HORIZONTALLY
class StoreList {
    
    let Store_ends: Any?
    let Store_opens: Any?
    let all_null: Any?
    let current_usa_date_time: Any?
    let delilvery: Any?
    let distance: Any?
    let events_description: Any?
    let events_detail: Any?
    let id: Any?
    let mj_products: Any?
    let order: Any?
    let store_city: Any?
    let store_country: Any?
    let store_desc: Any?
    let store_image: Any?
    let store_latitude: Any?
    let store_longitude: Any?
    let store_marker: Any?
    let store_name: Any?
    let store_products: Any?
    let store_state: Any?
    let store_status: Any?
    let store_street_address: Any?
    let store_zipcode: Any?
    let user_id: Any?

  
    init(Store_ends : Any?,
         Store_opens:Any?,
         all_null: Any?,
         current_usa_date_time: Any? ,
         delilvery : Any? , distance : Any? ,
         events_description: Any? ,
         events_detail:Any? ,
         id : Any?,
         mj_products : Any?,
         order : Any? ,
         store_city : Any?,
         store_country : Any?,
         store_desc : Any? ,
         store_image : Any?,
         store_latitude : Any?,
         store_longitude : Any? ,
         store_marker : Any?,
         store_name : Any?,
         store_products: Any?,
         store_state: Any?,
         store_status : Any?,
         store_street_address:Any?
        ,store_zipcode: Any?,
         user_id:Any?)
    {
        
        self.Store_ends = Store_ends
        self.Store_opens = Store_opens
        self.all_null = all_null
        self.current_usa_date_time = current_usa_date_time
        self.delilvery = delilvery
        self.distance = distance
        self.events_description = events_description
        self.events_detail = events_detail
        self.id = id
        self.mj_products = mj_products
        self.order = order
        self.store_city = store_city
        self.store_country = store_country
        self.store_desc = store_desc
        self.store_image = store_image
        self.store_latitude = store_latitude
        self.store_longitude = store_longitude
        self.store_marker = store_marker
        self.store_name = store_name
        self.store_products = store_products
        self.store_state = store_state
        self.store_status = store_status
        self.store_street_address = store_street_address
        self.store_zipcode = store_zipcode
        self.user_id = user_id
    }
}


//SELECTED BARS DETAILS
class StoreDetails {
    
    let store_follow: Any?
    let owner_phone: Any?

    let store_team: Any?
    let comingEvents: Any?
    let delivery_charges: Any?
    let delivery_comment: Any?
    let features: Any?
    let id: Any?
    let miles: Any?
    let store_desc: Any?
    let store_gallery: Any?
    let store_image: Any?
    let store_latitude: Any?
    let store_longitude: Any?
    let store_name: Any?
    let store_street_address: Any?
    let store_timing: Any?
    let todayEvent: Any?
    let user_id: Any?
    let store_website: Any?

    

    init(owner_phone:Any?,
         store_follow:Any?,
         store_team:Any?,
         comingEvents : Any?,
         delivery_charges:Any?,
         delivery_comment: Any?,
         features: Any?,
         id: Any?,
         miles: Any? ,
         store_desc : Any?,
         store_gallery : Any? ,
         store_image : Any? ,
         store_latitude: Any? ,
         store_longitude:Any? ,
         store_name : Any?,
         store_street_address : Any?,
         store_timing : Any? ,
         todayEvent : Any?,
         user_id:Any?,store_website:Any?)
    {
        self.store_follow = store_follow
        self.owner_phone = owner_phone


        self.store_team = store_team
        self.store_website = store_website
        self.comingEvents = comingEvents
        self.delivery_charges = delivery_charges
        self.delivery_comment = delivery_comment
        self.features = features
        self.id = id
        self.miles = miles
        self.store_desc = store_desc
        self.store_gallery = store_gallery
        self.store_image = store_image
        self.store_latitude = store_latitude
        self.store_longitude = store_longitude
        self.store_name = store_name
        self.store_street_address = store_street_address
        self.store_timing = store_timing
        self.todayEvent = todayEvent
        self.user_id = user_id
    }
}


//MARK:- PEOPLE LIST CLASS COMMON
//PEOPLE LIST FOR EDIT MESSAGES AND PEOPLE LISTING OR SEARCH PEOPLE
class PeopleList
{
    let user_blocked_by: Any?
    let user_blocked_id: Any?

    let block_id: Any?

    let user_1: Any?
    let user_2: Any?

    let device_token: Any?
    let initiate_id: Any?
    let address: Any?
    let city: Any?
    let country: Any?
    let distance : Any?
    let email: Any?
    let fav_cocktail: Any?
    let fav_drink: Any?
    let fav_spirit: Any?
    let follow_by: Any?
    let follow_to: Any?
    let follower: Any?
    let following: Any?
    let my_status: Any?
    let name: Any?
    let phone: Any?
    let profile_image: Any?
    let public_user: Any?
    let requested: Any?
    let role: Any?
    let state: Any?
    let user_id: Any?
    let user_latitude: Any?
    let user_longitude: Any?
    let visible_bar: Any?
    let visible_for: Any?
    let username: Any?
    let visibility_status: Any?
    let person_status: Any?
    init(user_blocked_by:Any?,
        user_blocked_id:Any?,
        block_id:Any?,
        user_1:Any?,
         user_2:Any?,
         device_token:Any?,
         initiate_id:Any?,
         address : Any?,
         city:Any?,
         country: Any?,
         distance:Any?,
         email: Any?,
         fav_cocktail: Any?,
         fav_drink: Any?,
         fav_spirit: Any?,
         follow_by: Any?,
         follow_to: Any?,
         follower: Any?,
         following: Any?,
         my_status:Any?,
         name:Any?,
         phone:Any?,
         profile_image:Any?,
         public_user:Any?,
         requested:Any?,
         role:Any?,
         state:Any?,
         user_id:Any?,
         username:Any?,
         user_latitude:Any?,
        user_longitude:Any?,
        visible_bar:Any?,
        visible_for:Any?,
        visibility_status:Any?,person_status:Any?)
    {
        self.user_blocked_by = user_blocked_by
        self.user_blocked_id = user_blocked_id

        self.device_token = device_token
        self.user_1 = user_1
        self.user_2 = user_2
        self.block_id = block_id
        self.initiate_id = initiate_id
        self.address = address
        self.city = city
        self.country = country
        self.distance = distance
        self.email = email
        self.fav_cocktail = fav_cocktail
        self.fav_drink = fav_drink
        self.fav_spirit = fav_spirit
        self.follow_by = follow_by
        self.follow_to = follow_to
        self.follower = follower
        self.following = following
        self.user_id = user_id
        self.my_status = my_status
        self.name = name
        self.phone = phone
        self.profile_image = profile_image
        self.public_user = public_user
        self.role = role
        self.requested = requested

        self.state = state
        self.username = username
        self.user_latitude = user_latitude
        self.user_longitude = user_longitude
        self.visible_bar = visible_bar
        self.visible_for = visible_for
        self.visibility_status = visibility_status
        self.person_status = person_status


    }
}




//SHOWN ON  MESSAGEHISTORYVIEWCONTROLLER SCREEN
//MARK:- MESSAGE HISTORY CLASS
class MessagesHistory
{
    let created_at: Any?
    let from_id: Any?
    let from_name: Any?
    let from_profileImage: Any?
    let img_base_url: Any?
    let message: Any?
    let profile_folder_name: Any?
    let to_id: Any?
    let to_name: Any?
    let to_profileImage: Any?

    init(created_at : Any?,
         from_id:Any?,
         from_name: Any?,
         from_profileImage: Any?,
         img_base_url:Any?,
         message:Any?,
         profile_folder_name:Any?,
         to_id:Any?,
         to_name:Any?,
         to_profileImage:Any?)
    {
        self.created_at = created_at
        self.from_id = from_id
        self.from_name = from_name
        self.from_profileImage = from_profileImage
        self.img_base_url = img_base_url
        self.message = message
        self.profile_folder_name = profile_folder_name
        self.to_id = to_id
        self.to_name = to_name
        self.to_profileImage = to_profileImage
        
    }
}

//MARK:- SINGLE USER MESSAGES //SHOWN ON  MESSAGEHISTORYVIEWCONTROLLER SCREEN
class SingleUserMessages
{
    let chat: Any?
    let date: Any?
    let from: Any?
    let to: Any?
    let img_base_url: Any?
    let message_image: Any?

    init(chat : Any?,
         date:Any?,
         from: Any?,
         to: Any?,
         img_base_url: Any?,
        message_image: Any?)
    {
        self.chat = chat
        self.date = date
        self.from = from
        self.to = to
        self.img_base_url = img_base_url
        self.message_image = message_image
    }
}

//MARK:- NotificationsList
class NotificationsList
{
    let follow_email: Any?
    let follow_by: Any?
    let follow_name: Any?
    let follow_profile_image: Any?
    let follow_role : Any?
    let follow_username: Any?
    let notifications: Any?
    let updated_at: Any?
    let follow_device_token: Any?

    init(follow_device_token:Any?,
        follow_email:Any?,
         follow_by : Any?,
         follow_name:Any?,
         follow_profile_image: Any?,
         follow_role:Any?,
         follow_username: Any?,
         notifications : Any?,
         updated_at: Any? )
    {
        self.follow_device_token = follow_device_token
        self.follow_email = follow_email
        self.follow_by = follow_by
        self.follow_name = follow_name
        self.follow_profile_image = follow_profile_image
        self.follow_role = follow_role
        self.follow_username = follow_username
        self.updated_at = updated_at
        self.notifications = notifications
    }
    
}


//MARK:- table view constraints
class IntrinsicTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

import GoogleMaps
//MARK:- CUSTOM GMS MARKER
class MyGMSMarker: GMSMarker {
    var indexofMarker: Int = 0
}

//MARK:- BAR NAME OBJ NOT USED NOW
class BarnameObj
{
    let bar_name: Any?
    let id: Any?

    init(bar_name:Any?, id:Any?)
    {
    self.bar_name = bar_name
    self.id = id
    }
}

//MARK:- STORE NAME OOBJ NOT USED NOW 
class StorenameObj
{
    let store_name: Any?
    let id: Any?

    init(store_name:Any?, id:Any?)
    {
    self.store_name = store_name
    self.id = id
    }
    
}
