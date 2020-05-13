//
//  SaveDataClass.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 09/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit

class SaveDataClass
{
    
    
    
    let defaults = UserDefaults.standard
    
    var alcohol_online :  Any?

    var device_token :  Any?
    var fav_alcohol :  Any?
    var fav_liquor :  Any?
    var speciality :  Any?
    var bar_name :  Any?
    var store_name :  Any?
    var outing_day :  Any?


    
    var fav_cocktail :  Any?
    var fav_drink :  Any?
    var fav_spirit :  Any?

    var drink_image_1 :  Any?
    var drink_image_2 :  Any?
    var drink_image_3 :  Any?

    
    var city :  Any?
    var country :  Any?
    var state :  Any?
    
    var address :  Any?
    var work_at :  Any?

    var States :  Any?
    var ProvincesAndTerritories : Any?
    var email :  Any?
    var follow_by :  Any?
    var follow_to :  Any?
    var id :  Any?
    var message :  Any?
    var my_status :  Any?
    var name :  Any?
    var phone :  Any?
    var profile_image :  Any?
    var role :  Any?
    var token :  Any?
    var role_name :  Any?
    var username :  Any?
    var visibility_status :  Any?
    var profile_folder_name :  Any?

    

    class var sharedInstance: SaveDataClass {
          struct Static {
              static let instance = SaveDataClass()
          }
          return Static.instance
      }
    
    func verifyDict(userdataDict  : NSDictionary){
        
        for i in 0..<userdataDict.allKeys.count{
            let key = userdataDict.allKeys[i]
            let value = userdataDict.allValues[i]
            print("key is :\(key)")
            print("value is :\(value)")
        }
    }
    
    func saveUserDetails(userdataDict : NSDictionary?)
    {
        
        let userData = NSKeyedArchiver.archivedData(withRootObject: userdataDict)
        
        if userdataDict != nil
        {
        defaults.set(userData, forKey: "userdata")
        }
        else{
        defaults.removeObject(forKey: "userdata")
        }
        
        if userdataDict?["States"] != nil
        {
        States = userdataDict!["States"]
        }
        else
        {
            States = nil
        }
        
        if userdataDict?["ProvincesAndTerritories"] != nil
        {
        ProvincesAndTerritories = userdataDict!["ProvincesAndTerritories"]
        }
        else
        {
             ProvincesAndTerritories = nil
        }
        
        if userdataDict?["alcohol_online"] != nil
              {
              alcohol_online = userdataDict!["alcohol_online"]
              }
              else
              {
                   alcohol_online = nil
              }
        
        
        
        if userdataDict?["work_at"] != nil
        {
        work_at = userdataDict!["work_at"]
        }
        else
        {
        work_at = nil
        }
        
        
        
        if userdataDict?["address"] != nil
        {
        address = userdataDict!["address"]
        }
        else
        {
        address = nil
        }
        
        if userdataDict?["city"] != nil
        {
        city = userdataDict!["city"]
        }
        else
        {
        city = nil
        }
        
        if userdataDict?["state"] != nil
        {
        state = userdataDict!["state"]
        }
        else{
            state = nil
            
        }
        
        if userdataDict?["country"] != nil
        {
        country = userdataDict!["country"]
        }
        else{
            country = nil
        }
        
        if userdataDict?["email"] != nil
        {
        email = userdataDict!["email"]
        }
        else{
            email = nil
        }
        
        if userdataDict?["follow_by"] != nil
        {
        follow_by = userdataDict!["follow_by"]
        }
        else
        {
        follow_by = nil
        }
        
        if userdataDict?["follow_to"] != nil
        {
        follow_to = userdataDict!["follow_to"]
        }
        else
        {
            follow_to = nil
        }
        
        if userdataDict?["id"] != nil
        {
        id = userdataDict!["id"]
        }
        else
        {
        id = nil
        }
        
        if userdataDict?["message"] != nil
               {
        message = userdataDict!["message"]
        }
        else{
            message = nil
        }
        
        if userdataDict?["my_status"] != nil
        {
        my_status = userdataDict!["my_status"]
        }
        else
        {
            my_status = nil
        }
        
        
        if userdataDict?["name"] != nil
        {
        name = userdataDict!["name"]
        }
        else
        {
            name = nil
        }
            
        if userdataDict?["phone"] != nil
        {
            phone = userdataDict!["phone"]
        }
        else
        {
            phone = nil
        }
        if userdataDict?["profile_image"] != nil
        {
        profile_image = userdataDict!["profile_image"]
        }
        else
        {
           profile_image = nil
        }
        
        if userdataDict?["role"] != nil
        {
        role = userdataDict!["role"]
        }
        else{
        role = nil
        }
        
        if userdataDict?["role_name"] != nil
        {
        role_name = userdataDict!["role_name"]
        }
        else
        {
            role_name = nil
        }
        
        if userdataDict?["token"] != nil
        {
        token = userdataDict!["token"]
        }
        else
        {
           token = nil
        }
        
        if userdataDict?["username"] != nil
        {
        username = userdataDict!["username"]
        }
        else{
            username = nil
        }
        if userdataDict?["visibility_status"] != nil
        {
        visibility_status = userdataDict!["visibility_status"]
        }
        else{
            visibility_status = nil
        }
        if userdataDict?["profile_folder_name"] != nil
        {
        profile_folder_name = userdataDict!["profile_folder_name"]
        }
        else{
            profile_folder_name = nil
        }
        
        if userdataDict?["drink_image_1"] != nil
        {
        drink_image_1 = userdataDict!["drink_image_1"]
        }
        else
        {
            drink_image_1 = nil
        }
        
        if userdataDict?["drink_image_2"] != nil
        {
        drink_image_2 = userdataDict!["drink_image_2"]
        }
        else{
            drink_image_2 = nil
        }
        
        if userdataDict?["drink_image_3"] != nil
        {
        drink_image_3 = userdataDict!["drink_image_3"]
        }
        else
        {
            drink_image_3 = nil
        }
        //        fav_cocktail = userdataDict["fav_cocktail"]
        //        fav_drink = userdataDict["fav_drink"]
        //        fav_spirit = userdataDict["fav_spirit"]
        
        if userdataDict?["fav_cocktail"] != nil{
            fav_cocktail = userdataDict!["fav_cocktail"]
        }
        else{
            fav_cocktail = nil
        }
        
        if userdataDict?["device_token"] != nil
        {
                   device_token = userdataDict!["device_token"]
               }
               else{
                   device_token = nil
               }
        
        if userdataDict?["fav_liquor"] != nil
            {
            fav_liquor = userdataDict!["fav_liquor"]
        }
        else{
            fav_liquor = nil
        }
        if userdataDict?["speciality"] != nil
                 {
                 speciality = userdataDict!["speciality"]
             }
             else{
                 speciality = nil
             }
        
        
        
        
        
        if userdataDict?["fav_alcohol"] != nil
               {
                          fav_alcohol = userdataDict!["fav_alcohol"]
                      }
                      else{
                          fav_alcohol = nil
                      }
               
        
        
        
        
        
        if userdataDict?["fav_drink"] != nil{
            fav_drink = userdataDict!["fav_drink"]
        }
        else{
            fav_drink = nil
        }
        
        if userdataDict?["fav_spirit"] != nil{
            fav_spirit = userdataDict!["fav_spirit"]
        }
        else
        {
            fav_spirit = nil
        }
        
        if userdataDict?["bar_name"] != nil
        {
            bar_name = userdataDict!["bar_name"]
        }
        else
        {
            bar_name = nil
        }
        
        if userdataDict?["store_name"] != nil
        {
            store_name = userdataDict!["store_name"]
        }
        else
        {
            store_name = nil
        }
        if userdataDict?["outing_day"] != nil
        {
            outing_day = userdataDict!["outing_day"]
        }
        else
        {
            outing_day = nil
        }
        
        
        
        
       
    }
    
