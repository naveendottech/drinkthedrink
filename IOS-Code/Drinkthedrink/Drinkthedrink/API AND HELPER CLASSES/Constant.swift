//
//  Constant.swift
//  KaberaGlobal
//
//  Created by dottechmac5 on 09/08/19.
//  Copyright © 2019 Dot Technologies. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

struct Constant
{
    //APIs live url
    
//    BASE URL FOR SENDING ON TESTFLIGHT
        static let baseUrl   = "https://drinkthedrink.com/api/"

    //live previous url
//    static let baseUrl   = "http://18.221.17.130/drinkthedrink/api/"
    
//   BASE URL FOR DEVELOPMENT
//     static let baseUrl   = "http://18.221.17.130/thedrink/api/"
    
    //for all images
    static let imageBaseUrl = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/"
    
     //for upcoming events and today events of stores only
    static let imageBaseUrlForStoreEvents = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/events/"
    
    static let FollowersprofilePictureBaseUrl = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/profiles/"
    
    static let FollowingsprofilePictureBaseUrl = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/profiles/"
    
    static let cocktailImagesBaseUrl = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/bar_images/thumbs/"
    
    static let searchBarBaseUrl = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/bar_images/thumbs/"
    
    static let searchStoresBaseUrl = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/store_images/thumbs/"
        
    static let BAR_TEAM_IMAGE_BASEURL = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/bar_team/"

    static let STORE_TEAM_IMAGE_BASEURL = "https://s3.us-east-2.amazonaws.com/thedrinkimg/public/store_team/"
    
    //its for searching people for sending messages on edit messages screen
    static let SEARCHPEOPLEAPIONEDITMESSAGES = "search-people"
    
    static let GETMESSAGESHISTORYAPI = "get-all-users-chat"
    static let SENDMESSAGEAPI = "send-message"
    static let GETMESSAGESWITHPARTICULARUSER = "get-user-chat-history"
    
    static let updateProfileImageAPI = "update-profile-image"
    
    static let updateProfileAPI = "update-user"
    static let updateVisibilityApi = "user-visibility"
    
    static let updateCocktailImagesAPI = "update-cocktail-images"
        //FOLLOWERS AND FOLLOWING API

   
    static let getFollowersAPI = "get-followers-api"
    static let getFollowingAPI = "get-following-api"

        //BARS API >
    static let getBarsApi = "get-bars-data"
    static let getBarsDetailsApi = "bar-detail"
    
        //STORES API >
    static let getStoresApi = "get-stores"
    static let getStoressDetailsApi = "store-detail"
    
    static let GETPEOPLEAPI = "get-people"
    
    //ASKING TO SEND REQUEST ON FOLLOW SOMEONE
    static let REQUESTTOFOLLOWAPI = "request-push-notification"

    
    static let blockUnblockAPI = "user-block-unblock"
    //FINAL FOLLOW UNFOLLOW API :>-
    static let followUnFollowApi = "follow-unfollow"
    //FOLLOW STORE API
    static let followUnFollowStoreApi = "store-follow-unfollow"

    static let followUnFollowStoreTeamApi = "store-team-follow-unfollow"
    
    static let followUnFollowBarTeamApi = "bar-team-follow-unfollow"

    static let followUnFollowBarApi = "bar-follow-unfollow"

    static let updateRoleApi = "user/update-role"

    static let DECLINEREQUESTAPI = "decline-request"

    static let SEARCHPEOPLEAPI = "search-people-api"
    static let GETOTHERUSERPROFILEAPI = "get-profile"
    
    static let GETALLNOTIFICATIONSAPI = "get-all-notifications"

    static let LOGINAPI = "user/login"
    
    static let SIGNUPAPI = "user/register"
    
    static let LOGOUTAPI = "logout"
    
    static let FORGOTPASSWORDAPI = "user/forgot-password"
    static let UPDATEPASSWORDAPI = "user/update-password"
    
    static let GETCOUNTRIESANDSTATESAPI = "get-country-state"
    static let GETCITYAPI = "get-cities/"

    
    static let SENDFEEDBACKAPI = "feedback"
    
    static let SEARCHBARNAMEAPI = "search-bar-name"
    static let SEARCHSTORENAMEAPI = "search-store-name"

    
    //search bars and stores api's
    static let SEARCHBARSAPI = "search-bars-api"
    static let SEARCHSTORESAPI = "search-stores-api"
    
    //HB NEED TO CHANGE THIS DYNAMIC
    static let TERMSOFUSEURL = "https://drinkthedrink.com/index.php/privacyPolicy"
    static let PRIVACYPOLICYURL = "https://drinkthedrink.com/index.php/privacyPolicy"

    static  let THEME_DARK_GREEN_COLOR = UIColor.init(red: 27/255.0, green: 111/255.0, blue: 109/255.0, alpha: 1.0)    
}


