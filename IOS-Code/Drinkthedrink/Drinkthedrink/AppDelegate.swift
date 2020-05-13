//
//  AppDelegate.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 19/12/19.
//  Copyright © 2019 Dotttechnologies. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import SVProgressHUD
import IQKeyboardManagerSwift
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseCoreDiagnostics
import CoreLocation
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate,CLLocationManagerDelegate
{

    var locationAuthorizationStatus : CLAuthorizationStatus?
    
    var selectedLatitude : Double? = 0.0
    var selectedLongitude : Double? = 0.0

    var window: UIWindow?
    var locationManager: CLLocationManager?

    var isNotificationReceived: Bool  = false

      let googleApiKey = "AIzaSyAY0B4xNSzIrro5kII02w8GQwXmt9byMGo"
    
   
    let savedataInstance = SaveDataClass.sharedInstance


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        
    FirebaseApp.configure()
    self.savedataInstance.getUserDetails()
    GMSServices.provideAPIKey("AIzaSyAY0B4xNSzIrro5kII02w8GQwXmt9byMGo")

    GMSPlacesClient.provideAPIKey("AIzaSyAY0B4xNSzIrro5kII02w8GQwXmt9byMGo")

        
    UNUserNotificationCenter.current().delegate = self
             let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
             UNUserNotificationCenter.current().requestAuthorization(
             options: authOptions,
             completionHandler: {_, _ in })
             // For iOS 10 data message (sent via FCM
    Messaging.messaging().delegate = self
    Messaging.messaging().isAutoInitEnabled = true
    application.registerForRemoteNotifications()
        
        
    IQKeyboardManager.shared.enable = true
    SVProgressHUD.setDefaultMaskType(.black)
    SVProgressHUD.setDefaultStyle(.custom)
    SVProgressHUD.setMaximumDismissTimeInterval(1.6)
    SVProgressHUD.setHapticsEnabled(true)
    SVProgressHUD.setErrorImage(UIImage.init(named: "cross")!)
    SVProgressHUD.setSuccessImage(UIImage.init(named: "tick")!)
    SVProgressHUD.setFont(UIFont.init(name: "HelveticaNeue-Bold", size: 20.0)!)
    SVProgressHUD.setAnimationBeginsFromCurrentState(true)
    let greencolor = UIColor.init(red: 27/255.0, green: 111/255.0, blue: 109/255.0, alpha: 1.0)
        SVProgressHUD.setShouldTintImages(true)
        SVProgressHUD.setFadeInAnimationDuration(0.4)
        SVProgressHUD.setFadeOutAnimationDuration(0.4)
        SVProgressHUD.setAnimationDelay(0.5)

        SVProgressHUD.setRingThickness(15.0)
        SVProgressHUD.setRingNoTextRadius(10.0)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setAnimationsEnabled(true)
        SVProgressHUD.setAnimationRepeatCount(2)
    SVProgressHUD.setAnimationRepeatAutoreverses(true)
        SVProgressHUD.setCornerRadius(12.0)
    SVProgressHUD.setBackgroundLayerColor(UIColor.white)
       
        SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.8))
    SVProgressHUD.setForegroundColor(greencolor)
        
        self.getLocation()

        return true
    }
    
    //MARK:- GET LOCATION
    func getLocation()
    {
        locationManager = CLLocationManager()
        locationManager?.delegate = self

        locationManager?.distanceFilter = 40.0
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    //MARK:- LOCATION MANAGER AUTHORIZATION DELEGATE

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        locationAuthorizationStatus = status
        if status == .authorizedWhenInUse
        {
            
            if  RandomObjects.getLatitude() == 25.7616798
            {
        NotificationCenter.default.post(name: Notification.Name("RefreshUI"), object: nil)
            }
            
        print("status is .authorizedWhenInUse")
        self.locationManager?.startUpdatingLocation()
        }
        else if status == .notDetermined
        {
            self.locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()

            print("status is .notDetermined")
        }
        else if status == .denied
        {
        self.locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()

        NotificationCenter.default.post(name: Notification.Name("RefreshUI"), object: nil)
            

        }
        
    }
    
    //MARK:- LOCATION MANAGER  DELEGATE DID UPDATE LOCATIONS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("came in did update locations ")
        if locations.count > 0
        {
            var firstTime : Bool = false
            
            if RandomObjects.getLatitude() == 25.7616798 && (locations[0] ).coordinate.latitude != 0.0

            {
                firstTime = true
            }
            
            
            if (locations[0] ).coordinate.latitude != 0.0
            {
        RandomObjects.setLatitude(lat: (locations[0] ).coordinate.latitude)
            }
            if (locations[0] ).coordinate.longitude != 0.0
            {
        RandomObjects.setLongitude(long: (locations[0] ).coordinate.longitude)
            }
            
            if firstTime == true
            {
            print("comes is firsttime check")
            NotificationCenter.default.post(name: Notification.Name("RefreshUI"), object: nil)
            }
        }
    }

    //MARK:- LOCATION MANAGER FAILED
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("location manager failed to get locations")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
    print("failed to register")
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage)
    {
           print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        print("fcmToken from didReceiveRegistrationToken: \(RandomObjects.getDeviceToken())")
    }
    
    //MARK:- REGISTER DEVICE TOKEN
       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
       {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
               if let error = error {
                   print("Error fetching remote instange ID: \(error)")
               } else if let result = result {
                   print("Remote instance ID token: \(result.token)")

                RandomObjects.setDeviceToken(device_token: result.token)
               }
           })
        
           Messaging.messaging().apnsToken = deviceToken
 
       }
    
    //MARK:- RECEIVED NOTIFICATION
       func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
           print("Handle push from foreground")
           // custom code to handle push while app is in the foreground
        isNotificationReceived = true
        
        if  "\(notification.request.content.userInfo)".contains("new Message")
             {
             self.perform(#selector(callwithDelayforNewMessage), with: nil, afterDelay: 0.4)
             }
             else
             {
                 self.perform(#selector(callwithDelay), with: nil, afterDelay: 0.4)
             }
        
        
        completionHandler(.alert)
        print("\(notification.request.content.userInfo)")
        }

       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
       {

          isNotificationReceived = true
                
        let aps = response.notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary
                
        let alert = aps?["alert"] as? NSDictionary
              
        if  "\(response.notification.request.content.userInfo)".contains("new Message")
        {
        self.perform(#selector(callwithDelayforNewMessage), with: nil, afterDelay: 0.4)

        }
        else
        {
            self.perform(#selector(callwithDelay), with: nil, afterDelay: 0.4)

        }
        

       }
        
    
    //MARK:- PASS NOTIFICATIONS TO OPEN SCREEN ON NOTIFICATION CLICKS
    @objc func callwithDelay()
    {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("OpenNotifications"), object: nil)
        
        
        NotificationCenter.default.post(name: Notification.Name("OpenNotifications"), object: nil)

    }
    
    //MARK:- PASS NOTIFICATIONS TO OPEN SCREEN ON NOTIFICATION CLICKS

    @objc func callwithDelayforNewMessage()
       {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("OpenMessages"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("OpenMessages"), object: nil)
       }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Drinkthedrink")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