    func getUserDetails() -> (NSDictionary?)
    {
        var userdataDict : NSDictionary? = nil
        
        let USERData = defaults.value(forKey: "userdata") as? NSData
        
           if let userdata = USERData {
           userdataDict = NSKeyedUnarchiver.unarchiveObject(with: userdata as Data) as? NSDictionary
           }
        print("get User data hit")
        
        if userdataDict != nil{

                email = userdataDict?["email"]
                States = userdataDict?["States"]
            
               address = userdataDict?["address"]
               city = userdataDict?["city"]
               state = userdataDict?["state"]
               country = userdataDict?["country"]
            work_at = userdataDict?["work_at"]

            
               ProvincesAndTerritories = userdataDict?["ProvincesAndTerritories"]
               follow_by = userdataDict?["follow_by"]
               follow_to = userdataDict?["follow_to"]
               id = userdataDict?["id"]
               message = userdataDict?["message"]
               my_status = userdataDict?["my_status"]
               name = userdataDict?["name"]
               phone = userdataDict?["phone"]
               profile_image = userdataDict?["profile_image"]
               role = userdataDict?["role"]
               role_name = userdataDict?["role_name"]
               token = userdataDict?["token"]
               username = userdataDict?["username"]
               visibility_status = userdataDict?["visibility_status"]
            profile_folder_name = userdataDict?["profile_folder_name"]
            
            drink_image_1 = userdataDict?["drink_image_1"]
            drink_image_2 = userdataDict?["drink_image_2"]
            drink_image_3 = userdataDict?["drink_image_3"]

            if userdataDict?["fav_cocktail"] != nil{
            
            fav_cocktail = userdataDict?["fav_cocktail"]
            }
            if userdataDict?["device_token"] != nil
            {
                     
                device_token = userdataDict?["device_token"]
            }
            if userdataDict?["fav_liquor"] != nil
            {
                fav_liquor = userdataDict?["fav_liquor"]
            }
            
            
            if userdataDict?["speciality"] != nil
            {
                speciality = userdataDict?["speciality"]
            }
            
            
            
            if userdataDict?["fav_alcohol"] != nil
                      {
                               
                          fav_alcohol = userdataDict?["fav_alcohol"]
                      }
            
            
            
            if userdataDict?["fav_drink"] != nil{

            fav_drink = userdataDict?["fav_drink"]
            }
            
            if userdataDict?["fav_spirit"] != nil{

            fav_spirit = userdataDict?["fav_spirit"]
            }
            if userdataDict?["bar_name"] != nil
            {

            bar_name = userdataDict?["bar_name"]
            }
            
            if userdataDict?["store_name"] != nil
            {
            store_name = userdataDict?["store_name"]
            }
            if userdataDict?["outing_day"] != nil
                       {
                       outing_day = userdataDict?["outing_day"]
                       }
            
            if userdataDict?["alcohol_online"] != nil
            {
            alcohol_online = userdataDict?["alcohol_online"]
            }
            
            
//                print(name)
//                print(email)
//                print(token)
        }
                
        return userdataDict ?? nil
    }
    
    
//    var userData: set , get {
//
//    }
    
//    let sharedInstance = saveda
}
