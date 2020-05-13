//
//  ViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 19/12/19.
//  Copyright © 2019 Dotttechnologies. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage
import SVProgressHUD
import UberRides
import UberCore
import UserNotifications
import UserNotificationsUI
import MessageUI

import CoreLocation

class HomeViewController: UIViewController,WebServiceDelegate,GMSMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BeginLocationChangesDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,SignUpSuccessProtocolDelegate
{
    //scroll direction
    private var lastContentOffset: CGFloat = 0
//    var btnLoadMore = UIButton()
    
    var tempBarsArray = NSMutableArray()
    let selectedBarFilterArray = NSMutableArray()
    let selectedStoreFilterArray = NSMutableArray()
                            
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    //retain the visibility api :
    var searchEnabled: Bool = false
    var visibilityValue : Int = 0
//    var visibilityValue : Int = 0
    
    //saved data of user
    let savedataInstance = SaveDataClass.sharedInstance
    var addsImagesArray = NSMutableArray()
    
//    var staticArrayofImages = [
//        UIImage.init(named: "img1"),
//        UIImage.init(named: "img2"),
//        UIImage.init(named: "img3"),
//        UIImage.init(named: "img4")
//    ]
    var staticArrayofImages = [
        UIImage.init(named: "newadimg1"),
        UIImage.init(named: "newadimg2"),
        UIImage.init(named: "newadimg3"),
        UIImage.init(named: "newadimg4"),
        UIImage.init(named: "newadimg5")
    ]
    
    var barFilterArray = ["$","$$","$$$","SPECIALS","DRINKSONLY","RESTAURANT","THEMEBAR","NIGHTCLUB","EVENTS","PATIO"]
    
    var storeFilterArray = ["DELIVERY","TASTING"]
    
    var currentLocationMarker : GMSMarker?
    var currentLocationCircle : GMSCircle?
    
    var selectedBar : Int = 0
    var previousBarSelected : Int = 0
    
    //need to implement
    var selectedStore : Int = 0
    var previousStoreSelected : Int = 0

    var timerforChangingAddImages : Timer? = nil
    var imgIndexforChanging : Int = 0

    //BASICALLY ITS USED WITH TIMER FOR DROPING PIN ONE BY ONE
    var indexforDropPin : Int = 0
    
    var timerforPinDropping : Timer? = nil
    
    //BAR ARRAY OBJECT
    var barListArray  = [BarsList]()
    // used for horizontal listing
    var storeListArray  = [StoreList]()

    //BAR DETAILS OBJECT
    var barDetailsObj : BarsDetails? = nil
    var storeDetailsObj : StoreDetails? = nil
    
    var searchedBarDetailsObj : BarsDetails? = nil
    var searchedStoreDetailsObj : StoreDetails? = nil

    
    var peopleArray  = [PeopleList]()
    var btnCenter : CGPoint!

    //CHILD CONTROLLERS >>
    //for all ui which has dropped on this screen other than maps >
    var childVc : MainChildViewController? // bars shown in this screen and details
    var imgesChildVcForbarandStore : NewBarImagesViewController? // bars shown in this screen and details
    var firstTimeFlowChildVc : FirstTimeFlowViewController? // bars shown in this screen and details

    
    var menuChildVc : MenuViewController? // shown menu in this screen with profile and without profile
    var loginChildVc : LoginViewController? // LOGIN SCREEN CHILD
    var signupChildVc : SignUpViewController? // LOGIN SCREEN CHILD
    
    var createAccountStepChildVc : CreateAccountStepOneViewController? // LOGIN SCREEN CHILD
    var profileChildVc : ProfileViewController? // LOGIN SCREEN CHILD
    var editprofileChildVc : EditProfileViewController? // LOGIN SCREEN CHILD
    var followChildVc : FollowersFollowingViewController? // LOGIN SCREEN CHILD
    var feedbackChildVc : FeedbackViewController? // LOGIN SCREEN CHILD
    var messageHistoryChildVc : MessagesHistoryViewController? // MESSAGE HISTORY SCREEN CHILD
      var editmessageChildVc : EditMessageViewController? // MESSAGE HISTORY SCREEN CHILD
    var termsOfUseChildVc : TermsandConditionsViewController? // MESSAGE HISTORY SCREEN CHILD

    var notificationChildVc : NotificationsListViewController? // MESSAGE HISTORY SCREEN CHILD
    var forgotPasswordChildVc : ForgotPasswordViewController?
    // MESSAGE HISTORY SCREEN CHILD

    var updatePasswordChildVc : UpdatePasswordViewController?
    var updatePasswordForgotChildVc : UpdatePasswordForgotViewController?

    //hb 2 mar
//    var choosePlacesChildVc : ChoosePlacesViewController?

    //BOTTOM VIEW WHICH WILL COME UPSIDE ON CLICK ARROW
    
    //MARK:- VARIABLES
    
    //MAIN REFRENCE OF THIS PARTICULAR String for loading map on load View
    let kMapStyle = "[" +
    "  {" +
    "    \"featureType\": \"poi.business\"," +
    "    \"elementType\": \"all\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"transit\"," +
    "    \"elementType\": \"labels.icon\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }" +
    "]"
    
    //MARK:- OUTLETS
    
//    override func viewDidLayoutSubviews() {
//        self.view.layoutIfNeeded()
//       // super.updateViewConstraints()
//
//    }


    @IBOutlet  var googleMap : GMSMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("view frame is \(self.googleMap.frame)")

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOpenNotificationsScreen(notification:)), name: Notification.Name("OpenNotifications"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOpenMessagesScreen(notification:)), name: Notification.Name("OpenMessages"), object: nil)
        
        
         NotificationCenter.default.addObserver(self, selector:#selector(self.refreshUIOnlocationUpdates(notification:)),name: Notification.Name("RefreshUI"), object: nil)
    }
    
    
        func addFirstTimeFlowChild()
        {
    //        @IBOutlet  var btnLeftArrowOnnewBarImages: UIButton!
    //        @IBOutlet  var btnRightArrowOnnewBarImages: UIButton!

            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            firstTimeFlowChildVc   = (storyboard.instantiateViewController(withIdentifier: "FirstTimeFlowViewController") as! FirstTimeFlowViewController)
            firstTimeFlowChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            firstTimeFlowChildVc?.mainSuperViewNewBarImages.backgroundColor = UIColor.black .withAlphaComponent(0.85)
            
            
            if RandomObjects.isFirstTimeFlowNeed() == true
            {
              firstTimeFlowChildVc?.view.isHidden = false
                RandomObjects.setIsFirstTimeFlowNeeded(isNeeded: false)
            }
            else
            {
              firstTimeFlowChildVc?.view.isHidden = true
            }
            
//            firstTimeFlowChildVc?.view.isHidden = true
            
            self.view.addSubview(firstTimeFlowChildVc!.view)
            
            firstTimeFlowChildVc?.loadUI()
      //      firstTimeFlowChildVc?.btnNextOnFirstTimeFlow.addTarget(self, action: #selector(nextButtonClickedonFirstTimefLOW(_:)), for: .touchUpInside)

        }
    
    //@objc func nextButtonClickedonFirstTimefLOW(_ sender: UIButton){
        
    //}//

    
    func addNewImagesChildforBarsandStores()
    {
//        @IBOutlet  var btnLeftArrowOnnewBarImages: UIButton!
//        @IBOutlet  var btnRightArrowOnnewBarImages: UIButton!

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        imgesChildVcForbarandStore   = (storyboard.instantiateViewController(withIdentifier: "NewBarImagesViewController") as! NewBarImagesViewController)
        imgesChildVcForbarandStore?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        imgesChildVcForbarandStore?.mainSuperViewNewBarImages.backgroundColor = UIColor.black .withAlphaComponent(0.85)
        
        imgesChildVcForbarandStore?.view.isHidden = true
        
        self.view.addSubview(imgesChildVcForbarandStore!.view)
        imgesChildVcForbarandStore?.collectionViewBarImagesNew.register(UINib.init(nibName: "BarImagesCell", bundle: nil), forCellWithReuseIdentifier: "BarImagesCell")

        imgesChildVcForbarandStore?.collectionViewBarImagesNew.delegate = self
        imgesChildVcForbarandStore?.collectionViewBarImagesNew.dataSource = self
        
        imgesChildVcForbarandStore?.btnCrossOnNewImagesViewController.addTarget(self, action: #selector(crossButtonClickedOnNewBarandStoreImages(_:)), for: .touchUpInside)
        
        imgesChildVcForbarandStore?.btnLeftArrowOnnewBarImages.addTarget(self, action: #selector(leftArrowClickedonBarandStoreImages(_:)), for: .touchUpInside)
        
        imgesChildVcForbarandStore?.btnRightArrowOnnewBarImages.addTarget(self, action: #selector(rightArrowClickedonBarandStoreImages(_:)), for: .touchUpInside)

    }
    @objc func leftArrowClickedonBarandStoreImages(_ sender: UIButton)
    {
//        +1
        if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                let array = (barDetailsObj?.bar_gallery as! NSArray)
                
                    if (imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage ) == 0
                    {
                        SVProgressHUD.showError(withStatus: "Its first image")
                    }
                else if (imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage ) > 0
                    {
                    imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage  = imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage - 1
                        imgesChildVcForbarandStore?.collectionViewBarImagesNew.scrollToItem(at: IndexPath.init(item: imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage, section: 0), at: .centeredHorizontally, animated: true)
                    }
                    else
                    {
                    SVProgressHUD.showError(withStatus: "Its first image")

                    }
                
            }
        else  if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                let array = (storeDetailsObj?.store_gallery as! NSArray)
                if (imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage ) == 0
                {
                            SVProgressHUD.showError(withStatus: "Its first image")
                }
                
               else if imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage  > 0
                {
                    imgesChildVcForbarandStore?.indexofSelectedBarandStoreImage  = imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage - 1
                     imgesChildVcForbarandStore?.collectionViewBarImagesNew.scrollToItem(at: IndexPath.init(item: imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage, section: 0), at: .centeredHorizontally, animated: true)
                }
                else{
                    SVProgressHUD.showError(withStatus: "Its first image")
                }
                
        
        }
        
    }
    @objc func rightArrowClickedonBarandStoreImages(_ sender: UIButton){
    //        +1
            if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                    let array = (barDetailsObj?.bar_gallery as! NSArray)
                    
                    if (imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage + 1) == array.count
                    {
                        SVProgressHUD.showError(withStatus: "Its last image")

                    }
                   else if (imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage + 1) <= array.count
                        {
                        imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage  = imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage + 1
                            imgesChildVcForbarandStore?.collectionViewBarImagesNew.scrollToItem(at: IndexPath.init(item: imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage, section: 0), at: .centeredHorizontally, animated: true)
                        }
                    else
                    {
                        SVProgressHUD.showError(withStatus: "Its last image")

                    }
                    
                }
            else  if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                    let array = (storeDetailsObj?.store_gallery as! NSArray)
                    if (imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage + 1) == array.count
                    {
                        SVProgressHUD.showError(withStatus: "Its last image")
                    }
                    else if (imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage + 1) <= array.count
                    {
                imgesChildVcForbarandStore?.indexofSelectedBarandStoreImage  = imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage + 1
                imgesChildVcForbarandStore?.collectionViewBarImagesNew.scrollToItem(at: IndexPath.init(item: imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage, section: 0), at: .centeredHorizontally, animated: true)
                    }
                    else{
                        SVProgressHUD.showError(withStatus: "Its last image")
                    }
            }
        }
    @objc func crossButtonClickedOnNewBarandStoreImages(_ sender: UIButton)
    {
        self.view.endEditing(true)
        imgesChildVcForbarandStore?.view.isHidden = true
        imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage = 0
//        self.hideFeedbackScreen()
    }

    
    @objc func storesFilterButtonAction(_ sender: UIButton)
    {
//         childVc?.collectionViewBarsandStoresHeightConstraint.constant = 140.0
        childVc?.peopleFilteruperView.isHidden = false

        indexforDropPin = 0
//        print("NOW IT COMES HERE (CRASHING PREVIOUSLY)")
        timerforPinDropping?.invalidate()
        timerforPinDropping = nil
//        print("its last index for drop pin")
            
        self.childVc?.peopleTableSuperView.isHidden = true
        childVc?.searchType = "store"
        //clear txtfield search , clear arrays etc only
      if childVc?.searchView.isHidden == false
      {
        childVc?.searchView.isHidden = true
      }
        
    self.view.endEditing(true)
       
    if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))! && searchEnabled == false
    {
//        print("already stores selected")
//        return
    }
    else
    {
//        btnLoadMore.setTitle("SHOW MORE ...", for: .normal)
//        btnLoadMore.backgroundColor = UIColor.white .withAlphaComponent(0.6)
//        btnLoadMore.setTitleColor(UIColor.black, for: .normal)
    }
    self.clearAllSearchData()

//        if storeListArray.count == 0
//        {
        self.downTheMenuIfNeeded()
//        }
        
        UIView.animate(withDuration: 0.2)
        {
//            self.childVc?.barsFilterView.isHidden = true
//            self.childVc?.storeFilterView.isHidden = false
     
            self.childVc?.imgRadioStores.image = UIImage.init(named: "selectionon")
            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                self.childVc?.imgRadioBars.image = UIImage.init(named: "selectionoff")
            }
                
            if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                    self.childVc?.imgRadioPeople.image = UIImage.init(named: "selectionoff")

            }
            
            if self.childVc?.collectionViewFilters.isHidden == false
        {
            self.childVc?.collectionViewFilters.reloadData()

            self.childVc?.collectionViewFilters.isHidden = false
        self.childVc?.collectionViewFiltersHeightConstraint.constant = 34
            
              self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 34), width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        else
        {
            self.childVc?.collectionViewFilters.isHidden = true
        self.childVc?.collectionViewFiltersHeightConstraint.constant = 0.0
            
            self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
       }
            
        }
        
        //NEW CHECKS
    if searchEnabled == true && storeListArray.count > 0
    {
                 //for only getting bar details only in case bar details coming from search bars
        self.getStoresDetailsApi(index: selectedStore, isSearchEnabled: false)
    self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedStore, section: 0), at: .centeredHorizontally, animated: true)
               
    }
//    else if storeListArray.count > 0  && storeDetailsObj != nil
//    {
////                hb
////            self.childVc?.view.isUserInteractionEnabled = false
//            self.drawMarkeronMap()
//        self.childVc?.collectionViewBarsandStores.reloadData()
//
//        childVc?.emptyStateImgView.isHidden = true
//
//            self.childVc?.tableBarDetails.reloadData()
//        self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedStore, section: 0), at: .centeredHorizontally, animated: true)
//
//             }
             else
             {
                    
                if  appdelegate.selectedLatitude! != 0.0
                {
                    self.getStoresApi(store_latitude:"\(appdelegate.selectedLatitude!)",store_longitude:"\(appdelegate.selectedLongitude!)")
                }
                else
                {
                
                    self.getStoresApi(store_latitude:"\(RandomObjects.getLatitude())",store_longitude:"\(RandomObjects.getLongitude())")
                }
             }
        // TILL HERE
      }
    
      @objc func barsFilterButtonAction(_ sender: UIButton)
      {
        childVc?.peopleFilteruperView.isHidden = false

        timerforPinDropping?.invalidate()
        if timerforPinDropping != nil
        {
        timerforPinDropping = nil
        }
        indexforDropPin = 0
        childVc?.searchType = "bar"
        self.childVc?.peopleTableSuperView.isHidden = true
        if childVc?.searchView.isHidden == false
        {
            childVc?.searchView.isHidden = true
        }
        self.view.endEditing(true)
        
         
          if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
          {
//            print("already bars selected")
            
          }
          else
          {
//            btnLoadMore.setTitle("SHOW MORE ...", for: .normal)
//            btnLoadMore.backgroundColor = UIColor.white .withAlphaComponent(0.6)
//            btnLoadMore.setTitleColor(UIColor.black, for: .normal)
            
            
            }
        
        
        //REMOVED FOR NEW FUNCTIONALITY
//        if self.childVc?.barsFilterView.isHidden == false && searchEnabled == false
//        {
//            print("already bars selected")
//            return
//        }
        
        self.clearAllSearchData()
        
//        if barListArray.count == 0
//        {
        self.downTheMenuIfNeeded()
//        }
        UIView.animate(withDuration: 0.2)
        {
            self.childVc?.imgRadioBars.image = UIImage.init(named: "selectionon")

            if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                    self.childVc?.imgRadioStores.image = UIImage.init(named: "selectionoff")
                }
                         
            if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                self.childVc?.imgRadioPeople.image = UIImage.init(named: "selectionoff")
                }
            
            if self.childVc?.collectionViewFilters.isHidden == false
             {
            self.childVc?.collectionViewFilters.reloadData()

            self.childVc?.collectionViewFilters.isHidden = false
        self.childVc?.collectionViewFiltersHeightConstraint.constant = 90.0
            self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 90), width: self.view.frame.size.width, height: self.view.frame.size.height)
             }
             else
             {
                
           self.childVc?.collectionViewFilters.isHidden = true
        self.childVc?.collectionViewFiltersHeightConstraint.constant = 0.0
                
        self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
             }
            

        }
        
        
        if searchEnabled == true && barListArray.count > 0
        {
            //for only getting bar details only in case bar details coming from search bars
        self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedBar, section: 0), at: .centeredHorizontally, animated: true)
            
            self.getBarsDetailsApi(index: selectedBar, isSearchEnabled: false)
        
        }
       else if barListArray.count > 0  && barDetailsObj != nil
        {
            
            
                if  appdelegate.selectedLatitude! != 0.0
                {
            self.getBarsApi(barLatiTude: "\(appdelegate.selectedLatitude!)",bar_longitude: "\(appdelegate.selectedLongitude!)" )
                }
                else{
                    
                self.getBarsApi(barLatiTude: "\(RandomObjects.getLatitude())", bar_longitude: "\(RandomObjects.getLongitude())")
                    }

            //HB CHANGES
//        self.drawMarkeronMap()
//    self.childVc?.collectionViewBarsandStores.reloadData()
//        self.childVc?.tableBarDetails.reloadData()
//    self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedBar, section: 0), at: .centeredHorizontally, animated: true)
            //HB CHANGES
        }
        else
        {
            
            
        if  appdelegate.selectedLatitude! != 0.0
        {
    self.getBarsApi(barLatiTude: "\(appdelegate.selectedLatitude!)",bar_longitude: "\(appdelegate.selectedLongitude!)" )
        }
        else{
            
        self.getBarsApi(barLatiTude: "\(RandomObjects.getLatitude())", bar_longitude: "\(RandomObjects.getLongitude())")
            }
        }
      }
    
      @objc func peopleFilterButtonAction(_ sender: UIButton)
      {
        
        if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
           {
//               print("already people selected")
               
           }
           else
           {
//               btnLoadMore.setTitle("SHOW MORE ...", for: .normal)
//               btnLoadMore.backgroundColor = UIColor.white .withAlphaComponent(0.6)
//               btnLoadMore.setTitleColor(UIColor.black, for: .normal)
           }
        
        
        if savedataInstance.getUserDetails() == nil
        {
            signupChildVc?.view.isHidden = false
            signupChildVc?.getAllCountriesAndStatesAPI()
            SVProgressHUD.showError(withStatus: "Please login first to see people.")

            return
        }
        else
        {
            childVc?.peopleFilteruperView.isHidden = true
        }
        
        if childVc?.collectionViewFilters.isHidden == false
        {
//            self.hideAllFilterView()
    self.allFiltersButtonClicked((self.childVc?.btnShowFilters!)!)
            
        }
        
      
        
        
        
        
        timerforPinDropping?.invalidate()
        if timerforPinDropping != nil
        {
        timerforPinDropping = nil
        }
        indexforDropPin = 0
                
        childVc?.searchType = "people"

        if childVc?.searchView.isHidden == false
        {
        childVc?.searchView.isHidden = true
        }
        
        self.view.endEditing(true)
        self.downTheMenuIfNeeded()
          UIView.animate(withDuration: 0.3)
          {
            self.childVc?.imgRadioBars.image = UIImage.init(named: "selectionoff")
            self.childVc?.imgRadioStores.image = UIImage.init(named: "selectionoff")
            self.childVc?.imgRadioPeople.image = UIImage.init(named: "selectionon")
            self.hideAllFilterView()
            
//            self.childVc?.barsFilterView.isHidden = true
//            self.childVc?.storeFilterView.isHidden = true
        }
        self.childVc?.peopleTableSuperView.isHidden = false
        
        if appdelegate.selectedLatitude! != 0.0
        {
                self.getPeopleAPI(latitude:"\(  appdelegate.selectedLatitude!)", longitude: "\(  appdelegate.selectedLongitude!)")
                                
            }
        else
        {
        //GET PEOPLE API
        self.getPeopleAPI(latitude:
            "\(RandomObjects.getLatitude())", longitude: "\(RandomObjects.getLongitude())")
        }
      }
    
    //REMOVE THIS FUNCTION
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789&,."

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if textField == childVc?.txtSearchbar
//        {
//        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//        let filtered = string.components(separatedBy: cs).joined(separator: "")
//
//        return (string == filtered)
//        }
//        else
//        {
            return true
//        }
    }
    
    
//    @objc func loadMoreClicked(_ sender: UIButton)
//    {
//        if sender.backgroundColor == UIColor.white .withAlphaComponent(0.6)
//        {
//            btnLoadMore.setTitle("SHOW LESS ...", for: .normal)
//            btnLoadMore.backgroundColor = UIColor.black .withAlphaComponent(0.6)
//            btnLoadMore.setTitleColor(UIColor.white, for: .normal)
//            print("yes right background color")
//        }
//        else
//        {
//            btnLoadMore.setTitle("SHOW MORE ...", for: .normal)
//            btnLoadMore.backgroundColor = UIColor.white .withAlphaComponent(0.6)
//            btnLoadMore.setTitleColor(UIColor.black, for: .normal)
//
//            print("No its not detecting background color")
//        }
//
//        if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
//        {
//        self.childVc?.collectionViewBarsandStores.reloadData()
//        self.childVc?.tableBarDetails.reloadData()
//        }
//        else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
//        {
//        self.childVc?.collectionViewBarsandStores.reloadData()
//        self.childVc?.tableBarDetails.reloadData()
//        }
//        else if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
//        {
//            childVc?.tblPeople.reloadData()
//        }
//        self.drawMarkeronMap()
//
//    }
    @objc func appMovedToForeground() {
        print("appMovedToForeground")
        
        if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            self.barsFilterButtonAction((self.childVc?.btnBars)!)
        }
        if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            self.storesFilterButtonAction((self.childVc?.btnStores)!)
        }
        if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            self.peopleFilterButtonAction((self.childVc?.btnPeople)!)
        }
        
        
    }
   @objc func appMovedToBackground() {
        print("appMovedToBackground")
    }
    //MARK:- ADD CHILD FOR BAR UI AND ALL
    func addChildforUI()
    {
        
            let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        
    selectedBarFilterArray.add("SPECIALS")
        //addObjects(from: barFilterArray)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
              //let viewController: MainChildViewController
    childVc   = (storyboard.instantiateViewController(withIdentifier: "MainChildViewController") as! MainChildViewController)
        
    childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 90), width: self.view.frame.size.width, height: self.view.frame.size.height)

    self.view.addSubview(childVc!.view)
        
    self.getAddressfromLatLong()
        
        //GIVEN CORNER RADIUS FROM TOP
//
    childVc?.btnArrow.addTarget(self, action: #selector(arrowButtonClicked(_:)), for: .touchUpInside)
        
        //FOR NOW HB SOLVING PEOPLE FIRST TIME CLICK IF ISSUE EXISR HIDE THIS LINE HB 12 MARCH
        self.childVc?.imgArrow.image = UIImage.init(named: "up")
        
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pangestureClicked(gesture:)))
    childVc?.btnArrow.tag = 786
        
    self.childVc!.view.gestureRecognizers = [panGesture]
    self.view.gestureRecognizers = [panGesture]
    childVc?.btnArrow.addGestureRecognizer(panGesture)

    childVc?.btnDismiss.addTarget(self, action: #selector(arrowButtonClicked(_:)), for: .touchUpInside)
        
    //bars filters by default values
        
    //HB HIDDEN TODA
        
    childVc?.imgRadioBars.image = UIImage.init(named: "selectionon")
        
        //people filters by default values
    childVc?.imgRadioPeople.image = UIImage.init(named: "selectionoff")
        
        //STORES filters by default values
    childVc?.imgRadioStores.image = UIImage.init(named: "selectionoff")
        
    self.hideAllFilterView()
        
    childVc?.searchType = "bar"
        
    childVc?.btnBars.addTarget(self, action: #selector(barsFilterButtonAction(_:)), for: .touchUpInside)
              
    childVc?.btnStores.addTarget(self, action: #selector(storesFilterButtonAction(_:)), for: .touchUpInside)
              
    childVc?.btnPeople.addTarget(self, action: #selector(peopleFilterButtonAction(_:)), for: .touchUpInside)
        
        
    childVc?.btnMenu.addTarget(self, action: #selector(menuButtonClicked(_:)), for: .touchUpInside)
        
    childVc?.txtSearchbar.clearButtonMode = .always

        //collection view for bars aqnd stores listing
//    childVc?.tblsearch.register(UINib.init(nibName: "SearchBarsCell", bundle: nil), forCellReuseIdentifier: "SearchBarsCell")
        
    childVc?.tblsearch.register(UINib.init(nibName: "PlacesCell", bundle: nil), forCellReuseIdentifier: "PlacesCell")
        
        childVc?.tblsearch.dataSource = childVc

        childVc?.tblsearch.delegate = self

        //GIVEN ONLY DELEGATES HERE
  childVc?.collectionViewBarsandStores.register(UINib.init(nibName: "BarsListCell", bundle: nil), forCellWithReuseIdentifier: "BarsListCell")
        
    childVc?.collectionViewBarsandStores.delegate = self
        childVc?.collectionViewBarsandStores.dataSource = self
       childVc?.tableBarDetails.register(UINib.init(nibName: "BarDetailsCell", bundle: nil), forCellReuseIdentifier: "BarDetailsCell")
        childVc?.tableBarDetails.register(UINib.init(nibName: "StoreDetailCell", bundle: nil), forCellReuseIdentifier: "StoreDetailCell")
        
        childVc?.tableBarDetails.delegate = self
        childVc?.tableBarDetails.dataSource = self
        childVc?.tableBarDetails.estimatedRowHeight = 200
        
        //adding app logo on screen
        let imgAppLogo = UIImageView(frame: CGRect.init(x:(self.view.frame.size.width - (self.view.frame.size.width / 3.4) - 17) , y: 0, width: self.view.frame.size.width / 3.4, height: 120))
        
        imgAppLogo.contentMode = .scaleAspectFit
        
        imgAppLogo.image = UIImage.init(named: "applogo")
        self.view.addSubview(imgAppLogo)

        
//        //2 mar
//        btnLoadMore = UIButton(frame: CGRect.init(x: 40 , y: 45, width: 150, height: 30))
//        btnLoadMore.layer.borderColor = UIColor.white.cgColor
//        btnLoadMore.layer.borderWidth = 2.0
//        btnLoadMore.layer.cornerRadius = 5.0
//        btnLoadMore.clipsToBounds = true
//
//        btnLoadMore.contentHorizontalAlignment = .left
//
////        btnLoadMore.titleLabel?.textAlignment = .left
//
//        btnLoadMore.setTitle("SHOW MORE ...", for: .normal)
//        btnLoadMore.backgroundColor = UIColor.white .withAlphaComponent(0.6)
//        btnLoadMore.setTitleColor(UIColor.black, for: .normal)
//        btnLoadMore.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Bold", size: 13.0)!
//
//        btnLoadMore.layer.masksToBounds = false
//        btnLoadMore.layer.shadowColor = UIColor.darkGray.cgColor
//        btnLoadMore.layer.shadowOpacity = 1.0
//        btnLoadMore.layer.shadowRadius = 0
//        btnLoadMore.layer.shadowOffset = CGSize.init(width: 0, height: 1.0)
//
//        btnLoadMore.addTarget(self, action: #selector(loadMoreClicked(_:)), for: .touchUpInside)
//
//        self.view.addSubview(btnLoadMore)
        
        self.view.bringSubviewToFront(imgAppLogo)
        self.childVc?.collectionViewBarsandStores.isHidden = true
   
        for _ in 0..<100{
            addsImagesArray.addObjects(from: staticArrayofImages as [Any])
        }
        
//        print(addsImagesArray.count)
    childVc?.collectionViewForAds.register(UINib.init(nibName: "BarImagesCell", bundle: nil), forCellWithReuseIdentifier: "BarImagesCell")
        
        self.childVc?.collectionViewForAds.isHidden = true
        self.childVc?.collectionViewForAds.dataSource = self
        self.childVc?.collectionViewForAds.delegate = self
        
        self.childVc?.collectionViewForAds.isScrollEnabled = false
        
        DispatchQueue.main.async
        {
        self.childVc?.collectionViewForAds.reloadData()
        }
        
        self.childVc?.collectionViewForAds.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        
        self.childVc?.txtSearchbar.addTarget(self.childVc, action: #selector(self.childVc!.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
                
        childVc?.peopleTableSuperView.isHidden = true
                
        childVc?.tblPeople.register(UINib.init(nibName: "GetPeopleCell", bundle: nil), forCellReuseIdentifier: "GetPeopleCell")
        
        //FILTERS IS HIDDEN IN THIS CASE
        childVc?.collectionViewFilters.register(UINib.init(nibName: "FiltersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiltersCollectionViewCell")
        
        childVc?.btnShowFilters.addTarget(self, action: #selector(allFiltersButtonClicked(_:)), for: .touchUpInside)

        childVc?.collectionViewFilters.dataSource = self
        childVc?.collectionViewFilters.delegate = self
        childVc?.collectionViewFiltersHeightConstraint.constant = 90.0
        
//        childVc?.collectionViewFilters.scroll
//        childVc?.collectionViewFilters.direction
        
        childVc?.collectionViewFilters.isHidden = false
        
        //GIVEN DELEGATE TO CURRENT VIEW
        childVc?.tblPeople.delegate = self
        childVc?.tblPeople.dataSource = self
        
        self.childVc?.txtSearchbar.delegate = self

        // hb 2 mar
//        self.childVc?.txtSearchbar.delegate = self.childVc
        self.childVc?.view.layoutIfNeeded()
        self.addMenuViewChild()
        
//      self.addChoosePlacesChildVc()
        
        self.addNewImagesChildforBarsandStores()
        self.addLoginViewChild()
        self.addForgotPasswordChild()
        self.addSignUpViewChild()
        self.addCreateAccountStepScreenChild()
        self.addProfileViewChild()
        self.addEditProfileViewChild()
        self.addUpdatePasswordViewChild()
        self.addUpdatePasswordForgotViewChild()
        self.addFollowViewChild()
        self.addFeedbackViewChild()
        self.addMessagesHistoryViewChild()
        self.addEditMessagesViewChild()
        self.addTermsandConditionsChild()
        self.addNotificationViewChild()
                
//        print("check address before bars api hit\(choosePlacesChildVc!.txtSearchPlaces.text)")
        
        if RandomObjects.getLatitude() != 25.7616798 && appdelegate.locationAuthorizationStatus == .authorizedWhenInUse
        {
        self.getAddressfromLatLong()
        self.getBarsApi(barLatiTude: "\(RandomObjects.getLatitude())",bar_longitude : "\(RandomObjects.getLongitude())")
        }
        else if appdelegate.locationAuthorizationStatus == .denied
        {
        self.getAddressfromLatLong()
        self.getBarsApi(barLatiTude: "\(RandomObjects.getLatitude())",bar_longitude : "\(RandomObjects.getLongitude())")
            
//        print("ADDRESS NOT SHOWN IN THIS CASE")
        }
        else if RandomObjects.getLatitude() != 25.7616798
        {
        self.getAddressfromLatLong()
        self.getBarsApi(barLatiTude: "\(RandomObjects.getLatitude())",bar_longitude : "\(RandomObjects.getLongitude())")
        }

    childVc?.delegate = self
        
    childVc?.txtSearchbar.autocorrectionType = UITextAutocorrectionType.no
      
    childVc?.txtSearchbar.clearButtonMode = .always
        
    childVc?.tblsearch.estimatedRowHeight = 100.0
        
        
        if (self.savedataInstance.getUserDetails() != nil)
        {
    self.getMyProfileandUpdateData()
        }
        
        if (self.savedataInstance.getUserDetails() != nil)
        {
            
        }
        else
        {
            self.addFirstTimeFlowChild()
//        self.showFirstTimeFlowPopup()
        }
    }
    
    func getAddressfromLatLong()
    {
           var location : CLLocation?
           if   appdelegate.selectedLatitude! != 0.0
           {
                 location = CLLocation(latitude: appdelegate.selectedLatitude!, longitude:  appdelegate.selectedLongitude!)
           }
           else
            {
                location = CLLocation(latitude: RandomObjects.getLatitude(), longitude:  RandomObjects.getLongitude()) //changed!!!
           }
//            print(location)

            CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
//                print(location)

                if error != nil {
                    print("ERROR IN FETCHING ADDRESS \(error)")

                    return
                }
                if placemarks?.count ?? 0 > 0 {
                    let pm = placemarks?[0] as! CLPlacemark
//                    print(pm.locality)
                    
                    var addressString : String = ""
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
                    
                if self.childVc != nil
                {
                    self.childVc?.txtSearchbar.text = addressString
                }
//            print("CHECK ADDRESS : \(addressString)")
                                    
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
            
        }
    
    //MENU BUTTON CLICKED OPEN MENU VIEW
    @objc func menuButtonClicked(_ sender: UIButton)
    {
        
        if (self.savedataInstance.getUserDetails() != nil)
        {
        self.getMyProfileandUpdateData()
        }
        
        
        self.view.endEditing(true)
        if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))!
        {
            //87.0
    if (self.savedataInstance.getUserDetails() != nil)
    {
        menuChildVc?.mainViewBottomConstraint.constant = self.view.frame.size.height - 200 - 366
    }
    else
    {
    
        menuChildVc?.mainViewBottomConstraint.constant = (childVc!.btnMenu.frame.origin.y) + ((childVc!.txtSearchbar.superview?.frame.size.height)!) + (menuChildVc?.mainMenuView.frame.size.height)! - 20
        
//            - 120
                //120 is btndismiss height constraint and top bottom of searchbar superview(has search bar)
//        print(menuChildVc?.mainViewBottomConstraint.constant)
//                100 is for dismiss button
                
//                print(self.view.frame.size.height - childVc?.searchView.frame.size.height)
                
//            self.view.frame.size.height - 300
//                working good
//            menu
                
//                menuChildVc?.mainViewBottomConstraint.constant = self.view.frame.size.height - childVc?.searchView.frame.size.height
//                + 380
            }
  
     
        }
        else
        {
            
            
            menuChildVc?.mainViewBottomConstraint.constant = 130 + (childVc?.collectionViewFiltersHeightConstraint.constant)!
//        print("Came in 100 bottom")
        }
        
        if (self.savedataInstance.getUserDetails() != nil )
        {
            
//         print("user details not nil")
        //user is already logged in
            menuChildVc?.lblName.text = "\(self.savedataInstance.name!)"
            
//            if RandomObjects.checkValueisNilorNull(value: self.savedataInstance.my_status) == false
//            {
//                if "\(self.savedataInstance.my_status!)".isEmpty == true
//                {
//                        menuChildVc?.txtStatus.text = "MY STATUS ..."
//                }
//                else
//                {
//            menuChildVc?.txtStatus.text = "\(self.savedataInstance.my_status!)".uppercased()
//                }
//            }
//            else if "\(self.savedataInstance.my_status!)".isEmpty == true
//            {
//                menuChildVc?.txtStatus.text = "MY STATUS ..."
//            }
//            else
//            {
//                menuChildVc?.txtStatus.text = "MY STATUS ..."
//            }
            
            if  self.savedataInstance.follow_by  != nil
            {
            menuChildVc?.lblFollowersCount.text = "\(self.savedataInstance.follow_by!)"
            }
            
            if  self.savedataInstance.follow_to != nil
            {
            menuChildVc?.lblFollowingCount.text = "\(self.savedataInstance.follow_to!)"
            }
        menuChildVc?.btnLoginRegisterOrInviteFriends.setTitle("INVITE FRIENDS", for: .normal)
            
            menuChildVc?.profileView.isHidden = false
            
            let imgStr: String = RandomObjects.getUserOwnProfileImageStr()
            
        menuChildVc?.btnImgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            
            menuChildVc?.btnImgProfile.sd_setImage(with: URL.init(string: imgStr), for: .normal, placeholderImage: UIImage.init(named: "profileplaceholder"), options: .refreshCached, completed: { (img, err, cache, url) in
                
            })
            
//            menuChildVc?.btnImgProfile.sd_setImage(with: URL.init(string: imgStr), for: .normal, completed: { (img, err, SDImageCacheType, imgUrl) in
//
//                if err != nil
//                {
//
//                }
//                else{
//
//
//                }
                
//            })
            
        menuChildVc?.btnImgProfile.layer.cornerRadius = 70/2
            
            menuChildVc?.btnImgProfile.clipsToBounds = true
        menuChildVc?.btnImgProfile.layer.masksToBounds = true
            
            
            if savedataInstance.visibility_status != nil{
            
            if  "\(savedataInstance.visibility_status!)" == "1"
            {
            visibilityValue = 1
                menuChildVc?.imgVisibilityOnMenu.image = UIImage.init(named: "NEWON")
                
                menuChildVc?.btnImgProfile.layer.borderColor = Constant.THEME_DARK_GREEN_COLOR.cgColor
                menuChildVc?.btnImgProfile.layer.borderWidth = 3.0
                
            }
            else
            {
                menuChildVc?.btnImgProfile.layer.borderColor = UIColor.clear.cgColor
                menuChildVc?.btnImgProfile.layer.borderWidth = 0.0
                
            visibilityValue = 0
            menuChildVc?.imgVisibilityOnMenu.image = UIImage.init(named: "NEWOFF")
            }
            }
            else{
                visibilityValue = 0
                
                menuChildVc?.imgVisibilityOnMenu.image = UIImage.init(named: "NEWOFF")
                
                menuChildVc?.btnImgProfile.layer.borderColor = UIColor.clear.cgColor
                menuChildVc?.btnImgProfile.layer.borderWidth = 0.0
            }

//            cell.imgBars.sd_imageIndicator = SDWebImageActivityIndicator.gray
//
//            cell.imgBars.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "imgMarker"))
            
            menuChildVc?.btnLogout.setTitle("LOGOUT", for: .normal)
            menuChildVc?.btnLogoutHeightConstraint.constant = 35.0
            
            
            
        menuChildVc?.mainMenuView.layer.cornerRadius = 13.0
            menuChildVc?.mainMenuView.clipsToBounds = true

        menuChildVc?.menuView.layer.cornerRadius = 0.0
           menuChildVc?.menuView.clipsToBounds = true

         }
         else
         {
        menuChildVc?.btnLogoutHeightConstraint.constant = 0.0
        menuChildVc?.btnLogout.setTitle("", for: .normal);
        menuChildVc?.btnLoginRegisterOrInviteFriends.setTitle("REGISTER/LOGIN", for: .normal)
        menuChildVc?.profileView.isHidden = true
            
            menuChildVc?.menuView.layer.cornerRadius = 13.0
            menuChildVc?.menuView.clipsToBounds = true
            
            menuChildVc?.mainMenuView.layer.cornerRadius = 0
            menuChildVc?.mainMenuView.clipsToBounds = true

            
//             print("user details are nil")
         }
        
        menuChildVc?.view.isHidden = false
    }
    
    @objc func editMessageButtonClickedfromMenu(_ sender: UIButton)
    {
            self.view.endEditing(true)
            editmessageChildVc?.view.isHidden = false
            editmessageChildVc?.isCreatingNewMessage = true
            editmessageChildVc!.txtSearchEditMessagesUsers.text = ""
            editmessageChildVc!.txtMessageonEditMessage.text = ""
            editmessageChildVc?.loadUI()
    }
    
    func addMenuViewChild(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
        menuChildVc   = (storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController)
            
        menuChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        menuChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
                
        menuChildVc?.view.isHidden = true
        self.view.addSubview(menuChildVc!.view)
        
        menuChildVc?.btnSearchPeopletoEditMessage.addTarget(self, action: #selector(editMessageButtonClickedfromMenu(_:)), for: .touchUpInside)

        
    menuChildVc?.btnMenuViewSuperView.addTarget(self, action: #selector(crossButtonClickedOnMenuView(_:)), for: .touchUpInside)
        
//    menuChildVc?.btnChooseLocation.addTarget(self, action: #selector(chooseLocationActionOnMenu(_:)), for: .touchUpInside)
        
    menuChildVc?.btnFeedBack.addTarget(self, action: #selector(feedbackButtonAction(_:)), for: .touchUpInside)
        
    menuChildVc?.btnLoginRegisterOrInviteFriends.addTarget(self, action: #selector(loginRegisterActionfromMenu(_:)), for: .touchUpInside)
        
        menuChildVc?.btnImgProfile.addTarget(self, action: #selector(openUserProfileScreen(_:)), for: .touchUpInside)
        menuChildVc?.btnEditProfileonMenu.addTarget(self, action: #selector(editProfileClickedfromBothOptions(_:)), for: .touchUpInside)
        
        menuChildVc?.btnFollowUnfollow.addTarget(self, action: #selector(showFollowScreenFromMenu(_:)), for: .touchUpInside)

    menuChildVc?.btnVisibilityOnMenu.addTarget(self, action: #selector(setVisibilityAction(_:)), for: .touchUpInside)
        menuChildVc?.btnMessagesOnMenu.addTarget(self, action: #selector(messagesHistoryButtonAction(_:)), for: .touchUpInside)
         menuChildVc?.btnLogout.addTarget(self, action: #selector(logoutButtonClicked(_:)), for: .touchUpInside)
        
         menuChildVc?.btnNotification.addTarget(self, action: #selector(notificationsButtonClickedOnMenu), for: .touchUpInside)
//           menuChildVc?.btnStatusonMenu.addTarget(self, action: #selector(statusButtonClickedOnMenu(_:)), for: .touchUpInside)
    }
    
    
    //OPEN EDIT PROFILE SCREEN FROM PROFILE SCREEN AN HOME SCREEN MENU ALSO
//    @objc func statusButtonClickedOnMenu(_ sender: UIButton)
//    {
//
//
//    self.view.endEditing(true)
//
////    editprofileChildVc?.txtMyStatus.becomeFirstResponder()
////    editprofileChildVc?.txtMyStatus.becomeFirstResponder()
//
//        //IN CASE BOTTOM SHEET IS OPEN : FIRST IT SHOULD BE CLOSED
//            if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))!
//            {
//
//            if timerforChangingAddImages != nil
//            {
//                timerforChangingAddImages?.invalidate()
//                timerforChangingAddImages = nil
//            }
//            timerforChangingAddImages?.invalidate()
//        self.childVc?.collectionViewBarsandStores.isHidden = true
//            self.childVc?.collectionViewForAds.isHidden = true
//
//            childVc!.view.backgroundColor = UIColor.clear
//
//            self.childVc?.imgArrow.image = UIImage.init(named: "up")
//
//            UIView.animate(withDuration: 0.4)
//            {
//                    self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
////                print("down image selected")
//            }
//                self.childVc?.btnDismissHeightConstraint.constant = 0
//
//            }
//
//        if profileChildVc?.view.isHidden == false{
//           profileChildVc?.view.isHidden = true
//        }
//
//        if menuChildVc?.view.isHidden == false{
//            menuChildVc?.view.isHidden = true
//        }
//        editprofileChildVc?.isAnythingChanged = false
//        //UNHIDE EDIT PROFILE VIEW
//    editprofileChildVc?.setUpEditProfileDetails()
//    editprofileChildVc?.openStatusKeyboard()
//
//    editprofileChildVc?.view.isHidden = false
//
////    print("SHOW EDIT PROFILE")
//    }
    
    @objc func notificationsButtonClickedOnMenu(_ sender: Any)
    {
        notificationChildVc?.view.isHidden = false
        notificationChildVc?.loadUI()
    }
    
 func showFirstTimeFlowPopup()
    {
        self.view.endEditing(true)
            let alert = UIAlertController(title: "Please Register", message: "Please register to get discounts and use extra features of app.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "SIGN UP", style: .default, handler: { _ in
    //                self.openCamera()
                self.signupChildVc?.view.isHidden = false
                self.signupChildVc?.getAllCountriesAndStatesAPI()
            }))

            alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { _ in
                
            }))

            self.present(alert, animated: true, completion: nil)
        }
    
    
    
    @objc func logoutButtonClicked(_ sender: Any)
    {
    
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
//                self.openCamera()
            self.logoutApi()

        }))

        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { _ in
            
        }))


        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func logoutApi()
    {
        let params = NSMutableDictionary()
        params.setValue(savedataInstance.id, forKey: "id")
//        print("params for get bars api \(params)")
        params.setValue(RandomObjects.getDeviceToken(), forKey: "device_token")
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "Please check your internet connection.")
            break
                 // Show alert if internet not available.
                 //show alert
             default:
                 ApiManager.sharedManager.delegate = self
                 SVProgressHUD.show(withStatus: "Logging out.")

                ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.LOGOUTAPI as NSString,currentView: self.view)
             }
         }
    
    
    
    @objc func privacyButtonClicked(_ sender: Any){
        self.view.endEditing(true)
        termsOfUseChildVc?.view.isHidden = false
        termsOfUseChildVc?.isTermsScreen = false
        termsOfUseChildVc?.loadUI()
      }
    
      @objc func termsandConditionsButtonClicked(_ sender: Any)
      {
          
    self.view.endEditing(true)
    termsOfUseChildVc?.view.isHidden = false
    termsOfUseChildVc?.isTermsScreen = true
    termsOfUseChildVc?.loadUI()
      }
    
    
    //OPEN MESSAGE HISTORY SCREEN :
    @objc func messagesHistoryButtonAction(_ sender: UIButton)
    {
        
        if messageHistoryChildVc!.searchedMessageHistoryArray.count > 0
        {            messageHistoryChildVc?.searchedMessageHistoryArray.removeAll()
        }
        
    messageHistoryChildVc?.txtSearchMessagesHistoryUsers.text = ""
        
        if menuChildVc?.view.isHidden == false
        {
            menuChildVc?.view.isHidden = true
        }
        
        messageHistoryChildVc?.view.isHidden = false
        messageHistoryChildVc?.loadUI()
    }

    
    
    @objc func setVisibilityAction(_ sender: UIButton){
        self.view.endEditing(true)
        
        if (menuChildVc?.imgVisibilityOnMenu.image?.isEqual(UIImage.init(named: "NEWOFF")))!
        {
            self.setVisiBilityApi(value: 1)
            visibilityValue = 1

        }
        else
        {
            visibilityValue = 0
            self.setVisiBilityApi(value: 0)
        }
    }
    
         //MARK:-  SET VISIBILITY API
    func setVisiBilityApi(value: Int)
    {
        let params = NSMutableDictionary()
        params.setValue(savedataInstance.id, forKey: "id")
        params.setValue("\(value)", forKey: "visibility_status")
        
        if   appdelegate.selectedLatitude! != 0.0
           {
        params.setValue(appdelegate.selectedLatitude!, forKey: "user_latitude")
        params.setValue(appdelegate.selectedLongitude!, forKey: "user_longitude")
          }
        else
        {
        params.setValue(RandomObjects.getLatitude(), forKey: "user_latitude")
        params.setValue(RandomObjects.getLongitude(), forKey: "user_longitude")
            
        }
        
        params.setValue("public", forKey: "visible_for")


        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "Please check your internet connection.")
            break
                 // Show alert if internet not available.
                 //show alert
             default:
                 ApiManager.sharedManager.delegate = self
                 SVProgressHUD.show(withStatus: "Updating Visibility...")

                ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.updateVisibilityApi as NSString,currentView: self.view)
             }
         }
    

    
    @objc func showFollowScreenFromMenu(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if profileChildVc?.view.isHidden == false
        {
            profileChildVc?.view.isHidden = true
        }
        
        if editprofileChildVc?.view.isHidden == false
        {
            editprofileChildVc?.view.isHidden = true
        }
              
        if menuChildVc?.view.isHidden == false
        {
            menuChildVc?.view.isHidden = true
        }
        followChildVc?.tblFollowers.delegate = self
        followChildVc?.tblFollowing.delegate = self
        followChildVc?.loadUI()
        followChildVc?.view.isHidden = false
    }
         @objc func openUserProfileScreen(_ sender: UIButton)
     {
        self.view.endEditing(true)
         if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))!
        {
         //means menu is open
    self.childVc?.collectionViewBarsandStores.isHidden = true

         childVc!.view.backgroundColor = UIColor.clear
                 
         if timerforChangingAddImages != nil
         {
         timerforChangingAddImages?.invalidate()
         timerforChangingAddImages = nil
         }
         timerforChangingAddImages?.invalidate()
                 
         self.childVc?.imgArrow.image = UIImage.init(named: "up")
                 
         UIView.animate(withDuration: 0.4)
         {
         self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
                     
         self.childVc?.btnDismissHeightConstraint.constant = 0
         }
         UIView.animate(withDuration: 0.2)
         {
               self.view.layoutIfNeeded()
         }
         menuChildVc?.view.isHidden = true
        }
        else{
             //means menu is closed
//         print("already closed")
//             print("dismiss menu view")
             menuChildVc?.view.isHidden = true
        }
        profileChildVc?.view.isHidden = false
        
        profileChildVc?.isOtherUserProfile = false
        
        profileChildVc?.otherUserProfileDataObj = nil
        profileChildVc?.selectedPeopleObj = nil
        profileChildVc?.otherUserId = 0
//        profileChildVc?.otherPeopleObj = nil
        
        profileChildVc?.setUpProfileDetails()
     }
    
    //MENU CHILD CROSS ACTION
    @objc func crossButtonClickedOnMenuView(_ sender: UIButton)
     {
        self.view.endEditing(true)
//         print("dismiss menu view")
         menuChildVc?.view.isHidden = true
        
        //refreshed people
        if savedataInstance.getUserDetails() != nil
        {
            if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                self.peopleFilterButtonAction((self.childVc?.btnPeople)!)
            }

        }
     }
    


    @objc func feedbackButtonAction(_ sender: UIButton)
    {
        self.downTheMenuIfNeeded()
         if profileChildVc?.view.isHidden == false
        {
            profileChildVc?.view.isHidden = true
        }
       
        if editprofileChildVc?.view.isHidden == false
        {
            editprofileChildVc?.view.isHidden = true
        }
       
        if menuChildVc?.view.isHidden == false
        {
            menuChildVc?.view.isHidden = true
        }
        
        feedbackChildVc?.txtfeedback.text = ""
        
        feedbackChildVc?.loadUI()
        feedbackChildVc?.view.isHidden = false
     }

    

    
            @objc func openInviteScreen()
            {
                self.downTheMenuIfNeeded()
                self.menuChildVc?.view.isHidden = true
                self.view.endEditing(true)
                let alert = UIAlertController(title: "Choose Invite Option", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Mail", style: .default, handler: { _ in
                    self.sendEmailInvitation()
                }))
                alert.addAction(UIAlertAction(title: "Message", style: .default, handler: { _ in
                    self.sendMessageInvitation()

                }))
                self.present(alert, animated: true, completion: nil)
            }
        
    func sendEmailInvitation() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients([])
            
            mail.setMessageBody("Please download Drinkthedrink app :\niOS\nhttps://apps.apple.com/us/app/drinkthedrink/id1487112489?ls=1\nAndroid\nhttps://play.google.com/store/apps/details?id=com.mjdistillers.drinkthedrink", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func sendMessageInvitation()
    {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self

        // Configure the fields of the interface.
        composeVC.recipients = []
        composeVC.body = "Please download Drinkthedrink app :\niOS\nhttps://apps.apple.com/us/app/drinkthedrink/id1487112489?ls=1\nAndroid\nhttps://play.google.com/store/apps/details?id=com.mjdistillers.drinkthedrink"

        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }

        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        controller.dismiss(animated: true)

    }
    
    
    
    @objc func loginRegisterActionfromMenu(_ sender: UIButton)
    {
        self.view.endEditing(true)
        //IN PROGRESS
        
     
        if    RandomObjects.checkValueisNilorNull(value: savedataInstance.email) == false
        {
            self.openInviteScreen()
            //show invite screen here basically
            return
        }
        
        self.downTheMenuIfNeeded()
         menuChildVc?.view.isHidden = true
    signupChildVc?.view.isHidden = false
//    signupChildVc?.viewSpecialityHeightConstraint.constant = 0.0
        signupChildVc?.getAllCountriesAndStatesAPI()
        //HERE JUST OPEN login screen : will continue to add child as login
    }
    
    
    //SIGN UP CHILD ADDED
    func addForgotPasswordChild()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        forgotPasswordChildVc   = (storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController)
        
        forgotPasswordChildVc!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        forgotPasswordChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
        forgotPasswordChildVc?.view.isHidden = true
        forgotPasswordChildVc?.txtEmailonForgotPassword.attributedPlaceholder = NSAttributedString(string: "EMAIL",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
        forgotPasswordChildVc?.btnsubmitForgotPassword.addTarget(self, action: #selector(forgotPasswordAction(_:)), for: .touchUpInside)
        forgotPasswordChildVc?.loadUI()
        self.view.addSubview(forgotPasswordChildVc!.view)
    }
    
    
    @objc func forgotPasswordAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if forgotPasswordChildVc?.txtEmailonForgotPassword.text?.isEmpty == true {
            SVProgressHUD.showError(withStatus: "Please enter email.")
        }
        else  if (forgotPasswordChildVc?.txtEmailonForgotPassword.text?.isValidEmail()) == false
        {
            SVProgressHUD.showError(withStatus: "Please enter valid email.")

        }
     else
     {
        
        if forgotPasswordChildVc?.lblTitleForgotPassword.text == "Send email invitation"
        {
            forgotPasswordChildVc?.view.isHidden = true
        }
        else{
            //hit api for login
            self.hitForgotPasswordApi()
        }
        }
        
    }
    
    //MARK:-  LOGIN API HIT
    func hitForgotPasswordApi()
    {
        let params = NSMutableDictionary()
        params.setValue(forgotPasswordChildVc?.txtEmailonForgotPassword.text!, forKey: "email")
//        print("login parameters : \(params)")
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "Please check your internet connection.")
        break
                // Show alert if internet not available.
                //show alert
        default:
            
        ApiManager.sharedManager.delegate = self
            print("forgot password params\(params)")
        print("forgot password url path \(Constant.FORGOTPASSWORDAPI)")
        SVProgressHUD.show(withStatus: "Loading ...")
        ApiManager.sharedManager.postDataOnserver(
            params: params,
            postUrl:Constant.FORGOTPASSWORDAPI as NSString,
            currentView: self.view)
            }
        }
    
    
    func addUpdatePasswordForgotViewChild()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        updatePasswordForgotChildVc   = (storyboard.instantiateViewController(withIdentifier: "UpdatePasswordForgotViewController") as! UpdatePasswordForgotViewController)
        
        updatePasswordForgotChildVc!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        updatePasswordForgotChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
        updatePasswordForgotChildVc?.view.isHidden = true

        updatePasswordForgotChildVc?.txtPasswordonUpdatePassword.attributedPlaceholder = NSAttributedString(string: "NEW PASSWORD",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        updatePasswordForgotChildVc?.loadUI()
        self.view.addSubview(updatePasswordForgotChildVc!.view)
    }
    
    
    //SIGN UP CHILD ADDED
    func addUpdatePasswordViewChild()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        updatePasswordChildVc   = (storyboard.instantiateViewController(withIdentifier: "UpdatePasswordViewController") as! UpdatePasswordViewController)
        
        updatePasswordChildVc!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        updatePasswordChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
        updatePasswordChildVc?.view.isHidden = true
        updatePasswordChildVc?.txtOldPasswordonUpdatePassword.attributedPlaceholder = NSAttributedString(string: "OLD PASSWORD",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])

        updatePasswordChildVc?.txtPasswordonUpdatePassword.attributedPlaceholder = NSAttributedString(string: "PASSWORD",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
               updatePasswordChildVc?.loadUI()
        self.view.addSubview(updatePasswordChildVc!.view)
    }
    
    
    @objc func beginLocationChanges()
    {
         if menuChildVc?.view.isHidden == false
         {
             self.menuChildVc?.view.isHidden = true
         }
        self.downTheMenuIfNeeded()
    }
    
    
    
    func successFullSignupOpenStep()
    {
        print("came in delegate")
        createAccountStepChildVc?.view.isHidden  = false
    }
    
    //SIGN UP CHILD ADDED
        func addCreateAccountStepScreenChild()
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            createAccountStepChildVc   = (storyboard.instantiateViewController(withIdentifier: "CreateAccountStepOneViewController") as! CreateAccountStepOneViewController)
            createAccountStepChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            createAccountStepChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
            createAccountStepChildVc?.view.isHidden = true
            
            createAccountStepChildVc?.txtSpeciality.attributedPlaceholder = NSAttributedString(string: "SPECIALITY",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
            
            
            
            createAccountStepChildVc?.txtDay.attributedPlaceholder = NSAttributedString(string: "DAY",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
            
            
             createAccountStepChildVc?.txtFavAlcohol.attributedPlaceholder = NSAttributedString(string: "FAVOURITE ALCOHOL",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
            
             createAccountStepChildVc?.txtPurchaseAlcohol.attributedPlaceholder = NSAttributedString(string: "DO YOU PURCHASE ALCOHOL?",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
      
            
            self.view.addSubview(createAccountStepChildVc!.view)
            
            createAccountStepChildVc?.btnCrossCreateAccount.addTarget(self, action: #selector(crossButtonClickedOnSignUpScreen(_:)), for: .touchUpInside)
    
            createAccountStepChildVc?.createUIonCreateAccount()
            
            createAccountStepChildVc?.shadowView.backgroundColor = UIColor.black .withAlphaComponent(0.5)
            createAccountStepChildVc?.shadowView.layer.cornerRadius = 15.0
            createAccountStepChildVc?.shadowView.clipsToBounds = true
            
            
            createAccountStepChildVc?.collectionViewUserTypeOnSignUpScreen.register(UINib.init(nibName: "UserTypeSignUpCell", bundle: nil), forCellWithReuseIdentifier: "UserTypeSignUpCell")
            
        }
    
  
    
    
    //SIGN UP CHILD ADDED
    func addSignUpViewChild()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        signupChildVc   = (storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController)
        signupChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        signupChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
        signupChildVc?.view.isHidden = true
        
        signupChildVc?.delegate = self
        let stringprivacy = "By creating an account, you agree to our\nTerms of Service and have read and understood\nthe Privacy Policy"
        
        signupChildVc?.cityTableView.register(UINib.init(nibName: "CityCell", bundle: nil), forCellReuseIdentifier:"CityCell")

        
        
        let Appcolor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)
        
        let myMutableString = NSMutableAttributedString(string: stringprivacy, attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size: 12.0)!])
       
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:Appcolor, range: NSRange(location:41,length:16))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:Appcolor, range: NSRange(location:90,length:15))
        
        // set label Attribute
        signupChildVc?.lblPrivacyPolicy.attributedText = myMutableString
        
        signupChildVc?.txtName.attributedPlaceholder = NSAttributedString(string: "NAME",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
         signupChildVc?.txtEmail.attributedPlaceholder = NSAttributedString(string: "EMAIL",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
         signupChildVc?.txtPassword.attributedPlaceholder = NSAttributedString(string: "PASSWORD",                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
    
    signupChildVc?.txtUserName.attributedPlaceholder = NSAttributedString(string: "USER NAME",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
        
        //NEW WORK FROM HERE
    signupChildVc?.txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "PHONE NUMBER",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
//        signupChildVc?.txtWorkingat.attributedPlaceholder = NSAttributedString(string: "WORKING AS",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
//         signupChildVc?.txtBarName.attributedPlaceholder = NSAttributedString(string: "BAR NAME",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
          signupChildVc?.txtCountry.attributedPlaceholder = NSAttributedString(string: "COUNTRY",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
         signupChildVc?.txtState.attributedPlaceholder = NSAttributedString(string: "STATE",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
            signupChildVc?.txtCity.attributedPlaceholder = NSAttributedString(string: "CITY",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
        
        
//        till here
        
        self.view.addSubview(signupChildVc!.view)
        
        signupChildVc?.btnCrossSignUp.addTarget(self, action: #selector(crossButtonClickedOnSignUpScreen(_:)), for: .touchUpInside)
        
        signupChildVc?.btnTerms.addTarget(self, action: #selector(termsandConditionsButtonClicked(_:)), for: .touchUpInside)
        
        signupChildVc?.btnPrivacy.addTarget(self, action: #selector(privacyButtonClicked(_:)), for: .touchUpInside)
                
        signupChildVc?.btnLogin.addTarget(self, action: #selector(openLoginScreen(_:)), for: .touchUpInside)
        
        signupChildVc?.btnAlreadyRegistered.addTarget(self, action: #selector(openLoginScreen(_:)), for: .touchUpInside)
        
        signupChildVc?.createPickerforWorkingAt()
        
        signupChildVc?.shadowView.backgroundColor = UIColor.black .withAlphaComponent(0.5)
        signupChildVc?.shadowView.layer.cornerRadius = 15.0
        signupChildVc?.shadowView.clipsToBounds = true
        
    }
    
   
    @objc func openLoginScreen(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.hideSignUpScreen()
        self.loginChildVc?.view.isHidden = false
//        loginChildVc
    }
    
    func hideSignUpScreen()
       {
        signupChildVc?.cityArray.removeAllObjects()
        signupChildVc?.filteredCityArray.removeAllObjects()
        signupChildVc?.txtCity.text = ""
        signupChildVc?.citySelectionSuperView.isHidden = true
        
            signupChildVc?.selectedUserTypeIndex = -1
            self.view.endEditing(true)
            signupChildVc?.txtName.text = ""
            signupChildVc?.txtEmail.text = ""
            signupChildVc?.txtPassword.text = ""
            signupChildVc?.txtPhoneNumber.text = ""
            signupChildVc?.txtUserName.text = ""

        signupChildVc?.txtCountry.text = ""
        signupChildVc?.txtState.text = ""
        signupChildVc?.txtCity.text = ""
        signupChildVc?.view.isHidden = true
        signupChildVc?.selectedStateIndex = 0
        signupChildVc?.selectedUserTypeIndex = 0
        signupChildVc?.selectedfavSpiritIndex = 0
        signupChildVc?.selectedCountryIndex = 0
        
       }
    
    @objc func crossButtonClickedOnSignUpScreen(_ sender: UIButton)
       {
        self.view.endEditing(true)
        self.hideSignUpScreen()
       }
       

    //add login child
    func addLoginViewChild()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginChildVc   = (storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController)
        loginChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        loginChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
        loginChildVc?.view.isHidden = true
         loginChildVc?.txtEmail.attributedPlaceholder = NSAttributedString(string: "EMAIL",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
        
        loginChildVc?.txtPassword.attributedPlaceholder = NSAttributedString(string: "PASSWORD",                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 67/255.0, green: 68/255.0, blue: 69/255.0, alpha: 1.0)])
                
        self.view.addSubview(loginChildVc!.view)
        
    loginChildVc?.btnCrossLogin.addTarget(self, action: #selector(crossButtonClickedOnLoginScreen(_:)), for: .touchUpInside)
        
    loginChildVc?.btnForgotPassword.addTarget(self, action: #selector(forgotPasswordButtonClickedonLoginScreen(_:)), for: .touchUpInside)
        loginChildVc?.btnBackOnLoginScreen.addTarget(self, action: #selector(backButtonClickedFromLoginScreen(_:)), for: .touchUpInside)


        
        loginChildVc?.shadowView.backgroundColor = UIColor.black .withAlphaComponent(0.5)
        loginChildVc?.shadowView.layer.cornerRadius = 15.0
        loginChildVc?.shadowView.clipsToBounds = true
    }
    
    @objc func backButtonClickedFromLoginScreen(_ sender: UIButton)
    {
        loginChildVc?.view.isHidden = true
        loginChildVc?.txtEmail.text = ""
        loginChildVc?.txtPassword.text = ""
        signupChildVc?.view.isHidden = false
    }
    
    @objc func forgotPasswordButtonClickedonLoginScreen(_ sender: UIButton)
    {
    self.loginChildVc?.view.isHidden = true
        
    self.view.endEditing(true)
    forgotPasswordChildVc?.txtEmailonForgotPassword.text = ""
        
        forgotPasswordChildVc?.lblTitleForgotPassword.text = "Forgot Password"
        forgotPasswordChildVc?.btnsubmitForgotPassword.setTitle("SUBMIT", for: .normal)
        
    forgotPasswordChildVc?.view.isHidden = false
    forgotPasswordChildVc?.loadUI()
    }
    
    @objc func crossButtonClickedOnLoginScreen(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.hideLoginScreen()
    }
    
    @objc func tapLoginSuperViewToDisMiss(gesture:UITapGestureRecognizer)
       {
        if menuChildVc?.view.isHidden == false
        {
            self.menuChildVc?.view.isHidden = true
        }
        self.hideLoginScreen()
       }
    
    func hideLoginScreen()
    {
        self.view.endEditing(true)
        loginChildVc?.txtEmail.text = ""
        loginChildVc?.txtPassword.text = ""
        loginChildVc?.view.isHidden = true
    }
    
    
    //add login child
    func addProfileViewChild()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileChildVc   = (storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController)
                
        profileChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        profileChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
        
        profileChildVc?.view.isHidden = true
        
        self.view.addSubview(profileChildVc!.view)
    profileChildVc?.btnonmainProfileViewSuperView.addTarget(self, action: #selector(crossButtonClickedOnProfileScreen(_:)), for: .touchUpInside)
        
        profileChildVc?.btnCrossProfile.addTarget(self, action: #selector(crossButtonClickedOnProfileScreen(_:)), for: .touchUpInside)
        
        profileChildVc?.btnFollowingFollowerOnProfileScreen.addTarget(self, action: #selector(showFollowScreenFromMenu(_:)), for: .touchUpInside)
    profileChildVc?.collectionViewProfileImages.register(UINib.init(nibName: "CocktailImagesCell", bundle: nil), forCellWithReuseIdentifier: "CocktailImagesCell")
        
        profileChildVc?.btnEditProfile.addTarget(self, action: #selector(editProfileClickedfromBothOptions(_:)), for: .touchUpInside)
        
        profileChildVc?.btnMessages.addTarget(self, action: #selector(messageButtonClickedfromSomeOtherProfile(_:)), for: .touchUpInside)
        
    }
    
    @objc func messageButtonClickedfromSomeOtherProfile(_ sender: UIButton)
    {
        editmessageChildVc?.view.isHidden = false
        editmessageChildVc?.selectedPeopleObj = profileChildVc?.selectedPeopleObj
        editmessageChildVc?.isCreatingNewMessage = false
        editmessageChildVc?.loadUI()
            }
    
    
    
    //OPEN EDIT PROFILE SCREEN FROM PROFILE SCREEN AN HOME SCREEN MENU ALSO
    @objc func editProfileClickedfromBothOptions(_ sender: UIButton)
    {
        self.view.endEditing(true)
        //IN CASE BOTTOM SHEET IS OPEN : FIRST IT SHOULD BE CLOSED
            if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))!
            {
                
            if timerforChangingAddImages != nil
            {
                timerforChangingAddImages?.invalidate()
                timerforChangingAddImages = nil
            }
            timerforChangingAddImages?.invalidate()
        self.childVc?.collectionViewBarsandStores.isHidden = true
            self.childVc?.collectionViewForAds.isHidden = true

                childVc!.view.backgroundColor = UIColor.clear
                
                self.childVc?.imgArrow.image = UIImage.init(named: "up")
                
                UIView.animate(withDuration: 0.4) {
                    self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
//                print("down image selected")
                }
                self.childVc?.btnDismissHeightConstraint.constant = 0
                
            }
                
        if profileChildVc?.view.isHidden == false{
           profileChildVc?.view.isHidden = true
        }
        
        if menuChildVc?.view.isHidden == false{
            menuChildVc?.view.isHidden = true
        }
        editprofileChildVc?.isAnythingChanged = false
        //UNHIDE EDIT PROFILE VIEW
    editprofileChildVc?.view.isHidden = false
    editprofileChildVc?.setUpEditProfileDetails()
//        print("SHOW EDIT PROFILE")
    }

    
    
    @objc func crossButtonClickedOnProfileScreen(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.hideProfileScreen()
        self.getMyProfileandUpdateData()
    }
    
    func hideProfileScreen ()
    {
    self.view.endEditing(true)
    profileChildVc?.view.isHidden = true
    menuChildVc?.view.isHidden = true
    

    }
    
//    MARK :-//open edit profile from both screens from home and from profile screen too
    
    //add login child
    func addEditProfileViewChild()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        editprofileChildVc   = (storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController)
        

        editprofileChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        editprofileChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
        
        editprofileChildVc?.view.isHidden = true
        
        self.view.addSubview(editprofileChildVc!.view)
    editprofileChildVc?.btnonmainEditProfileViewSuperView.addTarget(self, action: #selector(crossButtonClickedOnEditProfileScreen(_:)), for: .touchUpInside)
    editprofileChildVc?.btnFollowerFollowingonEditProfile.addTarget(self, action: #selector(showFollowScreenFromMenu(_:)), for: .touchUpInside)
        
        editprofileChildVc?.btnCrossEditProfile.addTarget(self, action: #selector(crossButtonClickedOnEditProfileScreen(_:)), for: .touchUpInside)
        
        editprofileChildVc?.btnUpdatePassword.addTarget(self, action: #selector(updatePasswordClickedfromEditProfileScreen(_:)), for: .touchUpInside)
        editprofileChildVc?.cityTableView.register(UINib.init(nibName: "CityCell", bundle: nil), forCellReuseIdentifier:"CityCell")

      
    }
    
    @objc func updatePasswordClickedfromEditProfileScreen(_ sender: UIButton)
    {
        updatePasswordChildVc?.loadUI()
        updatePasswordChildVc!.view.isHidden = false
    updatePasswordChildVc?.txtPasswordonUpdatePassword.text = ""
    }

    @objc func crossButtonClickedOnEditProfileScreen(_ sender: UIButton)
      {
        self.view.endEditing(true)
          self.hideEditProfileScreen()
        self.getMyProfileandUpdateData()
      }
    
    func hideEditProfileScreen()
    {
        self.view.endEditing(true)
        editprofileChildVc?.view.isHidden = true
        
        editprofileChildVc?.cityArray.removeAllObjects()
             editprofileChildVc?.filteredCityArray.removeAllObjects()
             editprofileChildVc?.txtCity.text = ""
             editprofileChildVc?.citySelectionSuperView.isHidden = true
    }
    
        //add FOLLOWERS CHILD
        func addFollowViewChild()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            followChildVc   = (storyboard.instantiateViewController(withIdentifier: "FollowersFollowingViewController") as! FollowersFollowingViewController)
            
            followChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
            followChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
            
            followChildVc?.view.isHidden = true
            
            followChildVc!.tblFollowers.delegate = self
            followChildVc!.tblFollowing.delegate = self
            self.view.addSubview(followChildVc!.view)
        followChildVc?.btnforFollowerFollowingSuperView.addTarget(self, action: #selector(crossButtonClickedOnFollowScreen(_:)), for: .touchUpInside)
            
        followChildVc?.tblFollowing.register(UINib.init(nibName: "FollwingCell", bundle: nil), forCellReuseIdentifier:"FollwingCell")
            
        followChildVc?.tblFollowers.register(UINib.init(nibName: "FollwersCell", bundle: nil), forCellReuseIdentifier:"FollwersCell")
        followChildVc!.tblFollowers.delegate = self
            followChildVc!.tblFollowing.delegate = self

        followChildVc?.btnCrossOnFollowScreen.addTarget(self, action: #selector(crossButtonClickedOnFollowScreen(_:)), for: .touchUpInside)

        }
    
    @objc func crossButtonClickedOnFollowScreen(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.hideFollowScreen()
    }
    
    func hideFollowScreen(){
        self.view.endEditing(true)
        followChildVc?.view.isHidden = true
    }
    
            //add FOLLOWERS CHILD
            func addFeedbackViewChild()
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                feedbackChildVc   = (storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController)
                
                feedbackChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                feedbackChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
                
                feedbackChildVc?.view.isHidden = true
                
                self.view.addSubview(feedbackChildVc!.view)
                
            feedbackChildVc?.btnCrossFeedback.addTarget(self, action: #selector(crossButtonClickedOnFeedbackScreen(_:)), for: .touchUpInside)

            }
        
        @objc func crossButtonClickedOnFeedbackScreen(_ sender: UIButton)
        {
            self.view.endEditing(true)
            self.hideFeedbackScreen()
        }
        
        func hideFeedbackScreen()
        {
            self.view.endEditing(true)
            feedbackChildVc?.view.isHidden = true
        }

    
        //add FOLLOWERS CHILD
        func addMessagesHistoryViewChild()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            messageHistoryChildVc   = (storyboard.instantiateViewController(withIdentifier: "MessagesHistoryViewController") as! MessagesHistoryViewController)
            messageHistoryChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            messageHistoryChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
            messageHistoryChildVc?.view.isHidden = true
            
        self.view.addSubview(messageHistoryChildVc!.view)
        messageHistoryChildVc?.btnCrossOnMesaagesHistoryScreen.addTarget(self, action: #selector(crossButtonClickedOnMessagesHistoryScreen(_:)), for: .touchUpInside)
             
            messageHistoryChildVc?.tblMessagesHistory.register(UINib.init(nibName: "MessageHistoryCell", bundle: nil), forCellReuseIdentifier: "MessageHistoryCell")
            
    messageHistoryChildVc!.tblMessagesHistory.dataSource = messageHistoryChildVc!
            
    messageHistoryChildVc!.tblMessagesHistory.delegate = self
    messageHistoryChildVc!.btnEditOnMessageHistory.addTarget(self, action: #selector(editMessageClicked(_:)), for: .touchUpInside)
            
            
            
        }
    
    
    
    
    @objc func editMessageClicked
        (_ sender: UIButton)
    {
        self.view.endEditing(true)
//        print("Came in edit message option")
        editmessageChildVc?.view.isHidden = false
        editmessageChildVc?.isCreatingNewMessage = true
        
    editmessageChildVc!.txtSearchEditMessagesUsers.text = ""
    editmessageChildVc!.txtMessageonEditMessage.text = ""
        
        
//    
        
        editmessageChildVc?.loadUI()
//    editmessageChildVc?.txtMessageonEditMessage.becomeFirstResponder()
    }
    
    
    
    
    
    @objc func crossButtonClickedOnMessagesHistoryScreen
        (_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.hideMessagesHistoryScreen()
    }
    
    func hideMessagesHistoryScreen()
    {
        self.view.endEditing(true)
        messageHistoryChildVc?.view.isHidden = true
    }
    
//
    func addEditMessagesViewChild()
           {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               editmessageChildVc   = (storyboard.instantiateViewController(withIdentifier: "EditMessageViewController") as! EditMessageViewController)
            
               editmessageChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
               editmessageChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
               editmessageChildVc?.view.isHidden = true
               
           self.view.addSubview(editmessageChildVc!.view)
          
        editmessageChildVc?.btnCrossOnEditMesaagesScreen.addTarget(self, action: #selector(crossButtonClickedOnEditMessagesScreen(_:)), for: .touchUpInside)
            
            //BACK ACTION PERFORMED HERE
        editmessageChildVc?.btnBackArrow.addTarget(self, action: #selector(crossButtonClickedOnEditMessagesScreen(_:)), for: .touchUpInside)
            
           //search people table view delegate datasource to its own class
           
                //user follower cell for showing last history with last message
            editmessageChildVc?.tblUsersOnEditMessage.register(UINib.init(nibName: "GetPeopleCell", bundle: nil), forCellReuseIdentifier: "GetPeopleCell")
           
           //MESSAGES CELL IS FOR DISPLAYING MESSAGES
            editmessageChildVc?.tblUsersOnEditMessage.register(UINib.init(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
            
            editmessageChildVc?.tblUsersOnEditMessage.register(UINib.init(nibName: "MessageImageCell", bundle: nil), forCellReuseIdentifier: "MessageImageCell")
            
            editmessageChildVc?.tblUsersOnEditMessage.dataSource = editmessageChildVc
            editmessageChildVc?.tblUsersOnEditMessage.delegate = editmessageChildVc
   editmessageChildVc?.tblUsersOnEditMessage.layer.borderColor = UIColor.init(red: 218/255.0, green: 219/255.0, blue: 214/255.0, alpha: 1.0).cgColor
            editmessageChildVc?.tblUsersOnEditMessage.layer.borderWidth = 2.0
            editmessageChildVc?.tblUsersOnEditMessage.clipsToBounds = true
            NotificationCenter.default.addObserver(editmessageChildVc!, selector: #selector(EditMessageViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           }
       
      
       @objc func crossButtonClickedOnEditMessagesScreen
           (_ sender: UIButton)
       {
           self.view.endEditing(true)
           self.hideEditMessagesScreen()
            if savedataInstance.getUserDetails() != nil
               {
                   if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
                   {
                       self.peopleFilterButtonAction((self.childVc?.btnPeople)!)
                   }
               }
       }
       
       func hideEditMessagesScreen()
       {
           self.view.endEditing(true)
           editmessageChildVc?.view.isHidden = true
       }
    
    
    func addTermsandConditionsChild()
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                termsOfUseChildVc   = (storyboard.instantiateViewController(withIdentifier: "TermsandConditionsViewController") as! TermsandConditionsViewController)
             
                termsOfUseChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
             
                termsOfUseChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
                termsOfUseChildVc?.view.isHidden = true
                
            self.view.addSubview(termsOfUseChildVc!.view)
            }
        
    

     func addNotificationViewChild()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        notificationChildVc   = (storyboard.instantiateViewController(withIdentifier: "NotificationsListViewController") as! NotificationsListViewController)
              
        notificationChildVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
              
        notificationChildVc?.view.backgroundColor = UIColor.black .withAlphaComponent(0.4)
                 notificationChildVc?.view.isHidden = true
                 
        self.view.addSubview(notificationChildVc!.view)
        
        notificationChildVc?.btnCrossOnNotificationScreen.addTarget(self, action: #selector(crossButtonClickedOnNotificationsList(_:)), for: .touchUpInside)
    notificationChildVc?.tblNotifications.register(UINib.init(nibName: "NotificationRequestCell", bundle: nil), forCellReuseIdentifier: "NotificationRequestCell")
        
      }
    
    @objc func crossButtonClickedOnNotificationsList
           (_ sender: UIButton)
       {
        self.view.endEditing(true)
        notificationChildVc?.view.isHidden = true
       }
    
    
    //MARK :- CREATE AND REMOVE CIRCLES
    func createCircles()
    {
        if currentLocationMarker?.map != nil{
            currentLocationMarker?.map = nil
        }
        if currentLocationCircle?.map != nil{
            currentLocationCircle?.map = nil
        }

        
        if appdelegate.selectedLatitude! != 0.0
        {
            currentLocationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude:   appdelegate.selectedLatitude!, longitude:    appdelegate.selectedLongitude!))
        }
        else
        {
        currentLocationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: RandomObjects.getLatitude(), longitude:  RandomObjects.getLongitude()))
        }
        
        currentLocationMarker!.title = "My Location"
        currentLocationMarker!.icon = UIImage.init(named: "redCircle")
        currentLocationMarker!.map = googleMap
        
        //current location Circle
        let circleCenter : CLLocationCoordinate2D?
        if   appdelegate.selectedLatitude! != 0.0
        {
            circleCenter = CLLocationCoordinate2D(latitude:   appdelegate.selectedLatitude!, longitude:   appdelegate.selectedLongitude!)
        }
        else
        {
            circleCenter = CLLocationCoordinate2D(latitude: RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude())
        }
        
        
        var radius = (googleMap.camera.zoom * 1000) / 4.1
        
        if googleMap.camera.zoom <= 8
        {
            radius = 72223.82208
        }
        else if googleMap.camera.zoom <= 9
        {
            radius = 36111.911040
        }
        else if googleMap.camera.zoom <= 10
        {
            radius = 18055.955520
        }
       else if googleMap.camera.zoom <= 11
        {
            radius =  9027.977761
        }
        
       else  if googleMap.camera.zoom <= 12
        {
//            radius = 3000 PREVIOUSLY
            print("radius is now 4513.988880 12 zoom")
            radius = 4513.988880
        }
            
        else if googleMap.camera.zoom <= 13
        {
            print("radius is now 2500 13 zoom")
            radius = 2256.994440
        }
        else if googleMap.camera.zoom <= 14{
            radius = 1128.497220
            print("radius is now 2000 14 zoom")

        }
        else if googleMap.camera.zoom <= 15
        {
            radius = 564.24861
            print("radius is now 1500 15 zoom")
        }
        else if googleMap.camera.zoom <= 16
        {
            radius = 282.124305
            print("radius is now 250 16 zoom")

        }
        else if googleMap.camera.zoom <= 17
        {
        radius = 150
        print("radius is now 125 17 zoom")

        }
        else if googleMap.camera.zoom <= 18
        {
        radius = 75
        print("radius is now 250 18 zoom")
        }
        else
        {
        print("radius is now 175 unknown zoom")
        radius = 35
        }

        currentLocationCircle = GMSCircle.init(position: circleCenter!, radius: CLLocationDistance(radius))

        
        let fillColor = UIColor.init(red: 76/255.0, green: 178/255, blue: 179/255, alpha: 0.35)
        let strokeColor = UIColor.init(red: 159/255.0, green: 205/255, blue: 195/255, alpha: 0.8)
        currentLocationCircle!.fillColor = fillColor
        currentLocationCircle!.strokeColor = strokeColor
        currentLocationCircle!.strokeWidth = 5
        currentLocationCircle!.map = googleMap
    }
            
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("zoom in out is \(mapView.camera.zoom)")
    }
    
    
    @objc func swipedRight(gesture: UISwipeGestureRecognizer) {
        //NEXT
        self.view.endEditing(true)
        print("came in PREVIOUS gestures IF EXISTS")

            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            if (selectedBar ) == 0
            {
                print("its last index")
            }
            else
            {
                selectedBar = selectedBar - 1
            self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousBarSelected, section: 0)])
            self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedBar, section: 0)])
                
                previousBarSelected = selectedBar
                
            self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedBar, section: 0), at: .centeredHorizontally, animated: true)
                
                self.getBarsDetailsApi(index: selectedBar, isSearchEnabled: false)
                
                print("its  not last index")
            }
        }
        if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
               {
          if (selectedStore ) == 0
          {
              print("its last index")
          }
          else
          {
                             
        selectedStore = selectedStore - 1
    self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousStoreSelected, section: 0)])
    self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedStore, section: 0)])
                       
        previousStoreSelected = selectedStore
    self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedStore, section: 0), at: .centeredHorizontally, animated: true)
                      
        self.getStoresDetailsApi(index: selectedStore, isSearchEnabled: false)
        print("its  not last index")
                   }
               }
                        
    }
    
    @objc func swipedLeft(gesture: UISwipeGestureRecognizer) {
        //PREVIOUS
        print("came in next gestures")
        self.view.endEditing(true)
        if (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
        if (selectedBar + 1) == barListArray.count
        {
           print("its last index")
        }
        else{
                   
            selectedBar = selectedBar + 1
        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousBarSelected, section: 0)])
        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedBar, section: 0)])
                   
            previousBarSelected = selectedBar
        self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedBar, section: 0), at: .centeredHorizontally, animated: true)

            self.getBarsDetailsApi(index: selectedBar, isSearchEnabled: false)
            print("its  not last index")

        }
        }
       else if (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
        if (selectedStore + 1) == storeListArray.count{
                   print("its last index")
        }
        else{
                   
            selectedStore = selectedStore + 1
        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousStoreSelected, section: 0)])
        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedStore, section: 0)])
                   
            previousStoreSelected = selectedStore
        self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedStore, section: 0), at: .centeredHorizontally, animated: true)

            self.getStoresDetailsApi(index: selectedStore, isSearchEnabled: false)
            print("its  not last index")

        }
        }
    }
    
    //HIMANSHU
    @objc func pangestureClicked(gesture: UIPanGestureRecognizer) {
        self.view.endEditing(true)
        let target = gesture.view
        
        print(" and came inside tag is \(target!.tag)")
        print(" and came inside tag is \(target!.backgroundColor == UIColor.clear)")

        switch gesture.state {
        case .began:
            btnCenter = target?.center
            print("ended began")
        case .ended :
        if target?.tag == 786 {
        self.arrowButtonClicked(self.childVc!.btnArrow)
        }
        print("ended state")
        case .changed:
            print("ended changed")
        return
        default: break
        }
      }


    func upTheMenuIfNeeded()
    {
        if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))! == false
           {
                self.childVc?.btnDismissHeightConstraint.constant = 100

                
                childVc?.imgArrow.image = UIImage.init(named: "down")
                
                UIView.animate(withDuration: 0.4) {
                    self.childVc?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height )
                }
                self.childVc?.collectionViewBarsandStores.isHidden = false
                self.childVc?.collectionViewForAds.isHidden = false
                
                self.startTimerforChangingImages()
            
            UIView.animate(withDuration: 0.4)
            {
            self.childVc!.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            }
            

                print("up image selected")
            }
    }

    //FORCEFULLY PERFORM DOWN THE MENU : due to ui issue on landscape : BOTTOM BAR WAS NOT SHOWING
        func downTheMenuForcefully()
        {
            
                
                if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                    if searchEnabled == false && storeListArray.count == 0
                    {
                        if timerforChangingAddImages != nil
                        {
                        timerforChangingAddImages?.invalidate()
                        timerforChangingAddImages = nil
                        }
                        childVc?.emptyStateImgView.isHidden = false

                        if timerforChangingAddImages != nil
                        {
                        timerforChangingAddImages?.invalidate()
                                   timerforChangingAddImages = nil
                        }

                    }
                    else
                    {
                        childVc?.emptyStateImgView.isHidden = true

                    }
                }
                else if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                if barListArray.count == 0
                {
            //        self.show
                    print("Array is empty and returned")
                    if timerforChangingAddImages != nil{
                               timerforChangingAddImages?.invalidate()
                               timerforChangingAddImages = nil
                           }
                    childVc?.emptyStateImgView.isHidden = false
            //        return
                }
                }
            
            
  
        self.childVc?.collectionViewBarsandStores.isHidden = true

        childVc!.view.backgroundColor = UIColor.clear

            self.childVc?.imgArrow.image = UIImage.init(named: "up")
                    
                    
            if childVc?.collectionViewFilters.isHidden == false
                {
            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                        UIView.animate(withDuration: 0.4) {
                        self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 90), width: self.view.frame.size.width, height: self.view.frame.size.height)
                            print("down image selected")
                            }
           }
            else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                            
                UIView.animate(withDuration: 0.4) {
                self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 34), width: self.view.frame.size.width, height: self.view.frame.size.height)
                                print("down image selected")
            }
            }
            else
           {
            UIView.animate(withDuration: 0.4)
            {
            self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
            print("down image selected")
            }
            }
                    }
                     else
                     {
                    
            UIView.animate(withDuration: 0.4) {
                self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    print("down image selected")
                    }
                    }
                    
                    
                    
            self.childVc?.btnDismissHeightConstraint.constant = 0
                    
                    if timerforChangingAddImages != nil
                    {
                    timerforChangingAddImages?.invalidate()
                    timerforChangingAddImages = nil
                    }
                    timerforChangingAddImages?.invalidate()
                    


        }
    
    
    
    func downTheMenuIfNeeded()
    {
        //here for closing menu due to pin drop animation
            if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))!
            {
                self.childVc?.btnDismissHeightConstraint.constant = 0

    self.childVc?.collectionViewBarsandStores.isHidden = true

    childVc!.view.backgroundColor = UIColor.clear

        self.childVc?.imgArrow.image = UIImage.init(named: "up")
                
                
        if childVc?.collectionViewFilters.isHidden == false
            {
        if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
                    UIView.animate(withDuration: 0.4) {
                    self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 90), width: self.view.frame.size.width, height: self.view.frame.size.height)
                        print("down image selected")
                        }
       }
        else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
                        
            UIView.animate(withDuration: 0.4) {
            self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 34), width: self.view.frame.size.width, height: self.view.frame.size.height)
                            print("down image selected")
        }
        }
        else
       {
        UIView.animate(withDuration: 0.4)
        {
        self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
        print("down image selected")
        }
        }
                }
                 else
                 {
                
            UIView.animate(withDuration: 0.4) {
            self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
                print("down image selected")
                }
                }
                if timerforChangingAddImages != nil
                {
                timerforChangingAddImages?.invalidate()
                timerforChangingAddImages = nil
                }
                timerforChangingAddImages?.invalidate()
            }
            UIView.animate(withDuration: 0.2) {
              self.view.layoutIfNeeded()
            }
    }
    
    
   
    
    
    //DELIVERY FILTER ACTION
        @objc func deliveryFilterAction(_ sender: UIButton)
        {
           if childVc?.searchView.isHidden == false
               {
                   childVc?.searchView.isHidden = true
               }
            self.view.endEditing(true)
            //till here close menu coz to show pin drop animation
            self.downTheMenuIfNeeded()
            print("delivery BUTTON CLICKED")
            if  appdelegate.selectedLatitude! != 0.0
            {
            self.getStoresApi(store_latitude: "\(appdelegate.selectedLatitude!)", store_longitude: "\(appdelegate.selectedLongitude!)")
            }
            else
            {
            self.getStoresApi(store_latitude: "\(RandomObjects.getLatitude())", store_longitude: "\(RandomObjects.getLongitude())")
            }
        }
    
    //DELIVERY FILTER ACTION
    @objc func testingFilterAction(_ sender: UIButton)
    {
        if childVc?.searchView.isHidden == false
        {
               childVc?.searchView.isHidden = true
        }
        self.view.endEditing(true)
        //till here close menu coz to show pin drop animation
        self.downTheMenuIfNeeded()
        print("delivery BUTTON CLICKED")
        
    if  appdelegate.selectedLatitude! != 0.0
        {
        self.getStoresApi(store_latitude: "\(appdelegate.selectedLatitude!)", store_longitude: "\(appdelegate.selectedLongitude!)")
        }
        else
        {
        self.getStoresApi(store_latitude: "\(RandomObjects.getLatitude())", store_longitude: "\(RandomObjects.getLongitude())")
        }
    }
                
    
    
    @objc func setUpUberRideforBarDetails(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
       if   (UIApplication.shared.canOpenURL(NSURL(string:"uber://")! as URL))
        {
                
        let uberUrlStr = NSString.init(format: "uber://?action=setPickup&dropoff[latitude]=%@&setPickup&dropoff[longitude]=%@", "\(barListArray[sender.tag].bar_latitude ?? "")","\(barListArray[sender.tag].bar_longitude ?? "")")
                   
                   // if your app is available it open the app
        UIApplication.shared.openURL(URL.init(string: uberUrlStr as String)!)
                
        }
        else
        {
        UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/us/app/uber/id368677368")!)
        }
               
    }
    
    
    @objc func setUpUberRideforStoreDetails(_ sender: UIButton)
    {
        
        if   (UIApplication.shared.canOpenURL(NSURL(string:"uber://")! as URL))
        {
            
            let uberUrlStr = NSString.init(format: "uber://?action=setPickup&dropoff[latitude]=%@&setPickup&dropoff[longitude]=%@", "\(storeListArray[sender.tag].store_latitude ?? "")","\(storeListArray[sender.tag].store_longitude ?? "")")
            
            
            // if your app is available it open the app
            UIApplication.shared.openURL(URL.init(string: uberUrlStr as String)!)
        }
        else
        {
            UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/us/app/uber/id368677368")!)
        }
        
    }
//

    
   @objc func getDirections(_ sender: UIButton) {
//    selectedBar
   self.view.endEditing(true)
    //STATIC LOCATION K SAATH KAR DIYA HAI >
    
    let directionURL : NSString?
    
    if appdelegate.selectedLongitude! != 0.0
    {
        directionURL = NSString.init(format: "http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",appdelegate.selectedLatitude!,appdelegate.selectedLongitude!,Double(barListArray[selectedBar].bar_latitude as! String)! , Double(barListArray[selectedBar].bar_longitude as! String)!)

    }
    else
    {
     directionURL = NSString.init(format: "http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",RandomObjects.getLatitude(),RandomObjects.getLongitude(),Double(barListArray[selectedBar].bar_latitude as! String)! , Double(barListArray[selectedBar].bar_longitude as! String)!)
    }
    
    if UIApplication.shared.canOpenURL(URL.init(string: directionURL as! String)!){
        UIApplication.shared.openURL(URL.init(string: directionURL as! String)!)
    }
    else{
        
    }
    }

    func startTimerforChangingImages()
    {
        if timerforChangingAddImages != nil{
            timerforChangingAddImages?.invalidate()
            timerforChangingAddImages = nil
        }
        timerforChangingAddImages = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: #selector(changeImageOneByOne), userInfo: nil, repeats: true)

//        timerforChangingAddImages = Timer.schedule
    }
    
   @objc func changeImageOneByOne(){
    
    if imgIndexforChanging == 0{
    imgIndexforChanging = imgIndexforChanging + 1
    }
    else if (imgIndexforChanging + 1) == addsImagesArray.count{
        imgIndexforChanging = 0
    }
    else{
        imgIndexforChanging = imgIndexforChanging + 1
    }
    
    self.childVc?.collectionViewForAds.scrollToItem(at: IndexPath.init(item: imgIndexforChanging, section: 0), at: .centeredHorizontally, animated: true)
    
    }
    
    
    func hideAllFilterView()
    {
//        UIView.animate(withDuration: 0.4)
//        {
            
            UIView.animate(withDuration: Double(0.5), animations: {
            self.childVc?.collectionViewFiltersHeightConstraint.constant = 0.0
            self.childVc?.collectionViewFilters.reloadData()

            self.view.layoutIfNeeded()
            })
        self.childVc?.collectionViewFilters.isHidden = true

//        }
    }
    
    
    
    @objc func allFiltersButtonClicked(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.4) {
                   
         if  (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                SVProgressHUD.showError(withStatus: "No Filters for People")
            }
         else  if self.childVc?.collectionViewFilters.isHidden == false
         {
            self.hideAllFilterView()
            
    if (self.childVc?.imgArrow.image?.isEqual(UIImage.init(named: "up")))!
            {
                self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
                        
         }
         else
         {
        UIView.animate(withDuration: 0.4)
        {
            
    self.childVc?.collectionViewFilters.reloadData()
            
    self.childVc?.collectionViewFilters.isHidden = false
            
        if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
        self.childVc?.collectionViewFiltersHeightConstraint.constant = 90.0
                
        if (self.childVc?.imgArrow.image?.isEqual(UIImage.init(named: "up")))!
        {
        self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 90), width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
                
//           self.upTheMenuIfNeeded()
           }
        else if  (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
        self.childVc?.collectionViewFiltersHeightConstraint.constant = 34.0
            
            if (self.childVc?.imgArrow.image?.isEqual(UIImage.init(named: "up")))!
            {
        self.childVc?.view.frame = CGRect.init(x: 0, y: self.view.frame.size.height - (130 + 34), width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
                
//            self.upTheMenuIfNeeded()

            }
        else if  (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                SVProgressHUD.showError(withStatus: "No Filters for People")
            }
            
        }
        }
            
        }//ANIMATIONS
    }
    
    
    
    //MARK:- ADD CHILD FOR BAR UI AND ALL
  @objc  func arrowButtonClicked(_ sender: UIButton)
  {
    
    UIView.animate(withDuration: 0.6) {
        
    
    print("Called arrowButtonClicked")
    self.view.endEditing(true)
    self.view.endEditing(true)
    
    if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
    {
        if self.searchEnabled == false && self.storeListArray.count == 0
        {
            if self.timerforChangingAddImages != nil
            {
                self.timerforChangingAddImages?.invalidate()
                self.timerforChangingAddImages = nil
            }
            self.childVc?.emptyStateImgView.isHidden = false

            if self.timerforChangingAddImages != nil
            {
                self.timerforChangingAddImages?.invalidate()
                self.timerforChangingAddImages = nil
            }

        }
        else
        {
            self.childVc?.emptyStateImgView.isHidden = true

        }
    }
    else if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
    {
        if self.barListArray.count == 0
    {
//        self.show
        print("Array is empty and returned")
        if self.timerforChangingAddImages != nil{
            self.timerforChangingAddImages?.invalidate()
            self.timerforChangingAddImages = nil
               }
        self.childVc?.emptyStateImgView.isHidden = false
//        return
    }
    }
    
    
        if (self.childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))!
    {
        self.downTheMenuIfNeeded()
    }
    else
    {
        self.upTheMenuIfNeeded()
    }
    
    UIView.animate(withDuration: 0.2) {
        self.view.layoutIfNeeded()
    }
    }
    //checking for aNIMATON
    }
    
    var orientations:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation

    
    override func viewDidAppear(_ animated: Bool) {
        
        self.addChildforUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc  func orientationChanged (notification: NSNotification)
    {
//        [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:") withObject:(id)UIInterfaceOrientationLandscapeRight]
        
        adjustViewsForOrientation(orientation: UIApplication.shared.statusBarOrientation)
    }
    func adjustViewsForOrientation(orientation: UIInterfaceOrientation) {
        if (orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown)
        {
            if(orientation != orientations) {
                print("Portrait")
                //Do Rotation stuff here
                orientations = orientation
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIApplication.shared.setStatusBarOrientation(orientation, animated: true)
                
                
                print("self view frame after changing orientation to protrait\(self.googleMap.frame)")
                
                if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))! == false
                {
                self.downTheMenuForcefully()
                }
                
            }
        }
        else if (orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight)
        {
           if(orientation != orientations) {
            print("Landscape")
            print("self view frame after changing orientation to landscape\(self.googleMap.frame)")
                //Do Rotation stuff here
                orientations = orientation
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIApplication.shared.setStatusBarOrientation(orientation, animated: true)
            
            
            if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))! == false
                {
                          self.downTheMenuForcefully()
//                    self.view.layoutIfNeeded()

                }
            
            }
        }
    }
    
        //MARK:-  getBarsApi
    func getStoresApi(store_latitude : String , store_longitude: String)
        {
            var delivry : String = ""
            var tastings : String = ""
          
            if selectedStoreFilterArray.contains("DELIVERY")
            {
                  delivry = "delivry"
            }
            else if  selectedStoreFilterArray.contains("TASTING")
            {
                tastings = "tastings"
            }
            
            let params = NSMutableDictionary()
            params.setValue(store_latitude, forKey: "store_latitude")
            params.setValue(store_longitude, forKey: "store_longitude")
            
            params.setValue(delivry, forKey: "delivry")
            params.setValue(tastings, forKey: "tastings")

           print("params for get STORES api \(params)")
            
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                break
                // Show alert if internet not available.
                //show alert
            default:
                SVProgressHUD.show(withStatus: "Loading Stores...")
                ApiManager.sharedManager.delegate=self

//                hb
//            self.childVc?.view.isUserInteractionEnabled = false
            ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.getStoresApi as NSString,currentView: self.view)
            }
        }
    
            //MARK:-  getBarsApi
        func getStoresDetailsApi(index: Int, isSearchEnabled:Bool)
        {
            searchEnabled = isSearchEnabled
            let params = NSMutableDictionary()
            if isSearchEnabled == false
            {
            params.setValue(storeListArray[index].id, forKey: "store_id")
            params.setValue(storeListArray[index].distance, forKey: "miles")
            }
            else
            {            params.setValue(childVc?.searchStoreListArray[index].id, forKey: "store_id")
            params.setValue(childVc?.searchStoreListArray[index].distance, forKey: "miles")
                
                params.setValue("", forKey: "dollar")
            }
            
            if savedataInstance.getUserDetails() != nil
            {
                params.setValue(savedataInstance.id, forKey: "user_id")
            }

            print("params for get bars api \(params)")
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                     break
                    // Show alert if internet not available.
                    //show alert
                default:
                    SVProgressHUD.show(withStatus: "Loading Store details")

                    ApiManager.sharedManager.delegate=self
                print("get STORES detail api params ARE +\(params)+")
                print("get STORES detail API url +\(Constant.getStoressDetailsApi)+")
            ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.getStoressDetailsApi as NSString,currentView: self.view)
                }
            }
    
    @objc func followUnfollowActiononGetPeople(_ sender: UIButton)
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
    
    
        //MARK:-  getBarsApi
        func getPeopleAPI(latitude : String , longitude: String)
        {
          
            let params = NSMutableDictionary()
            self.savedataInstance.getUserDetails()
            
//            print(savedataInstance.getUserDetails())
            params.setValue(latitude, forKey: "latitude")
            params.setValue(longitude, forKey: "longitude")
            params.setValue(savedataInstance.id, forKey: "user_id")

           print("params for get PEOPLE api \(params)")
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
                SVProgressHUD.show(withStatus: "Loading People...")
            ApiManager.sharedManager.delegate=self
//                hb
//                self.childVc?.view.isUserInteractionEnabled = false
            ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.GETPEOPLEAPI as NSString,currentView: self.view)
            }
        }
    
    
    //MARK:-  getBarsApi
    func getBarsApi(barLatiTude : String , bar_longitude: String)
    {
        
//        ["$","$$","$$$","SPECIALS","DRINKSONLY","RESTAURANT","THEMEBAR","NIGHTCLUB","EVENTS","PATIO"]
        
        
        var drink_special : String = ""
        var events : String = ""
        var drinks_only : String = ""
        var night_club : String = ""
        var theme_bar : String = ""
        var restaurant : String = ""
        var patio : String = ""
        
        if selectedBarFilterArray.contains("SPECIALS")
        {
            drink_special = "drink_special"
        }
        if selectedBarFilterArray.contains("DRINKSONLY")
        {
            drinks_only = "drinks_only"
        }
        if selectedBarFilterArray.contains("RESTAURANT")
        {
            restaurant = "restaurant"
        }
        if selectedBarFilterArray.contains("THEMEBAR")
        {
            theme_bar = "theme_bar"
        }
        if selectedBarFilterArray.contains("NIGHTCLUB")
        {
            night_club = "night_club"
        }
        if selectedBarFilterArray.contains("EVENTS")
        {
            events = "events"
        }
        if selectedBarFilterArray.contains("PATIO")
        {
            patio = "patio"
        }
        
        
        let params = NSMutableDictionary()
        params.setValue(barLatiTude, forKey: "bar_latitude")
        params.setValue(bar_longitude, forKey: "bar_longitude")
        params.setValue(drink_special, forKey: "drink_special")
        params.setValue(events, forKey: "events")
        params.setValue(drinks_only, forKey: "drinks_only")
        params.setValue(night_club, forKey: "night_club")
        params.setValue(theme_bar, forKey: "theme_bar")
        params.setValue(restaurant, forKey: "restaurant")
        params.setValue(patio, forKey: "patio")

       print("params for get bars api \(params)")
        
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
            SVProgressHUD.show(withStatus: "Loading Bars ...")
         
//            hb
//            self.childVc?.view.isUserInteractionEnabled = false

            ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.getBarsApi as NSString,currentView: self.view)
        }
    }
    
        //MARK:-  getBarsApi
    func getBarsDetailsApi(index: Int, isSearchEnabled:Bool)
    {
        
        searchEnabled = isSearchEnabled
        let params = NSMutableDictionary()
        
        if isSearchEnabled == false
        {
//            params.setValue(1758, forKey: "bar_id")

        params.setValue(barListArray[index].id, forKey: "bar_id")
        params.setValue(barListArray[index].distance, forKey: "miles")
        params.setValue(barListArray[index].dollars, forKey: "dollar")
        }
        else
        {

        params.setValue(childVc?.searchBarListArray[index].id, forKey: "bar_id")
        params.setValue(childVc?.searchBarListArray[index].distance, forKey: "miles")
        params.setValue("", forKey: "dollar")
        }
        
        if savedataInstance.getUserDetails() != nil
        {
            params.setValue(savedataInstance.id, forKey: "user_id")
        }
//        print("params for get bars api \(params)")
               
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                 break
                // Show alert if internet not available.
                //show alert
            default:
                SVProgressHUD.show(withStatus: "Loading Bar Details...")

                ApiManager.sharedManager.delegate = self
               
//               print("get detail api params+\(params)+")
                
//                print("get detail url +\(Constant.getBarsDetailsApi)+")
                ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.getBarsDetailsApi as NSString,currentView: self.view)
            }
        }
    
    
    func filterBarsArrayAccordingtoDollars(listArray : NSArray)
    {
        
        if self.barListArray.count > 0
        {
            self.barListArray.removeAll()
        }
        
        if  (listArray[0] is String) == true
        {
            
        }
        else{
    for i in 0..<listArray.count
        {
            
        var dict = NSDictionary()
        dict = listArray[i] as! NSDictionary
//        print("dict is \(dict)")
            
        let dollar = dict["dollars"] as! Int
        var dollarStr = ""
            
        if dollar == 1
        {
        dollarStr = "$"
        }
        else if dollar == 2
        {
        dollarStr = "$$"
        }
        else if dollar == 3{
        dollarStr = "$$$"
        }
            
            
        let barObject = BarsList.init(
                           bar_city: dict["bar_city"], dollars: dict["dollars"],
                           bar_country: dict["bar_country"],
                           bar_image: dict["bar_image"],
                           bar_latitude: dict["bar_latitude"],
                           bar_longitude: dict["bar_longitude"],
                           bar_name: dict["bar_name"],
                           bar_state: dict["bar_state"],
                           bar_status: dict["bar_status"], bar_street_address: dict["bar_street_address"],
                           bar_zipcode: dict["bar_zipcode"],
                           busiest_day: dict["busiest_day"], current_date_time: dict["current_date_time"], current_usa_date_time: dict["current_usa_date_time"],
                           distance: dict["distance"],
                           events_detail: dict["events_detail"],
                           events_dollar: dict["events_dollar"],
                           features: dict["features"],
                           id: dict["id"],
                           order: dict["order"],
                           product_types: dict["product_types"], special_drink_price: dict["special_drink_price"],
                           today_event: dict["today_event"],
                           user_id: dict["user_id"],
                           vibes: dict["bar_marker"], bar_marker: dict["bar_marker"])
            
            
            if dollarStr == ""
            {
                //will be added
                self.barListArray.append(barObject)
            }
            else if selectedBarFilterArray.contains(dollarStr)
            {
                //will be added
                self.barListArray.append(barObject)
            }
            else if selectedBarFilterArray.contains("$") == false &&  selectedBarFilterArray.contains("$$") == false &&  selectedBarFilterArray.contains("$$$") == false
            {
                self.barListArray.append(barObject)
            }
            else
            {
                
            }
                
            }
            
        }
        if self.barListArray.count > 0
        {
                  self.selectedBar = 0
                  self.previousBarSelected = 0
                  self.childVc?.emptyStateImgView.isHidden = true
          self.childVc?.collectionViewBarsandStores.reloadData()
              self.getBarsDetailsApi(index: 0, isSearchEnabled: false)
              self.drawMarkeronMap()

              }
              else
              {
                  
                  self.childVc?.emptyStateImgView.isHidden = false
                  if self.barDetailsObj != nil
                  {
                      self.barDetailsObj = nil
                  }
                  self.selectedBar = 0
                  self.previousBarSelected = 0
                  self.childVc?.collectionViewBarsandStores.reloadData()
                  self.childVc?.tableBarDetails.reloadData()
                  
                  SVProgressHUD.showError(withStatus: "No Data Found")
                self.drawMarkeronMap()
                      }
        
    }
    
    
    
    
    func getMyProfileandUpdateData()
        {
            let params = NSMutableDictionary()
            params.setValue(savedataInstance.id!, forKey: "user_id")
            print("params for otheruserprofile api \(params)")
                 
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Please check your internet connection.")
                     break
                     // Show alert if internet not available.
                     //show alert
                 default:
                    
                ApiManager.sharedManager.delegate = self
//                SVProgressHUD.show(withStatus: "Fetching Profile data...")
            ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.GETOTHERUSERPROFILEAPI as NSString,currentView: self.view)
                 }
             }
    
    
        //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
    {
        //only for receiving notification
        
//        COZ PROTOCOL ONLY WORK FOR LAST SET UP DELEGATE > THATS WHY I HAVE CALLED FUNCTION FROM HERE > FOR NOTIFICATIONS
        if serviceurl as String == Constant.GETALLNOTIFICATIONSAPI
        {
        notificationChildVc?.serverReponse(responseData: responseData, serviceurl: serviceurl)
        return
        }
        //TILL HERE FOR RECEIVIING NOTIFICATIONS :
        
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            do {
        if serviceurl as String == Constant.getBarsApi
        {
            
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                    
            
        let barsArray = jsonDictionary.value(forKey: "data") as! NSArray
                
                if self.tempBarsArray.count > 0
                {
            self.tempBarsArray.removeAllObjects()
                }
                
                
        if self.barListArray.count > 0
        {
            self.barListArray.removeAll()
        }
                
        if barsArray.count > 0
        {
            self.tempBarsArray.addObjects(from: jsonDictionary.value(forKey: "data") as! [Any])
            
            if  (barsArray[0] is String) == true
            {
                SVProgressHUD.showError(withStatus: "No Bars Found in this area")
            self.childVc?.emptyStateImgView.isHidden = false
            if self.barDetailsObj != nil
            {
                self.barDetailsObj = nil
            }
            self.selectedBar = 0
            self.previousBarSelected = 0
                
            self.drawMarkeronMap()
        self.childVc?.collectionViewBarsandStores.reloadData()
//                self.btnLoadMore.isHidden = true

                // hb 2 mar
                           
            return
            }
                    
        self.filterBarsArrayAccordingtoDollars(listArray: barsArray)
                }
                else
                {
                    
        self.childVc?.emptyStateImgView.isHidden = false
        if self.barDetailsObj != nil
        {
                self.barDetailsObj = nil
        }
                    
                    
        self.selectedBar = 0
        self.previousBarSelected = 0
        self.childVc?.collectionViewBarsandStores.reloadData()
        self.childVc?.tableBarDetails.reloadData()
        SVProgressHUD.showError(withStatus: "No Bars Found.")
                    
                }
                
        
        }
        else
        {
     self.childVc?.emptyStateImgView.isHidden = false
            //hb
//    self.childVc?.view.isUserInteractionEnabled = true
    RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                
        }
        }
        else if serviceurl as String == Constant.getBarsDetailsApi
        {
        let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: []) as! NSDictionary
            self.imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage = 0
            
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                let dict = jsonDictionary["data"] as! NSDictionary
                
                if self.barDetailsObj != nil{
                    self.barDetailsObj = nil
                }
                
                self.barDetailsObj = BarsDetails.init(
                    bar_website: dict["bar_website"],
                    bar_follow: dict["bar_follow"],
                    bar_team: dict["bar_team"],
                    bar_desc: dict["bar_desc"],
                    bar_gallery: dict["bar_gallery"],
                    bar_image: dict["bar_image"], bar_latitude: dict["bar_latitude"], bar_longitude: dict["bar_longitude"],
                    bar_name: dict["bar_name"],
                    bar_street_address: dict["bar_street_address"], bar_timing: dict["bar_timing"],
                    bar_tags: dict["bar_tags"],
                    dollar: dict["dollar"],
                    features: dict["features"],
                    id: dict["id"],
                    miles: dict["miles"],
                    other_tags: dict["other_tags"],
                    user_id: dict["user_id"], todayEvent: dict["todayEvent"], comingEvents: dict["comingEvents"], owner_phone: dict["owner_phone"])

                self.childVc?.collectionViewBarsandStoresHeightConstraint.constant = 140.0
                    self.childVc?.searchView.isHidden = true
//                }
                
                 DispatchQueue.main.async {
                    self.childVc?.tableBarDetails.reloadData()
                    self.childVc?.tableBarDetails.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                }
                
                
            }
            else
            {       RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                //show alert in this case and show message
            }

            }
//            +
            else   if serviceurl as String == Constant.getStoresApi
            {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
                {
                        
           let storesArray = jsonDictionary.value(forKey: "data") as! NSArray
                                                             
            if self.storeListArray.count > 0
            {
                self.storeListArray.removeAll()
            }
           
            for i in 0..<storesArray.count
            {
            if storesArray[i] is String
            {
                SVProgressHUD.showError(withStatus: "No Stores Found in this area")
                self.childVc?.emptyStateImgView.isHidden = false
            if self.storeDetailsObj != nil
            {
            self.storeDetailsObj = nil
                }
            self.selectedStore = 0
            self.previousStoreSelected = 0
            self.drawMarkeronMap()
            self.childVc?.collectionViewBarsandStores.reloadData()
            self.childVc?.tableBarDetails.reloadData()
                
//            self.btnLoadMore.isHidden = true

            return
            }
                
            var dict = NSDictionary()
                
                
            dict = storesArray[i] as! NSDictionary
                        
            let storeObject = StoreList.init(
                Store_ends: dict["Store_ends"],
                Store_opens: dict["Store_opens"],
                all_null: dict["all_null"],
                current_usa_date_time: dict["current_usa_date_time"],
                delilvery: dict["delilvery"],
                distance: dict["distance"],
                events_description: dict["events_description"],
                events_detail: dict["events_detail"],
                id: dict["id"],
                mj_products: dict["mj_products"],
                order: dict["order"],
                store_city: dict["store_city"],
                store_country: dict["store_country"],
                store_desc: dict["store_desc"],
                store_image: dict["store_image"],
                store_latitude: dict["store_latitude"],
                store_longitude: dict["store_longitude"],
                store_marker: dict["store_marker"],
                store_name: dict["store_name"],
                store_products: dict["store_products"],
                store_state: dict["store_state"],
                store_status: dict["store_status"],
                store_street_address: dict["store_street_address"],
                store_zipcode: dict["store_zipcode"],
                user_id: dict["user_id"])
                                
                self.storeListArray.append(storeObject)
                
                    }
                        
        if self.storeListArray.count > 0
        {
    self.selectedStore = 0
    self.previousStoreSelected = 0
    self.childVc?.emptyStateImgView.isHidden = true

    self.childVc?.collectionViewBarsandStores.reloadData()
    self.getStoresDetailsApi(index: 0, isSearchEnabled: false)
        self.drawMarkeronMap()
        }
        else
        {
            self.childVc?.emptyStateImgView.isHidden = false
            self.drawMarkeronMap()

            if self.storeDetailsObj != nil
            {
                self.storeDetailsObj = nil
            }
            self.selectedStore = 0
            self.previousStoreSelected = 0
        self.childVc?.collectionViewBarsandStores.reloadData()

//            hb
//            self.childVc?.view.isUserInteractionEnabled = true
            self.childVc?.tableBarDetails.reloadData()
        //SHOW ALERT FOR NO DATA FOUNDFOR BARS FOR THIS LOCATION
        SVProgressHUD.showError(withStatus: "No Stores Found in this area")
        }
        }
        else
        {
            self.childVc?.emptyStateImgView.isHidden = false
            if self.storeDetailsObj != nil
            {
                self.storeDetailsObj = nil
            }
            self.selectedStore = 0
            self.previousStoreSelected = 0
            self.drawMarkeronMap()
        self.childVc?.collectionViewBarsandStores.reloadData()
            self.childVc?.tableBarDetails.reloadData()
        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                            
        }

                
                
        }
         else if serviceurl as String == Constant.getStoressDetailsApi
         {
         let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: []) as! NSDictionary
            self.imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage = 0
            self.imgesChildVcForbarandStore!.view.isHidden = true
//         print("JSON RESPONSE for GET STORES DETAILS API = \(jsonDictionary)")
             
             if (jsonDictionary.value(forKey: "status") as! Bool) == true
             {
                 let dict = jsonDictionary["data"] as! NSDictionary
                 if self.storeDetailsObj != nil
                 {
                     self.storeDetailsObj = nil
                 }
                print("srore detail response \(jsonDictionary)")
                self.storeDetailsObj = StoreDetails.init(
                    owner_phone: dict["owner_phone"],
                    store_follow:  dict["store_follow"],
                    store_team: dict["store_team"],
                    comingEvents: dict["comingEvents"],
                    delivery_charges: dict["delivery_charges"],
                    delivery_comment: dict["delivery_comment"],
                    features: dict["features"],
                    id: dict["id"],
                    miles: dict["miles"],
                    store_desc: dict["store_desc"],
                    store_gallery: dict["store_gallery"],
                    store_image: dict["store_image"],
                    store_latitude: dict["store_latitude"],
                    store_longitude: dict["store_longitude"],
                    store_name: dict["store_name"],
                    store_street_address: dict["store_street_address"],
                    store_timing: dict["store_timing"],
                    todayEvent: dict["todayEvent"],
                    user_id: dict["user_id"],
                    store_website: dict["store_website"])
                
                //hb now 3 mar

                self.childVc?.collectionViewBarsandStoresHeightConstraint.constant = 140.0
                    self.childVc?.searchView.isHidden = true

                
        DispatchQueue.main.async
        {
        self.childVc?.tableBarDetails.reloadData()
        self.childVc?.tableBarDetails.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
                
        }
        else
        {      RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                 //show alert in this case and show message
        }
        }
        else   if serviceurl as String == Constant.GETPEOPLEAPI
        {
            if self.peopleArray.count > 0
            {
            self.peopleArray.removeAll()
            }
            
        let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
     
        if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                                    
        let peopleArr = (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "data") as? NSArray
                                            
        for i in 0..<peopleArr!.count
        {
        var dict = NSDictionary()
            dict = peopleArr![i] as! NSDictionary
       
            
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
            
//            print("device token is available \(dict["device_token"])")
            if "\(dict["user_id"]!)" != "\(self.savedataInstance.id!)"
            {
                let peopleObj = PeopleList.init(
                    user_blocked_by:  dict["user_blocked_by"],
                    user_blocked_id:  dict["user_blocked_id"],
                    block_id: dict["block_id"],
                    user_1: dict["user_1"],
                    user_2: dict["user_2"],
                    device_token: dict["device_token"],
                    initiate_id: dict["initiate_id"],
                    address: dict["address"],
                    city: dict["city"],
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
            else
            {
//                print("device token is not available \(dict["device_token"])")
            }
            }
                
            if self.peopleArray.count == 0
            {
                SVProgressHUD.showError(withStatus: "No People found.")
                self.childVc?.emptyStateImgView.isHidden = false
                
                
            }
            else
            {
                self.childVc?.emptyStateImgView.isHidden = true
                
                
            }

                
                
            self.childVc?.tblPeople.reloadData()
                
            self.drawMarkeronMap()
//                hb
//            self.childVc?.view.isUserInteractionEnabled = true

        }
        else
        {
            //                hb
//            self.childVc?.view.isUserInteractionEnabled = true
        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
            
            self.childVc?.emptyStateImgView.isHidden = false

        }
        }
       else if serviceurl as String == Constant.updateVisibilityApi
       {
       let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                         
//       print("JSON RESPONSE for VISIBILITY API = \(jsonDictionary)")
        if (jsonDictionary.value(forKey: "status") as! Bool) == true
        {
            
            
            if (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "message") is NSArray
            {
//                print("is array")
                  SVProgressHUD.showSuccess(withStatus: (((jsonDictionary["data"] as! NSDictionary).value(forKey: "message") as! NSArray).object(at: 0) as! String))
            }
            else if (jsonDictionary.value(forKey: "data") as? NSDictionary)?.value(forKey: "message") is String
            {
                SVProgressHUD.showSuccess(withStatus: ((jsonDictionary["data"] as! NSDictionary).value(forKey: "message") as! String))
//                print("is isString")
            }
            
            var userDetailDict = NSMutableDictionary()
            userDetailDict = self.savedataInstance.getUserDetails()?.mutableCopy() as! NSMutableDictionary
            
//            print("user details dict is \(userDetailDict)")
            
            if self.visibilityValue == 1
                {
                self.menuChildVc?.imgVisibilityOnMenu.image = UIImage.init(named: "NEWON")
                    
                userDetailDict.setValue(1, forKey: "visibility_status")
                }
            else
                {
                self.menuChildVc?.imgVisibilityOnMenu.image = UIImage.init(named: "NEWOFF")
                    
                    userDetailDict.setValue(0, forKey: "visibility_status")
                }
            
        self.savedataInstance.saveUserDetails(userdataDict: userDetailDict)
            
                    
        }
        else
        {
        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )

        print("error in visibility api")
        }

        }
        else   if serviceurl as String == Constant.REQUESTTOFOLLOWAPI
        {
        let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        print("jsondictionary for api :\(Constant.REQUESTTOFOLLOWAPI) and response is \(jsonDictionary)")
                     
            
            
        if (jsonDictionary.value(forKey: "status") as! Bool) == true
        {
            self.getMyProfileandUpdateData()
            
//            self.profileChildVc?.getMyProfileandUpdateData()
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "success")
            
            if self.appdelegate.selectedLatitude! != 0.0
            {
                self.getPeopleAPI(latitude:"\(self.appdelegate.selectedLatitude!)", longitude: "\(self.appdelegate.selectedLongitude!)")
            }
            else
            {
                self.getPeopleAPI(latitude: "\(RandomObjects.getLatitude())", longitude: "\(RandomObjects.getLongitude())")
            }
  //        self.childVc?.tblPeople.reloadData()
          }
          else
       {
           SVProgressHUD.dismiss()
       RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
       }
                                   
        }
            
        else   if serviceurl as String == Constant.followUnFollowApi
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
            print("jsondictionary for api :\(Constant.followUnFollowApi) and response is \(jsonDictionary)")
                             
                if (jsonDictionary.value(forKey: "status") as! Bool) == true
                     {

                      SVProgressHUD.dismiss()
                        
                    self.getMyProfileandUpdateData()

                      SVProgressHUD.showSuccess(withStatus: "User followed successfully")
                        
                        if self.appdelegate.selectedLatitude! != 0.0
                        {
                    self.getPeopleAPI(latitude:"\(self.appdelegate.selectedLatitude!)", longitude: "\(self.appdelegate.selectedLongitude!)")

                        }
                        else
                        {
                        self.getPeopleAPI(latitude: "\(RandomObjects.getLatitude())", longitude: "\(RandomObjects.getLongitude())")
                        }
          
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
                            
                        self.getMyProfileandUpdateData()

//                          SVProgressHUD.showSuccess(withStatus: "Success!")
                            
                            if self.appdelegate.selectedLatitude! != 0.0
                            {
                        self.getPeopleAPI(latitude:"\(self.appdelegate.selectedLatitude!)", longitude: "\(self.appdelegate.selectedLongitude!)")

                            }
                            else
                            {
                            self.getPeopleAPI(latitude: "\(RandomObjects.getLatitude())", longitude: "\(RandomObjects.getLongitude())")
                            }
              
                         }
                         else
                         {
                             SVProgressHUD.dismiss()
                         RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                         }
                        }
       else   if serviceurl as String == Constant.LOGOUTAPI
       {
       let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
           
       print("jsondictionary for api :\(Constant.LOGOUTAPI) and response is \(jsonDictionary)")
                         
      if (jsonDictionary.value(forKey: "status") as! Bool) == true
      {
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //        UI
//        UIApplication.shared.remote
       SVProgressHUD.dismiss()
       SVProgressHUD.showSuccess(withStatus: "Logout successfully")
        RandomObjects.logOutNow()
        self.OnLogutEmptyTheFields()
        self.menuChildVc?.view.isHidden = true
        
        if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
        {            self.barsFilterButtonAction(self.childVc!.btnBars)
        }
        
        if self.profileChildVc?.view.isHidden == false
        {
            self.profileChildVc?.view.isHidden = false
        }
        if self.notificationChildVc?.view.isHidden == false
        {
            self.notificationChildVc?.view.isHidden = false
        }
        if self.messageHistoryChildVc?.view.isHidden == false
        {
            self.messageHistoryChildVc?.view.isHidden = false
        }
        
        self.downTheMenuIfNeeded()
      
      }
      else
      {
        SVProgressHUD.dismiss()
    RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
        }
                                         
          }
                
        else   if serviceurl as String == Constant.FORGOTPASSWORDAPI
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
            print("JSON RESPONSE for forgot password  API = \(jsonDictionary)")
            
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                
            SVProgressHUD.showSuccess(withStatus: "You can update your password.")
        self.forgotPasswordChildVc?.txtEmailonForgotPassword.text = ""
                
            self.forgotPasswordChildVc?.view.isHidden = true
                
            self.updatePasswordForgotChildVc?.user_id = (jsonDictionary["data"] as! NSDictionary)["user_id"]
            self.updatePasswordForgotChildVc?.view.isHidden = false
                
            }
            else
            {
        RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
                

            }
        }
        else if serviceurl as String == Constant.GETOTHERUSERPROFILEAPI
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                                                                
            print("JSON RESPONSE for GET OTHER USER PROFILE API = \(jsonDictionary)")
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                         
            if jsonDictionary.value(forKey: "data") != nil
            {
            self.setSaveDataDetails(jsonDictionary: jsonDictionary)
            }
            }
            else
            {
//            RandomObjects.showErrorNow(jsonDictionary:jsonDictionary)
                print("profile error :\(jsonDictionary)")

            print("error in GETOTHERUSERPROFILEAPI api and not shown alert in this case")
            }
            }
        else   if serviceurl as String == Constant.followUnFollowBarApi
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            print("jsondictionary for api :\(Constant.followUnFollowApi) and response is \(jsonDictionary)")
            
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Bar followed successfully.")
                
                self.getBarsDetailsApi(index: self.selectedBar, isSearchEnabled: false)
//                self.getStoresDetailsApi(index: self.selectedStore, isSearchEnabled: false)
                
            }
            else
            {
                SVProgressHUD.dismiss()
                RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
            }
        }
            
                //
        else   if serviceurl as String == Constant.followUnFollowStoreApi
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            print("jsondictionary for api :\(Constant.followUnFollowApi) and response is \(jsonDictionary)")
            
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Store followed successfully.")

                self.getStoresDetailsApi(index: self.selectedStore, isSearchEnabled: false)
                
            }
            else
            {
                SVProgressHUD.dismiss()
                RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
            }
                }
                
        else   if serviceurl as String == Constant.followUnFollowStoreTeamApi
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            print("jsondictionary for api :\(Constant.followUnFollowApi) and response is \(jsonDictionary)")
            
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Followed successfully.")

                self.getStoresDetailsApi(index: self.selectedStore, isSearchEnabled: false)
                
                
                
            }
            else
            {
                SVProgressHUD.dismiss()
                RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
            }
                }
            
        else   if serviceurl as String == Constant.followUnFollowBarTeamApi
        {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            print("jsondictionary for api :\(Constant.followUnFollowApi) and response is \(jsonDictionary)")
            
            if (jsonDictionary.value(forKey: "status") as! Bool) == true
            {
                
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Followed successfully.")
                
                self.getBarsDetailsApi(index: self.selectedBar, isSearchEnabled: false)
//                self.getStoresDetailsApi(index: self.selectedStore, isSearchEnabled: false)
                
                
                
            }
            else
            {
                SVProgressHUD.dismiss()
                RandomObjects.showErrorNow(jsonDictionary:jsonDictionary )
            }
                }
                
                //
        }catch let _error
        {
            print(_error)
        }
    }
    }
    
    
    
    
    func setSaveDataDetails(jsonDictionary: NSDictionary?)
    {
        self.savedataInstance.saveUserDetails(userdataDict: jsonDictionary!["data"] as! NSDictionary)
               
        print("came in save data details\(self.savedataInstance.getUserDetails())")
        
       if  self.savedataInstance.follow_by  != nil
        {
            menuChildVc?.lblFollowersCount.text = "\(self.savedataInstance.follow_by!)"
        }
                 
        if  self.savedataInstance.follow_to != nil
        {
        menuChildVc?.lblFollowingCount.text = "\(self.savedataInstance.follow_to!)"
        }
                        
    }
    
    
    func OnLogutEmptyTheFields()
    {
    loginChildVc?.txtEmail.text = ""
    loginChildVc?.txtPassword.text = ""
    forgotPasswordChildVc?.txtEmailonForgotPassword.text = ""
    updatePasswordChildVc?.txtPasswordonUpdatePassword.text = ""
    }
    
    
    func getdistancecheck() ->(Int)
    {
        var  minimumDistance : Double = 0.0
        
        let distanceArray = NSMutableArray()
        var locationatIndex : CLLocation?

        if (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {

        for i in 0..<barListArray.count {
            locationatIndex =  CLLocation(latitude: Double(self.barListArray[i].bar_latitude as! String)!, longitude: Double(self.barListArray[i].bar_longitude as! String)!)
            let currentLocation : CLLocation?
            if appdelegate.selectedLatitude! != 0.0
            {
                currentLocation = CLLocation(latitude: appdelegate.selectedLatitude!, longitude: appdelegate.selectedLongitude!)
            }
            else
            {
                currentLocation = CLLocation(latitude: RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude())
            }

            
            let distance : Double = (locationatIndex?.distance(from: currentLocation!))!
            
            if minimumDistance == 0.0
            {
            minimumDistance = distance
            }
           else if distance < minimumDistance
            {
            minimumDistance = distance
            }
            
            print("index is \(i) and distance is \(distance)")
            
            distanceArray.add(distance)
            
        }
        }
        
        else if (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {

            for i in 0..<storeListArray.count {
                locationatIndex =  CLLocation(latitude: Double(self.storeListArray[i].store_latitude as! String)!, longitude: Double(self.storeListArray[i].store_longitude as! String)!)
                let currentLocation : CLLocation?
                if appdelegate.selectedLatitude! != 0.0
                {
                    currentLocation = CLLocation(latitude: appdelegate.selectedLatitude!, longitude: appdelegate.selectedLongitude!)
                }
                else
                {
                    currentLocation = CLLocation(latitude: RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude())
                }

                
                let distance : Double = (locationatIndex?.distance(from: currentLocation!))!
                
                if minimumDistance == 0.0
                {
                minimumDistance = distance
                }
               else if distance < minimumDistance
                {
                minimumDistance = distance
                }
                
                print("index is \(i) and distance is \(distance)")
                
                distanceArray.add(distance)
                
            }
            
        }
        else if (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {

            for i in 0..<peopleArray.count {
                locationatIndex =  CLLocation(latitude: Double(self.peopleArray[i].user_latitude as! String)!, longitude: Double(self.peopleArray[i].user_longitude as! String)!)
                let currentLocation : CLLocation?
                if appdelegate.selectedLatitude! != 0.0
                {
                    currentLocation = CLLocation(latitude: appdelegate.selectedLatitude!, longitude: appdelegate.selectedLongitude!)
                }
                else
                {
                    currentLocation = CLLocation(latitude: RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude())
                }

                
                let distance : Double = (locationatIndex?.distance(from: currentLocation!))!
                
                if minimumDistance == 0.0
                {
                minimumDistance = distance
                }
               else if distance < minimumDistance
                {
                minimumDistance = distance
                }
                
                print("index is \(i) and distance is \(distance)")
                
                distanceArray.add(distance)
                
            }
        }
        
        print("minimum distance is \(minimumDistance)")
        print(distanceArray.index(of: minimumDistance))
        
        if distanceArray.count > 0
        {
            return distanceArray.index(of: minimumDistance)
        }
        else
        {
            return 0
        }
                    
    }
    
    //set zoom level
    func moveCameraAccordingly()
    {
        var distanceforCircle : CGFloat = 0.0
        var zoomLevel : CGFloat = 0.0
        
        if (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            let minimumDistanceIndex =  self.getdistancecheck()
            
            if barListArray.count > 0
            {
            
            var locationOnThirdIndex : CLLocation?

            locationOnThirdIndex =  CLLocation(latitude: Double(self.barListArray[minimumDistanceIndex].bar_latitude as! String)!, longitude: Double(self.barListArray[minimumDistanceIndex].bar_longitude as! String)!)
                
            let currentLocation : CLLocation?
            if appdelegate.selectedLatitude! != 0.0
            {
                currentLocation = CLLocation(latitude: appdelegate.selectedLatitude!, longitude: appdelegate.selectedLongitude!)
            }
            else
            {
                currentLocation = CLLocation(latitude: RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude())
            }
                
            let distance = locationOnThirdIndex?.distance(from: currentLocation!)
            
            if CGFloat(distance!) <= 150
            {
                zoomLevel = 17
            }
            else if CGFloat(distance!) <= 282.124305
            {
                    zoomLevel = 16
            }
            else if CGFloat(distance!) <= 564.24861
            {
                    zoomLevel = 15
            }
            else if CGFloat(distance!) <= 1128.497220
            {
                zoomLevel = 14
            }
            else if CGFloat(distance!) <= 2256.994440
            {
                zoomLevel = 13.0
            }
            else if CGFloat(distance!) <= 4513.988880
            {
                zoomLevel = 12.0
            }
            else if CGFloat(distance!) <= 9027.977761
            {
                zoomLevel = 11.0
            }
            else if CGFloat(distance!) <= 18055.955520
            {
                zoomLevel = 10.0
            }
            else if CGFloat(distance!) <= 36111.911040
            {
                zoomLevel = 9.0
            }
            else
            {
                zoomLevel = 8.0
            }
            
            print ("distance from current location is\(String(describing: distance))")
            print ("zoomLevel  is : \(zoomLevel)")

            }
            else
            {
                zoomLevel  = 12.0
            }
        }
        else if (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            let minimumDistanceIndex =  self.getdistancecheck()
            
            if storeListArray.count > 0
            {
            
            var locationOnThirdIndex : CLLocation?

            locationOnThirdIndex =  CLLocation(latitude: Double(self.storeListArray[minimumDistanceIndex].store_latitude as! String)!, longitude: Double(self.storeListArray[minimumDistanceIndex].store_longitude as! String)!)
                
            let currentLocation : CLLocation?
            if appdelegate.selectedLatitude! != 0.0
            {
                currentLocation = CLLocation(latitude: appdelegate.selectedLatitude!, longitude: appdelegate.selectedLongitude!)
            }
            else
            {
                currentLocation = CLLocation(latitude: RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude())
            }
            let distance = locationOnThirdIndex?.distance(from: currentLocation!)
                       
                       if CGFloat(distance!) <= 150
                       {
                           zoomLevel = 17
                       }
                       else if CGFloat(distance!) <= 282.124305
                       {
                               zoomLevel = 16
                       }
                       else if CGFloat(distance!) <= 564.24861
                       {
                               zoomLevel = 15
                       }
                       else if CGFloat(distance!) <= 1128.497220
                       {
                           zoomLevel = 14
                       }
                       else if CGFloat(distance!) <= 2256.994440
                       {
                           zoomLevel = 13.0
                       }
                       else if CGFloat(distance!) <= 4513.988880
                       {
                           zoomLevel = 12.0
                       }
                       else if CGFloat(distance!) <= 9027.977761
                       {
                           zoomLevel = 11.0
                       }
                       else if CGFloat(distance!) <= 18055.955520
                       {
                           zoomLevel = 10.0
                       }
                       else if CGFloat(distance!) <= 36111.911040
                       {
                           zoomLevel = 9.0
                       }
                       else
                       {
                           zoomLevel = 8.0
                       }
                       
                       print ("distance from current location is\(String(describing: distance))")
                       print ("zoomLevel  is : \(zoomLevel)")
//            print ("zoomLevel  is : \(zoomLevel)")

            }
            else
            {
                zoomLevel  = 12.0
            }
        }
        else if (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            let minimumDistanceIndex =  self.getdistancecheck()
            
            if peopleArray.count > 0
            {
            var locationOnThirdIndex : CLLocation?
            locationOnThirdIndex =  CLLocation(latitude: Double(self.peopleArray[minimumDistanceIndex].user_latitude as! String)!, longitude: Double(self.peopleArray[minimumDistanceIndex].user_longitude as! String)!)
                
            let currentLocation : CLLocation?
            if appdelegate.selectedLatitude! != 0.0
            {
                currentLocation = CLLocation(latitude: appdelegate.selectedLatitude!, longitude: appdelegate.selectedLongitude!)
            }
            else
            {
                currentLocation = CLLocation(latitude: RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude())
            }
           let distance = locationOnThirdIndex?.distance(from: currentLocation!)
                       
                       if CGFloat(distance!) <= 150
                       {
                           zoomLevel = 17
                       }
                       else if CGFloat(distance!) <= 282.124305
                       {
                               zoomLevel = 16
                       }
                       else if CGFloat(distance!) <= 564.24861
                       {
                               zoomLevel = 15
                       }
                       else if CGFloat(distance!) <= 1128.497220
                       {
                           zoomLevel = 14
                       }
                       else if CGFloat(distance!) <= 2256.994440
                       {
                           zoomLevel = 13.0
                       }
                       else if CGFloat(distance!) <= 4513.988880
                       {
                           zoomLevel = 12.0
                       }
                       else if CGFloat(distance!) <= 9027.977761
                       {
                           zoomLevel = 11.0
                       }
                       else if CGFloat(distance!) <= 18055.955520
                       {
                           zoomLevel = 10.0
                       }
                       else if CGFloat(distance!) <= 36111.911040
                       {
                           zoomLevel = 9.0
                       }
                       else
                       {
                           zoomLevel = 8.0
                       }
                       
                       print ("distance from current location is\(String(describing: distance))")
                       print ("zoomLevel  is : \(zoomLevel)")

            }
            else
            {
                zoomLevel  = 12.0
            }
        }
        
        

        
          if appdelegate.selectedLatitude! != 0.0
          {
            self.googleMap.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition.init(latitude:appdelegate.selectedLatitude!, longitude: appdelegate.selectedLongitude! , zoom: Float(zoomLevel))))
            
          }
          else
          {
            self.googleMap.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition.init(latitude:RandomObjects.getLatitude(), longitude: RandomObjects.getLongitude() , zoom: Float(zoomLevel))))
          }
        
    }
    
    
    
   func drawMarkeronMap()
   {
    indexforDropPin = 0
    self.googleMap.clear()
    self.moveCameraAccordingly()

    self.createCircles()
 
    timerforPinDropping?.invalidate()
    if timerforPinDropping != nil{
    timerforPinDropping = nil
    }
    
    if (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
    {
        
        if barListArray.count > 0
        {
            timerforPinDropping?.invalidate()
            if timerforPinDropping != nil{
            timerforPinDropping = nil
        }
             timerforPinDropping = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(dropPinOneByOne), userInfo: nil, repeats: true)
        }
    }
    if (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
    {
        if storeListArray.count > 0
        {
        timerforPinDropping?.invalidate()
        if timerforPinDropping != nil{
        timerforPinDropping = nil
        }
        timerforPinDropping = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(dropPinOneByOne), userInfo: nil, repeats: true)
        }
        
    }
    if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
    {
        
        if peopleArray.count > 0
        {
        timerforPinDropping?.invalidate()
        if timerforPinDropping != nil{
        timerforPinDropping = nil
            }
            timerforPinDropping = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(dropPinOneByOne), userInfo: nil, repeats: true)
        }
        
    }
    
    }
    
    
//    func setMapRegionAccordingly()
//    {
//
//        if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
//        {
//
//            if barListArray.count > 0 && barListArray.count > 1
//            {
//            var bounds = GMSCoordinateBounds()
//                for i in 0..<2
//            {
//                let latitude = Double(self.barListArray[self.indexforDropPin].bar_latitude as! String)!
//
//                let longitude = Double(self.barListArray[self.indexforDropPin].bar_longitude as! String)!
//
//                bounds = bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude))
////                includingCoordinate(marker.position)
//            }
//                let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
//
//                googleMap.animate(with: update)
//
//            }
//        }
//        else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
//        {
//
//            if storeListArray.count > 0 && storeListArray.count > 1
//            {
//            var bounds = GMSCoordinateBounds()
//            for i in 0..<2
//            {
//                let latitude = Double(self.storeListArray[self.indexforDropPin].store_latitude as! String)!
//
//                let longitude = Double(self.storeListArray[self.indexforDropPin].store_longitude as! String)!
//
//                bounds = bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude))
//            }
//            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
//
//            googleMap.animate(with: update)
//
//        }
//        }
//        else if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
//        {
//
//                if peopleArray.count > 0 && peopleArray.count > 1
//                {
//                var bounds = GMSCoordinateBounds()
//                for i in 0..<2
//                {
//                    let latitude = Double(self.peopleArray[self.indexforDropPin].user_latitude as! String)!
//
//                    let longitude = Double(self.peopleArray[self.indexforDropPin].user_longitude as! String)!
//
//                    bounds = bounds.includingCoordinate(CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude))
//                }
//                let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
//
//                googleMap.animate(with: update)
//
//            }
//
//
//        }
//        print("came in setMapRegionAccordingly func ")
//
//    }
    
    
    
    
    
    
    @objc func dropPinOneByOne(){
          
        if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {

        if indexforDropPin == barListArray.count
            {
                timerforPinDropping?.invalidate()
                timerforPinDropping = nil
                print("its last index for drop pin")

                return
            }
            else
            {
                
                self.setMarker(latitude: Double(self.barListArray[self.indexforDropPin].bar_latitude as! String)!, longitude: Double(self.barListArray[self.indexforDropPin].bar_longitude as! String)!)
            }
        }
       else if (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!

        {
            
        if indexforDropPin == storeListArray.count
            {
                
                timerforPinDropping?.invalidate()
                timerforPinDropping = nil

                print("its last index for drop pin")
                return
            }
            else
            {
               
            self.setMarker(latitude: Double(self.storeListArray[self.indexforDropPin].store_latitude as! String)!, longitude: Double(self.storeListArray[self.indexforDropPin].store_longitude as! String)!)
            }
        }
            else if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
        {

            if indexforDropPin == peopleArray.count
        {
            timerforPinDropping?.invalidate()
            timerforPinDropping = nil
            print("its last index for drop pin")

            return
        }
        else
        {
                        
        self.setMarker(latitude: Double(peopleArray[self.indexforDropPin].user_latitude as! String)!, longitude: Double(self.peopleArray[self.indexforDropPin].user_longitude as! String)!)
        }
    }
 
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        if let myMarker = marker as? MyGMSMarker
        {
            self.upTheMenuIfNeeded()
        print("my marker tag is \(myMarker.indexofMarker)")
    if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
        selectedBar = myMarker.indexofMarker
    self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousBarSelected, section: 0)])

    self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedBar, section: 0)])
    previousBarSelected = myMarker.indexofMarker
    self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedBar, section: 0), at: .centeredHorizontally, animated: true)
                //bar images collection view cell selection
               
            self.getBarsDetailsApi(index: myMarker.indexofMarker, isSearchEnabled: false)
               
            }
            if (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                                       
           selectedStore = myMarker.indexofMarker
           self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousStoreSelected, section: 0)])

       self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedStore, section: 0)])
                                       
         previousStoreSelected = myMarker.indexofMarker
                             
       self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedStore, section: 0), at: .centeredHorizontally, animated: true)
      
                                
                                //bar images collection view cell selection
        self.getStoresDetailsApi(index: selectedStore, isSearchEnabled: false)
                 }
        }

        return false
    }
    
    
    
//    func mapView(_ mapView: GMSMapView, didTap marker: MyGMSMarker) -> Bool {
//         print("HERE IS INDEX OF MZRKER \(marker.indexofMarker)")
//    }
    
//    private func mapView(mapView: GMSMapView, didTapMarker marker: MyGMSMarker) -> Bool
//    {
//
//        return true
//    }
    
    func setMarker(latitude : Double, longitude : Double){
        let marker = MyGMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude:  longitude))
        marker.indexofMarker = indexforDropPin
        
        if (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
      {
        
        if (self.barListArray.count == 0)
                 {
                     print("crashing here when no barlist count")
                     return
                 }
        
        
        marker.title = (barListArray[indexforDropPin].bar_name as! String)
        }
        
        if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            
        if (self.storeListArray.count == 0)
        {
            print("crashing here when no storelist count")
            return
        }
            
            
            
          marker.title = (storeListArray[indexforDropPin].store_name as! String)
          }
        else if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
      {
        marker.title = (peopleArray[indexforDropPin].name as! String)
        }
        
        if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            
        let distance = barListArray[indexforDropPin].distance as! Double
        marker.snippet = String(format: "%.2f mi", distance)
        }
       else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            let distance = storeListArray[indexforDropPin].distance as! Double
            marker.snippet = String(format: "%.2f mi", distance)
        }
        if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            marker.snippet = "\(peopleArray[indexforDropPin].visible_bar ?? "")"
        }
            
        //just added now for checking animation
        marker.appearAnimation = .pop
        marker.infoWindowAnchor = CGPoint.init(x: 0.44, y: 0.30)
//        print(marker.accessibilityActivationPoint)
//        print(marker.accessibilityFrame)
        let point = self.googleMap.projection.point(for: CLLocationCoordinate2D(latitude: latitude, longitude:  longitude))
        
        let viewPoints = self.view.convert(point, from: self.googleMap)
 //        print(viewPoints)

        self.showAnimatation(xPosition: viewPoints.x, yPosition: viewPoints.y)
        {
            
//        if self.childVc!.barsFilterView.isHidden == false
            if  (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            
         
            if (self.barListArray.count == 0)
            {
                print("crashing here when no barlist count")
                return
            }
            
        if (self.barListArray[self.indexforDropPin].bar_marker as! Int) == 0
        {
        marker.icon = UIImage.init(named: "otherbarmarker")
        }
        else
        {
        marker.icon = UIImage.init(named: "productmarker")
        }
        }
            else  if  (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                if self.storeListArray.count > 0
                {
                
                if self.storeListArray[self.indexforDropPin].store_marker is String == true
                {
                    marker.icon = UIImage.init(named: "otherbarmarker")

                }
                else  if (self.storeListArray[self.indexforDropPin].store_marker as! Int) == 0
                {
                    marker.icon = UIImage.init(named: "otherbarmarker")
                }
                else
                {
                    marker.icon = UIImage.init(named: "productmarker")
                }
                }
                
            }
        else if  (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                marker.icon = self.drawImageWithProfilePic(pp: UIImage.init(named: "profileplaceholder")!, image: UIImage.init(named: "newimagemarker")!)

                
//                  marker.icon =
            }
            
            
                        
            marker.map = self.googleMap
            
            
            
            if  (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            //RIGHT PLACE FOR INCREASING INDEX OF PINS
                
//        if self.btnLoadMore.backgroundColor == UIColor.white .withAlphaComponent(0.6) && self.indexforDropPin == 7
//        {
//            self.timerforPinDropping?.invalidate()
//            self.timerforPinDropping = nil
//            print("its last index for drop pin")
//
//            return
//        }
//        else
            if (self.indexforDropPin + 1) == self.barListArray.count{
                
//                hb
//                self.childVc?.view.isUserInteractionEnabled = true
                
                self.timerforPinDropping?.invalidate()
                if self.timerforPinDropping != nil{
                self.timerforPinDropping = nil
                }

            }
            else
            {
                
            self.indexforDropPin = self.indexforDropPin + 1
            }
        }
            else if  (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            

                if (self.indexforDropPin + 1) == self.storeListArray.count
            {
//                hb
//            self.childVc?.view.isUserInteractionEnabled = true
            self.timerforPinDropping?.invalidate()
            if self.timerforPinDropping != nil
            {
                self.timerforPinDropping = nil
            }

            }
            else
            {
                         
            self.indexforDropPin = self.indexforDropPin + 1
            }
        }
            
            if  (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {

                if (self.indexforDropPin + 1) == self.peopleArray.count
            {
          
            self.timerforPinDropping?.invalidate()
            if self.timerforPinDropping != nil
            {
                self.timerforPinDropping = nil
            }
            }
            else
            {
            self.indexforDropPin = self.indexforDropPin + 1
            }
                
            }
        }
    }

    func showAnimatation(xPosition : CGFloat, yPosition : CGFloat, completion : @escaping (() -> ())){
        
        let imageView = UIImageView(frame: CGRect(x: xPosition - 15, y: yPosition - 30 - 500, width: 30, height: 30))
        if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))!
            || menuChildVc?.view.isHidden == false
            || messageHistoryChildVc?.view.isHidden == false
            || profileChildVc?.view.isHidden == false
            ||  editprofileChildVc?.view.isHidden == false
            || followChildVc?.view.isHidden == false
            || feedbackChildVc?.view.isHidden == false
            || loginChildVc?.view.isHidden == false
            || signupChildVc?.view.isHidden == false
            || notificationChildVc?.view.isHidden == false
            || firstTimeFlowChildVc?.view.isHidden == false
            || imgesChildVcForbarandStore?.view.isHidden == false
            {
            imageView.isHidden = true
            }
            else
            {
                if yPosition < 500
                {
                    imageView.isHidden = false
                }
                else{
                imageView.isHidden = true
                }
                
                print("y position is here \(yPosition)")
//            imageView.isHidden = false
            }
        
        imageView.image = UIImage(named: "otherbarmarker")
        self.view.addSubview(imageView)

        UIView.animate(withDuration: 0.2, animations: {
            imageView.frame.origin.y = yPosition - 15
            self.view.layoutIfNeeded()
            //extra
        }) { (true) in
            imageView.isHidden = true
            imageView.removeFromSuperview()
            completion()
        }
    }
        //MARK:- ERROR RESPONSE
       func failureRsponseError(failureError: NSError?, serviceurl: NSString)
       {              
        if failureError != nil {
        print("failiure error in this api : \(serviceurl) and error is \(failureError!)")
        }
    }
    override func loadView() {
        var hbStr : String = ""
        
//        self.getBarsApi(barLatiTude: "25.7616798", bar_longitude: "-80.19179020000001")
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.7616798, longitude: 80.19179020000001, zoom: 12.21283)
        
        googleMap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        googleMap.delegate = self
         if let path = Bundle.main.path(forResource: "google_Maps", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

            if   let str = String(data: data, encoding: .utf8)
            {
                    hbStr = str
            }
            }
            catch
            {
            }
            }
      do {
        // Set the map style by passing a valid JSON string.
     
            self.googleMap.mapStyle = try GMSMapStyle(jsonString: hbStr)

      } catch {
        NSLog("One or more of the map styles failed to load. \(error)")
      }
        
//        googleMap.superview = googleMap
        self.view = googleMap
    }

    
    
//  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
//    {
//
////        marker.boun
////        self.mapView.selectedMarker = marker
////        markerTappedHandler?(marker)
//        return true
//    }
    
    //COLLECTION VIEW DATA SOURCE AND DELEGATES > > >
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
           return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {           if collectionView ==      imgesChildVcForbarandStore?.collectionViewBarImagesNew
          {
            
        if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
         //this is a bar images cell on bottom bar details table view cell
            if barDetailsObj != nil
            {
            return (barDetailsObj?.bar_gallery as! NSArray).count
            }
            else
            {
                return 0
            }
            }
            else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                if storeDetailsObj != nil
                {
                return (storeDetailsObj?.store_gallery as! NSArray).count
                }
                else
                {
                    return 0
                }
                
            }
              else
              {
                return 0
            }
            
        }
        
       else if collectionView == childVc?.collectionViewFilters
        {
            
            if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                  return storeFilterArray.count
            }
            else if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            return barFilterArray.count

            }
            else
            {
                return 0
            }
                                    
        }
        else  if collectionView.tag == 9000
        {
            // this is bar team collection view basically :
            return (barDetailsObj?.bar_team as? NSArray)!.count
        }
        else  if collectionView.tag == 10000
        {
                      // this is store team collection view basically :
        return (storeDetailsObj?.store_team as? NSArray)!.count
        }
        else  if collectionView.tag == 800
        {
            //ADDS COLLECTIONVIEW
            return addsImagesArray.count
          }
          else if collectionView.tag == 1088
          {
            
        if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
         //this is a bar images cell on bottom bar details table view cell
            if barDetailsObj != nil
            {
            return (barDetailsObj?.bar_gallery as! NSArray).count
            }
            else
            {
                return 0
            }
            }
            else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                if storeDetailsObj != nil
                {
                return (storeDetailsObj?.store_gallery as! NSArray).count
                }
                else
                {
                    return 0
                }
                
                
            }
              else
              {
                return 0
            }
            
        }
        else{
            
    if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
    {
//                if btnLoadMore.backgroundColor == UIColor.white .withAlphaComponent(0.6)
//                {
//                    if barListArray.count > 7{
//                        return 7
//                    }
//                    else{
//                        return barListArray.count
//                    }
//                }
//                else
//                {
                return barListArray.count
//                }
            }
            else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
//                if btnLoadMore.backgroundColor == UIColor.white .withAlphaComponent(0.6)
//                {
//                    if storeListArray.count > 7
//                    {
//                    return 7
//                    }
//                    else
//                    {
//                    return storeListArray.count
//                    }
//                    }
//                    else
//                    {
                    return storeListArray.count
//                    }
            }
            else
            {
                return 0
            }
            
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
//        adjustViewsForOrientation(orientation: UIApplication.shared.statusBarOrientation)

        
//
//
//        if UIDevice.current.orientation.isPortrait
//        {
////            UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.portrait, animated: true)
//
////            let window = UIApplication.shared.keyWindow
////            let currentView : UIView = window?.subviews[0]  as! UIView
//
////                (window.subviews as NSArray?)?.object(at: 0)
////            currentView.removeFromSuperview()
////            window?.addSubview(currentView)
//
////            print("current orientation is portrait")
////            self.downTheMenuForcefully()
////            UIView.animate(withDuration: 0.2)
////            {
//            self.view.layoutIfNeeded()
////            }
//        }
//        else if UIDevice.current.orientation.isLandscape
//        {
//          print("current orientation is landscape")
//        }
//        else
//        {
//            print("\(UIDevice.current.orientation)")
//        }
//
//
//
////        if (childVc?.imgArrow.image?.isEqual(UIImage.init(named: "down")))! == false
////        {
////            self.downTheMenuForcefully()
////            print("came in ")
////        }
////        self.view.layoutIfNeeded()
//
////        coordinator.animate(alongsideTransition: nil, completion: {
////            _ in
////            self.collectionView.collectionViewLayout.invalidateLayout()
////        })
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == imgesChildVcForbarandStore?.collectionViewBarImagesNew
                {
                    
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarImagesCell", for: indexPath) as! BarImagesCell
                    
                    var imgStr: String = ""
        //            if childVc!.barsFilterView.isHidden == false
                        
                if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
                    {
                imgStr = Constant.imageBaseUrl + "\((barDetailsObj?.bar_gallery as! NSArray)[indexPath.item])"
                print("bar detail image is \((barDetailsObj?.bar_gallery as! NSArray)[indexPath.item])")
                    }
                else  if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
                    {
                        print("store detail image is \((storeDetailsObj?.store_gallery as! NSArray)[indexPath.item])")
                        
                  imgStr =  Constant.imageBaseUrl + "\((storeDetailsObj?.store_gallery as! NSArray)[indexPath.item])"
                    }
                    
                    imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                    cell.imgBars.contentMode = .scaleToFill
                    cell.imgBars.sd_imageIndicator = SDWebImageActivityIndicator.gray

                    cell.imgBars.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "loadingbarimages"))
                    
                    return cell
                    
                }
        
      else  if collectionView.tag == 10000
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkhereStoreCell", for: indexPath) as! WorkhereStoreCell
        
            if storeDetailsObj != nil
            {
                
                let teamUserId = "\(((storeDetailsObj?.store_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "team_id") ?? "0")"
                
                print("teamUserId is  \(teamUserId)")

                let userFollower = "\(((storeDetailsObj?.store_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "userFollower") ?? "0")"
                
                print("user follower isi \(userFollower)")
                if teamUserId == "\(self.savedataInstance.id ?? "0")"
                {
                    cell.btnFollowTeamOnStore.setTitle("Follow", for: .normal)
                    cell.btnFollowTeamOnStore.isUserInteractionEnabled = false
                    cell.btnFollowTeamOnStore.backgroundColor =  UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)
                    
                    cell.btnFollowTeamOnStore.layer.borderColor = UIColor.clear.cgColor
                    cell.btnFollowTeamOnStore.layer.borderWidth = 0.0
                    
                    cell.btnFollowTeamOnStore.setTitleColor(UIColor.white, for: .normal)
                    
                }
                else if userFollower == "0"
                {                    
                    cell.btnFollowTeamOnStore.layer.borderColor = UIColor.clear.cgColor
                    cell.btnFollowTeamOnStore.layer.borderWidth = 0.0
                    cell.btnFollowTeamOnStore.isUserInteractionEnabled = true
                    cell.btnFollowTeamOnStore.setTitle("Follow", for: .normal)
                    cell.btnFollowTeamOnStore.backgroundColor =  UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)
                    cell.btnFollowTeamOnStore.setTitleColor(UIColor.white, for: .normal)
                }
                else if userFollower == "1"
                {
                    
                    cell.btnFollowTeamOnStore.setTitle("Follower", for: .normal)
                    cell.btnFollowTeamOnStore.isUserInteractionEnabled = true
                    cell.btnFollowTeamOnStore.backgroundColor =  UIColor.white
                    cell.btnFollowTeamOnStore.setTitleColor(UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0), for: .normal)

                    cell.btnFollowTeamOnStore.layer.borderColor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0).cgColor
                    cell.btnFollowTeamOnStore.layer.borderWidth = 2.0
                    

                }
              cell.btnFollowTeamOnStore.tag = indexPath.item
                
            cell.btnFollowTeamOnStore.addTarget(self, action: #selector(followUnfollowStoreTeamAction(_:)), for: .touchUpInside)

        let imgName = ((storeDetailsObj?.store_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "profile_img") as? String
                
        var imgStr =  Constant.BAR_TEAM_IMAGE_BASEURL + "\(imgName!)"
                
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                
        cell.imgTeam.layer.cornerRadius = cell.imgTeam.frame.size.width / 2
                
        cell.imgTeam.clipsToBounds = true
        cell.imgTeam.layer.masksToBounds = true

        cell.imgTeam.contentMode = .scaleAspectFit
                
        cell.imgTeam.sd_imageIndicator = SDWebImageActivityIndicator.gray
        print("my image team frame is \(cell.imgTeam.frame)")

        cell.imgTeam.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "teamPlaceHolder"))
            
            cell.lblTeamUserName.text = ((storeDetailsObj?.store_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "name") as? String
//             cell.lblSpeicalityStoreteam.text  = ""
            cell.lblSpeicalityStoreteam.text = ((storeDetailsObj?.store_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "speciality") as? String
            }
            return cell
        }
            
            
       else if collectionView.tag == 9000
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkhereBarCell", for: indexPath) as! WorkhereBarCell
            cell.btnFollowTeamOnStore.tag = indexPath.item
            
            cell.btnFollowTeamOnStore.addTarget(self, action: #selector(followUnfollowBarTeamAction(_:)), for: .touchUpInside)

            if barDetailsObj != nil
            {
                
        let imgName = ((barDetailsObj?.bar_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "profile_img") as? String
                
        var imgStr =  Constant.BAR_TEAM_IMAGE_BASEURL + "\(imgName!)"
                
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)
                
        cell.imgTeam.layer.cornerRadius = cell.imgTeam.frame.size.width / 2
                
        cell.imgTeam.clipsToBounds = true
                
        cell.imgTeam.layer.masksToBounds = true

        cell.imgTeam.contentMode = .scaleAspectFit
                
        cell.imgTeam.sd_imageIndicator = SDWebImageActivityIndicator.gray

        cell.imgTeam.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "teamPlaceHolder"))
            
                cell.lblTeamUserName.text = ((barDetailsObj?.bar_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "name") as? String
            
           
            
            let teamUserId = "\(((barDetailsObj?.bar_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "team_id") ?? "0")"
            
            print("teamUserId is  \(teamUserId)")
            
            let userFollower = "\(((barDetailsObj?.bar_team as! NSArray).object(at: indexPath.item) as? NSDictionary)!.value(forKey: "userFollower") ?? "0")"
            
            print("user follower isi \(userFollower)")
            if teamUserId == "\(self.savedataInstance.id ?? "0")"
            {
                cell.btnFollowTeamOnStore.setTitle("Follow", for: .normal)
                cell.btnFollowTeamOnStore.isUserInteractionEnabled = false
                cell.btnFollowTeamOnStore.backgroundColor =  UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)
                
                cell.btnFollowTeamOnStore.layer.borderColor = UIColor.clear.cgColor
                cell.btnFollowTeamOnStore.layer.borderWidth = 0.0
                
                cell.btnFollowTeamOnStore.setTitleColor(UIColor.white, for: .normal)
                
            }
            else if userFollower == "0"
            {
                
                cell.btnFollowTeamOnStore.layer.borderColor = UIColor.clear.cgColor
                cell.btnFollowTeamOnStore.layer.borderWidth = 0.0
                
                
                cell.btnFollowTeamOnStore.isUserInteractionEnabled = true
                cell.btnFollowTeamOnStore.setTitle("Follow", for: .normal)
                cell.btnFollowTeamOnStore.backgroundColor =  UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)
                cell.btnFollowTeamOnStore.setTitleColor(UIColor.white, for: .normal)
            }
            else if userFollower == "1"
            {
                
                cell.btnFollowTeamOnStore.setTitle("Follower", for: .normal)
                cell.btnFollowTeamOnStore.isUserInteractionEnabled = true
                cell.btnFollowTeamOnStore.backgroundColor =  UIColor.white
                cell.btnFollowTeamOnStore.setTitleColor(UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0), for: .normal)
                
                cell.btnFollowTeamOnStore.layer.borderColor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0).cgColor
                cell.btnFollowTeamOnStore.layer.borderWidth = 2.0
                
                
            }
            cell.btnFollowTeamOnStore.tag = indexPath.item
            
            cell.btnFollowTeamOnStore.addTarget(self, action: #selector(followUnfollowBarTeamAction(_:)), for: .touchUpInside)
            
            
            }
            
            
            
            return cell
            
        }
        else if collectionView == childVc?.collectionViewFilters
        {
            //ADDS COLLECTIONVIEW
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersCollectionViewCell", for: indexPath) as! FiltersCollectionViewCell
            
            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                
                if selectedBarFilterArray.contains(barFilterArray[indexPath.item])
                {
                cell.btnFilterInCollectionView.setImage(UIImage.init(named: "selectionon"), for: .normal)
                }
                else
                {
                    cell.btnFilterInCollectionView.setImage(UIImage.init(named: "selectionoff"), for: .normal)
                    
                }
                
                cell.lblFilterName.text = "\(barFilterArray[indexPath.item])"
            }
            else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                
                if selectedStoreFilterArray.contains(storeFilterArray[indexPath.item])
                {
            cell.btnFilterInCollectionView.setImage(UIImage.init(named: "selectionon"), for: .normal)
                }
                else
                {
                cell.btnFilterInCollectionView.setImage(UIImage.init(named: "selectionoff"), for: .normal)
                }
                
                cell.lblFilterName.text = "\(storeFilterArray[indexPath.item])"
            }
            else{
                cell.lblFilterName.text = ""
            }
            
//            cell.btnFilterInCollectionView.layer.borderWidth = 2.3
//            
//            cell.btnFilterInCollectionView.layer.borderColor = UIColor.init(red: 27/255, green: 111/255, blue: 109/255, alpha: 1.0).cgColor
            
            return cell
        }
        
       else if collectionView.tag == 800
        {
            //ADDS COLLECTIONVIEW
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarImagesCell", for: indexPath) as! BarImagesCell
            
            //checking for ui :
            cell.imgBars.contentMode = .scaleToFill
            
            cell.imgBars.image = (addsImagesArray[indexPath.item] as! UIImage)
            
            return cell
        }
        else if collectionView.tag == 1088
        {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarImagesCell", for: indexPath) as! BarImagesCell
            
            var imgStr: String = ""
//            if childVc!.barsFilterView.isHidden == false
                
        if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
        imgStr = Constant.imageBaseUrl + "\((barDetailsObj?.bar_gallery as! NSArray)[indexPath.item])"
        print("bar detail image is \((barDetailsObj?.bar_gallery as! NSArray)[indexPath.item])")
            }
        else  if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                print("store detail image is \((storeDetailsObj?.store_gallery as! NSArray)[indexPath.item])")
                
          imgStr =  Constant.imageBaseUrl + "\((storeDetailsObj?.store_gallery as! NSArray)[indexPath.item])"
            }
            
            imgStr = RandomObjects.geturlEncodedString(string: imgStr)
            cell.imgBars.contentMode = .scaleToFill
            cell.imgBars.sd_imageIndicator = SDWebImageActivityIndicator.gray

            cell.imgBars.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "loadingbarimages"))
            
            return cell
            
        }
        else{
            if (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!

            {
               return self.getBarListCell(indexPath: indexPath, collectionView: collectionView)
            }
            else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
              return  self.getStoreListCell(indexPath: indexPath, collectionView: collectionView)
            }
            else{
                return UICollectionViewCell()
            }
        }
       }
        
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView ==      imgesChildVcForbarandStore?.collectionViewBarImagesNew
        {
            return CGSize.init(width: collectionView.frame.size.width , height: collectionView.frame.size.height)

        }
        else if collectionView.tag == 10000
        {
            if (storeDetailsObj?.store_team as? NSArray)!.count > 0
            {
//            return CGSize.init(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.width / 3 + 80)
                return CGSize.init(width: collectionView.frame.size.width / 3, height: 180)
            }
            else
            {
                return CGSize.init(width: 0.0, height: 0.0)
            }
        }
       else  if collectionView.tag == 9000
        {
            if (barDetailsObj?.bar_team as? NSArray)!.count > 0
            {
            return CGSize.init(width: collectionView.frame.size.width / 3, height:180)
//                collectionView.frame.size.width / 3 + 40
            }
            else
            {
                return CGSize.init(width: 0.0, height: 0.0)

            }
            
        }
        
       else if collectionView == childVc?.collectionViewFilters
        {
            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
            if indexPath.item == 0 || indexPath.item == 1
            {
                 return CGSize.init(width: collectionView.frame.size.width / 6.0, height: 30)
            }
            else if  indexPath.item == 2 || indexPath.item == 3
            {
                return CGSize.init(width: collectionView.frame.size.width / 3, height: 30)
            }
            else
            {
                return CGSize.init(width: collectionView.frame.size.width / 3.0, height: 30)
            }
            }
            else  if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                    return CGSize.init(width: collectionView.frame.size.width / 3.0, height: 30)
               }
            else
            {
                 return CGSize.init(width: 0, height: 0)
            }
        }
        else if collectionView.tag == 1088{
            //for bar images
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
          else  if collectionView.tag == 800
            {
            //adds collectionview on bottom
                //for bar images
            return CGSize.init(width: collectionView.frame.size.width, height: 72)
            }
        else{
            //for bar listings
            return CGSize.init(width: collectionView.frame.size.width / 2.7, height: 140)
            
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 1088{
            if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                print("BAR SELECTED")
                if  (barDetailsObj?.bar_gallery as! NSArray).count > 0
                {
                    imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage = indexPath.item
                    imgesChildVcForbarandStore?.collectionViewBarImagesNew.scrollToItem(at: IndexPath.init(item: imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage, section: 0), at: .centeredHorizontally, animated: true)

                imgesChildVcForbarandStore?.view.isHidden = false
                imgesChildVcForbarandStore?.collectionViewBarImagesNew.reloadData()
                }
                else
                {
                    SVProgressHUD.showError(withStatus: "No images found for bar")
                }
//            imgStr = Constant.imageBaseUrl + "\((barDetailsObj?.bar_gallery as! NSArray)[indexPath.item])"
            }
            else
            {
                
                if  (storeDetailsObj?.store_gallery as! NSArray).count > 0
                {
                    imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage = indexPath.item
                    imgesChildVcForbarandStore?.collectionViewBarImagesNew.scrollToItem(at: IndexPath.init(item: imgesChildVcForbarandStore!.indexofSelectedBarandStoreImage, section: 0), at: .centeredHorizontally, animated: true)

                               imgesChildVcForbarandStore?.view.isHidden = false
                               imgesChildVcForbarandStore?.collectionViewBarImagesNew.reloadData()
                }
                else
                {
                        SVProgressHUD.showError(withStatus: "No images found for store")
                }
                
                print("STORE SELECTED")
//                imgesChildVcForbarandStore?.view.isHidden = false
//                imgesChildVcForbarandStore?.collectionViewBarImagesNew.reloadData()
//            imgStr = Constant.imageBaseUrl + "\((storeDetailsObj?.bar_gallery as! NSArray)[indexPath.item])"
            }
            return
        }
        
        else if collectionView.tag == 9000 || collectionView.tag == 10000{
            return
        }
        else if collectionView == childVc?.collectionViewFilters
        {

                timerforPinDropping?.invalidate()
                timerforPinDropping = nil
                indexforDropPin = 0

            if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                //here
        if selectedBarFilterArray.contains(barFilterArray[indexPath.item])
                {
                    selectedBarFilterArray.remove(barFilterArray[indexPath.item])
                }
                else
                {
            selectedBarFilterArray.add(barFilterArray[indexPath.item])
                }
                
                
                if barFilterArray[indexPath.item] == "$" || barFilterArray[indexPath.item] == "$$" || barFilterArray[indexPath.item] == "$$$"
                {                    self.filterBarsArrayAccordingtoDollars(listArray: tempBarsArray as NSArray)
                }
                else
                {
    if  appdelegate.selectedLatitude! != 0.0
    {
        self.getBarsApi(barLatiTude: "\(appdelegate.selectedLatitude!)",bar_longitude: "\(appdelegate.selectedLongitude!)" )
    }
        else
        {
        self.getBarsApi(barLatiTude: "\(RandomObjects.getLatitude())", bar_longitude: "\(RandomObjects.getLongitude())")
        }
        }
        childVc?.collectionViewFilters.reloadData()
                //to here
            }
           else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                
                if selectedStoreFilterArray.contains(storeFilterArray[indexPath.item])
                {
                selectedStoreFilterArray.removeAllObjects()
                childVc?.collectionViewFilters.reloadData()

            if  appdelegate.selectedLatitude! != 0.0
            {
                self.getStoresApi(store_latitude: "\(  appdelegate.selectedLatitude!)", store_longitude: "\(  appdelegate.selectedLongitude!)")
                }
            else
                {
                                                  
            self.getStoresApi(store_latitude: "\(RandomObjects.getLatitude())", store_longitude: "\(RandomObjects.getLongitude())")
                }
                    return
                    
                }
                
                //here
                if selectedStoreFilterArray.count > 0
                {
                    selectedStoreFilterArray.removeAllObjects()
                }
            selectedStoreFilterArray.add(storeFilterArray[indexPath.item])
                
                childVc?.collectionViewFilters.reloadData()
                
                if  appdelegate.selectedLatitude! != 0.0
                    {
                    self.getStoresApi(store_latitude: "\(  appdelegate.selectedLatitude!)", store_longitude: "\(  appdelegate.selectedLongitude!)")
                    }
                    else
                    {
                               
                self.getStoresApi(store_latitude: "\(RandomObjects.getLatitude())", store_longitude: "\(RandomObjects.getLongitude())")
                    }
                //to here
            }
            
            return
        }
        
        else if collectionView.tag == 800{
            //ads collection view selection
            UIApplication.shared.openURL(URL.init(string: "https://www.mjdistillers.com/")!)
//            return
        }
        else if collectionView.tag == 1088{
//            self.createCircles()
            //bar images collection view cell selection
        return
        }
        else
        {
         
            if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            
            selectedBar = indexPath.item
        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousBarSelected, section: 0)])

        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedBar, section: 0)])
            
            previousBarSelected = indexPath.item
            if collectionView == childVc?.collectionViewBarsandStores
            {
            self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedBar, section: 0), at: .centeredHorizontally, animated: true)
            }
            
            //bar images collection view cell selection
            if collectionView == childVc?.collectionViewBarsandStores
            {
                self.getBarsDetailsApi(index: indexPath.item, isSearchEnabled: false)
            }
                
            }
            else  if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                       
            selectedStore = indexPath.item
        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: previousStoreSelected, section: 0)])

        self.childVc?.collectionViewBarsandStores.reloadItems(at: [IndexPath.init(item: selectedStore, section: 0)])
                       
            previousStoreSelected = indexPath.item
                    
            if collectionView == childVc?.collectionViewBarsandStores
            {
        self.childVc?.collectionViewBarsandStores.scrollToItem(at: IndexPath.init(item: selectedStore, section: 0), at: .centeredHorizontally, animated: true)
            }
                       
                       //bar images collection view cell selection
            if collectionView == childVc?.collectionViewBarsandStores
            {
                self.getStoresDetailsApi(index: selectedStore, isSearchEnabled: false)
//            self.getBarsDetailsApi(index: indexPath.item)
            }
        }

        }
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            //HB 2 MAR
//            if tableView == choosePlacesChildVc?.tblPlaces
//            {
//                return UITableView.automaticDimension
//            }
//           else
            
//            followChildVc?.tblFollowing.delegate = self
//                   followChildVc?.tblFollowers.r
            if tableView == followChildVc?.tblFollowing
            {
                print("came in height tblFollowing")
             return 71
            }
            else  if tableView == followChildVc?.tblFollowers
            {
                print("came in height tblFollowers")

                return 71
            }
           else if tableView == childVc?.tblPeople
            {
                return 71
            }
           else if tableView == messageHistoryChildVc?.tblMessagesHistory
            {
            print("came in height function of message history")
            return UITableView.automaticDimension
            }
            else if tableView == childVc?.tblsearch
            {
            return UITableView.automaticDimension
            }
            else if tableView.tag == 200 ||  tableView.tag == 300
            {
            //event table
            return UITableView.automaticDimension
            }
            else
            {
                return UITableView.automaticDimension
            }
            // UITableView.automaticDimension
    }
    //MARK:- TABLEVIEW DELEGATE AND DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == childVc?.tblPeople
        {
//            if peopleArray.count > 7
//            {
//                return 7
//            }
//            else{
                return peopleArray.count
//                }
        }
        if tableView.tag == 200
        {
            //
            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                
            if barDetailsObj != nil
            {
            return (barDetailsObj?.todayEvent as! NSArray).count
            }
            else
            {
                return 0
            }
                
            }
            else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!{
                
                if storeDetailsObj != nil
                {
                return (storeDetailsObj?.todayEvent as! NSArray).count
                }
                else
                {
                    return 0
                }
                
            }
            else if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!{
                return 0
            }
            else{
                return 0
            }
            // today events table view
        }
        else if tableView.tag == 300
        {
            //UPCOMING EVENTS
            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
                       {
                           
                           if barDetailsObj != nil
                                     {
                                     return (barDetailsObj?.comingEvents as! NSArray).count
                                     }
                                     else
                                     {
                                         return 0
                                     }
                           
                       }
                       else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!{
                           
                           if storeDetailsObj != nil
                           {
                           return (storeDetailsObj?.comingEvents as! NSArray).count
                           }
                           else
                           {
                               return 0
                           }
                           
                       }
                       else if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!{
                           return 0
                       }
            else{
                return 0
            }

        }
        else
        {
            
            if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                if barListArray.count > 0 && barDetailsObj != nil
                {
                    return 1
                }
                else
                {
                    return 0
                }
            }
            else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                if storeListArray.count > 0 && storeDetailsObj != nil
                {
                return 1
                }
                else
                {
                return 0
                }
                
            }
            else if  (childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                return 0
            }
          else
          {
            return 1
            }
        
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

    
    //MARK:- BLOCK UNBLOCK API ON GET PEOPLE AND ACTION
    @objc func blockUnblockActionOnGetPeople(_ sender: UIButton)
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
        if tableView == childVc?.tblPeople
        {
            //get people list
        let cell : GetPeopleCell = tableView.dequeueReusableCell(withIdentifier: "GetPeopleCell") as! GetPeopleCell
            
       cell.selectionStyle = .none

            var user_blocked_by :Int = 0
                   let myIdStr :String = "\(savedataInstance.id!)"
                   let myId :Int = Int(myIdStr)!
            cell.btnBlockUnblock.tag = indexPath.row
            cell.btnBlockUnblock.addTarget(self, action: #selector(blockUnblockActionOnGetPeople(_:)), for: .touchUpInside)


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
                print("follow to api case 1")
            }
            else
            {
                cell.btnBlockUnblock.backgroundColor = blueAppColor
                cell.btnBlockUnblock.setTitle("Block", for: .normal)
                print("follow to api case 1")
                self.setFollowButtonTextAccordingtoCases(btnFollow: cell.btnFollowUnfollow, index: indexPath.row)
                cell.btnFollowUnfollow.isUserInteractionEnabled = true

            }
            
            cell.btnFollowUnfollow.tag = indexPath.row

            
       cell.btnFollowUnfollow.addTarget(self, action: #selector(followUnfollowActiononGetPeople(_:)), for: .touchUpInside)

            
//            if peopleArray[indexPath.row].
            
            
            if "\(peopleArray[indexPath.row].username ?? "")".isEmpty == false
            {
                cell.lblName.text = "\(peopleArray[indexPath.row].username!)"
            }
            else if "\(peopleArray[indexPath.row].name ?? "")".isEmpty == false
                {
                    cell.lblName.text = "\(peopleArray[indexPath.row].name ?? "")"
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
//            return peopleArray.count
        }
       else  if tableView.tag == 300
        {
            let cell : BarsEventsCell = tableView.dequeueReusableCell(withIdentifier: "BarsEventsCell") as! BarsEventsCell
            
            cell.selectionStyle = .none
            
            var commonDict : NSDictionary? = nil
            
            if  (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            if (barDetailsObj != nil){
                        
            if (barDetailsObj?.comingEvents as! NSArray).count > 0
            {
                                       
            commonDict =  ((barDetailsObj?.comingEvents as! NSArray).object(at: indexPath.row) as? NSDictionary)
            }
            else{
                return cell
            }
             }
             else{
                   return cell
             }
             
                }
                else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                    
                      if (storeDetailsObj != nil)
                      {
                        if (storeDetailsObj?.comingEvents as! NSArray).count > 0
                        {
                        commonDict =  ((storeDetailsObj?.comingEvents as! NSArray).object(at: indexPath.row) as? NSDictionary)
                     }
                    else
                    {
                    return cell
                    }
                    }
                    else
                    {
                        return cell
                    }
                    
                }
                else if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                    print("cell for row returning empty celll in people case")
                    return cell
                    
                }
                
                
                
//            if (barDetailsObj != nil)
//            {
               

            
                if (commonDict?.value(forKey: "event_type") as! String) == "Other"
                {
                    
                    cell.lblEventDay.text = (commonDict?.value(forKey: "other_type") as! String).capitalized
                }
                else
                {
                    
                    cell.lblEventDay.text = (commonDict?.value(forKey: "event_type") as! String).capitalized
                }
               

                
                let strTime : NSString = NSString.init(format: "%@ to %@",((commonDict?.value(forKey: "start_time") as! NSString) as NSString),((commonDict?.value(forKey: "end_time") as! NSString) as NSString) )

                cell.lblEventTime.text = strTime as String

                cell.lblEventDescription.text = commonDict?.value(forKey: "event_desc") as? String
                var eventCategory : NSString = ""
                
                if commonDict?["event_category"] != nil{
                    eventCategory = (commonDict?["event_category"]as? NSString ?? "")
                }
                
                if eventCategory == ""{
                    print("check null value")
                }
                
                print("check value \(eventCategory)")
            
             if  (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                let barImage : UIImage?
                if eventCategory.isEqual(to: "Drink Special" ) || eventCategory.isEqual(to: "Food & Drink Special" ) || eventCategory.isEqual(to: "MJ Promotion" )
                {
                    barImage = UIImage.init(named: "d")
                }
                else{
                    barImage = UIImage.init(named: "e")
                }
                cell.imgEvent.image = barImage
            }
           else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                print("COMMON DICT FOR EVENT IS \(commonDict)")
                
                var imageStr : String = (commonDict?.value(forKey: "event_image") as! String)
                imageStr  = Constant.imageBaseUrlForStoreEvents + "\(imageStr)"
                
                imageStr = RandomObjects.geturlEncodedString(string: imageStr)
                
                cell.imgEvent.sd_imageIndicator = SDWebImageActivityIndicator.gray
                   
                cell.imgEvent.sd_setImage(with: URL(string: imageStr), placeholderImage: UIImage(named: "loadingbarimages"))

            }
            
            
                
                if (commonDict?["food_price"] as? String) != nil
                {
                    let food_price : NSString = NSString.init(format: "Appetizers($): %@", commonDict?["food_price"] as! String)
                    cell.lblFoodPrice.text = food_price as String
                }
                else{
                    cell.lblFoodPrice.text = ""
                }
                
                if (commonDict?["drink_price"] as? String) != nil {
                    //empty aae
                    let drink_price : NSString = NSString.init(format: "Mix Drink($):  %@", commonDict?["drink_price"] as! String)
                    cell.lblAppetizers.text = drink_price as String
                    }
                else{
                    cell.lblAppetizers.text = ""
                }
                
//            }
            return cell
                
            }
       else if tableView.tag == 200
        {
        let cell : BarsEventsCell = tableView.dequeueReusableCell(withIdentifier: "BarsEventsCell") as! BarsEventsCell
            
            cell.selectionStyle = .none
        
        
        var commonDict : NSDictionary? = nil
                      
                      
        if  (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            if (barDetailsObj != nil)
            {
                if (barDetailsObj?.todayEvent as! NSArray).count > 0 {
                
                commonDict =  ((barDetailsObj?.todayEvent as! NSArray).object(at: indexPath.row) as? NSDictionary)
                }
                else{
                    return cell
                }
            }
            else
            {
                return cell
            }
                          
        }
        else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
                        
        if (storeDetailsObj != nil)
        {
       if (storeDetailsObj?.todayEvent as! NSArray).count > 0 {
        
        commonDict =  ((storeDetailsObj?.todayEvent as! NSArray).object(at: indexPath.row) as? NSDictionary)
        }
        else{
            return cell
        }
        }
        else
        {
            return cell
        }
                          
        }
        else if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            print("cell for row returning empty celll in people case")
            return cell
      
        }
            
            


            if (commonDict?.value(forKey: "event_type") as! String) == "Other"{
                
                  cell.lblEventDay.text = (commonDict?.value(forKey: "other_type") as! String).capitalized
            }
            else
            {
                
                cell.lblEventDay.text = (commonDict?.value(forKey: "event_type") as! String).capitalized
            }
           

            
            let strTime : NSString = NSString.init(format: "%@ to %@",((commonDict?.value(forKey: "start_time") as! NSString) as NSString),((commonDict?.value(forKey: "end_time") as! NSString) as NSString) )

            cell.lblEventTime.text = strTime as String
            
            cell.lblEventDescription.text = (commonDict?.value(forKey: "event_desc") as? String)
            
            let barImage : UIImage?
            
            
             if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!{
            
            if (commonDict?["event_category"]as! NSString).isEqual(to: "Drink Special" ) || (commonDict?["event_category"]as! NSString).isEqual(to: "Food & Drink Special" ) || (commonDict?["event_category"]as! NSString).isEqual(to: "MJ Promotion" )
            {
                barImage = UIImage.init(named: "d")
            }
            else{
                barImage = UIImage.init(named: "e")
            }
            }
            else
            {
                //in case of stores work is pending
                barImage = UIImage.init(named: "e")
            }
    
            cell.imgEvent.image = barImage
            
            if (commonDict?["food_price"] as? String) != nil
            {
                let food_price : NSString = NSString.init(format: "Appetizers($): %@", commonDict?["food_price"] as! String)
                cell.lblFoodPrice.text = food_price as String
            }
            else
            {
                cell.lblFoodPrice.text = ""
            }
            
            if (commonDict?["drink_price"] as? String) != nil {
                //empty aae
                let drink_price : NSString = NSString.init(format: "Mix Drink($):  %@", commonDict?["drink_price"] as! String)
                cell.lblAppetizers.text = drink_price as String
                }
            else{
                cell.lblAppetizers.text = ""
            }
            
//        }

        return cell
            
        }
        else
        {
         
             if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            return self.getBarsDetailCell(indexPath: indexPath, tableView: tableView)
            }
             else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
             {
                return self.getStoreDetailCell(indexPath: indexPath, tableView: tableView)
                //return store cell
            }
            else if  (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                //return people cell
                return UITableViewCell()
            }
            else{
                return UITableViewCell()
            }
            
        }
    }
    
    @objc func methodOfReceivedNotificationOpenNotificationsScreen(notification: Notification)
    {
        notificationChildVc?.view.isHidden = false
        notificationChildVc?.loadUI()
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OpenNotifications"), object: nil)
        
        
        if  (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
                {
                if appdelegate.selectedLatitude! != 0.0
                {
                self.getPeopleAPI(latitude:"\(  appdelegate.selectedLatitude!)", longitude: "\(  appdelegate.selectedLongitude!)")
                }
                else
                {
                        //GET PEOPLE API
                self.getPeopleAPI(latitude:
                            "\(RandomObjects.getLatitude())", longitude: "\(RandomObjects.getLongitude())")
                }

                }
        
        self.getMyProfileandUpdateData()
    }
    
    
    @objc func refreshUIOnlocationUpdates(notification: Notification)
     {
        if appdelegate.locationAuthorizationStatus == .authorizedWhenInUse
        {   
            if RandomObjects.getLatitude() != 25.7616798
            {
                print("location changed")
                self.getAddressfromLatLong()
                if childVc != nil{
            self.barsFilterButtonAction(childVc!.btnBars)
                }
                
            }
            else{
                print("location not changed")
            }
        }
       else if appdelegate.locationAuthorizationStatus == .denied
        {

            print("location changed")
            self.getAddressfromLatLong()
            
            if childVc != nil
            {
                self.barsFilterButtonAction(childVc!.btnBars)
            }
        }

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "RefreshUI"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.refreshUIOnlocationUpdates(notification:)),name: Notification.Name("RefreshUI"), object: nil)
        }
    
    @objc func methodOfReceivedNotificationOpenMessagesScreen(notification: Notification)
    {
//        notificationChildVc?.view.isHidden = false
//        notificationChildVc?.loadUI()
        
        self.view.endEditing(true)
        
        messageHistoryChildVc?.view.isHidden = true
        editmessageChildVc?.view.isHidden = true
        
        if messageHistoryChildVc?.view.isHidden == true
        {
            messageHistoryChildVc?.view.isHidden = false
            messageHistoryChildVc?.loadUI()
        }
          if editmessageChildVc?.view.isHidden == false
        {
            messageHistoryChildVc?.view.isHidden = true
        }
       
        
//    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "OpenMessages"), object: nil)

    }
    
    
        func searchLatitudeandLongitudeFromAddress()
        {
            let manager: AFHTTPSessionManager = AFHTTPSessionManager()
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            
            var urlStr = NSString.init(format:"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyAY0B4xNSzIrro5kII02w8GQwXmt9byMGo", childVc!.txtSearchbar.text!)

            urlStr =    RandomObjects.geturlEncodedString(string: urlStr as String) as NSString
//            urlStr = urlStr.replacingOccurrences(of: " ", with:"+") as NSString
            
            print(urlStr)
            
            print(urlStr)
            manager.get(urlStr as String, parameters: nil, progress: { (progress) in
                print(progress)
            }, success: { (task, response) in
                print("response GET LAT LONG API FROM ADDRESS is \(response)")
                
                let resultDict : NSDictionary? = response as! NSDictionary
                if resultDict?.value(forKey: "results") != nil
                {
                    
            self.appdelegate.selectedLongitude  = (((((resultDict?.value(forKey: "results") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "geometry") as? NSDictionary)?.value(forKey: "location") as? NSDictionary)?.value(forKey: "lng") as! Double)
                    
            self.appdelegate.selectedLatitude  = (((((resultDict?.value(forKey: "results") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "geometry") as? NSDictionary)?.value(forKey: "location") as? NSDictionary)?.value(forKey: "lat") as! Double)
                    
    print(self.appdelegate.selectedLongitude as Any)
                    
    print(self.appdelegate.selectedLatitude as Any)
                   
        if  (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
         {
            self.getBarsApi(barLatiTude: "\(self.appdelegate.selectedLatitude!)" , bar_longitude: "\(self.appdelegate.selectedLongitude!)")
         }
        else  if  (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!

         {
            self.getStoresApi(store_latitude: "\(self.appdelegate.selectedLatitude!)" , store_longitude: "\(self.appdelegate.selectedLongitude!)" )
        }
        else  if  (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                
            self.getPeopleAPI(latitude: "\(self.appdelegate.selectedLatitude!)", longitude: "\(self.appdelegate.selectedLongitude!)")
            }
                }
            }) { (task, error) in
                print("error in autocomplete api \(error)")
            }
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.view.endEditing(true)
         if tableView == followChildVc?.tblFollowing
        {
            print("it called ")
            
            followChildVc?.view.isHidden = true
            var dict = NSDictionary()
            dict = followChildVc?.followingArray.object(at: indexPath.row) as! NSDictionary
            
            print("dict is \(dict)")
            let otherprofile_id: Int? = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "id") as? Int
            
            let othername = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "name")
            let otherimage = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "profile_image")



            
                   profileChildVc?.view.isHidden = false
                   profileChildVc?.isOtherUserProfile = true
            profileChildVc?.otherUserId  = otherprofile_id!
                   profileChildVc?.setUpProfileDetails()
            
            
            profileChildVc? .selectedPeopleObj = PeopleList.init(
                user_blocked_by:  nil,
                user_blocked_id:  nil,
                block_id: nil,
                user_1: nil,
                   user_2: nil,
                   device_token: nil,
                   initiate_id:nil,
                   address: nil,
                   city: nil,
                   country: nil,
                   distance: nil,
                   email: nil,
                   fav_cocktail: nil,
                   fav_drink: nil,
                   fav_spirit: nil,
                   follow_by: nil,
                   follow_to: nil,
                   follower: nil,
                   following: nil,
                   my_status: nil,
                   name: nil,
                   phone: nil,
                   profile_image: otherimage,
                   public_user: nil,
                   requested: nil,
                   role: nil,
                   state: nil,
                   user_id: otherprofile_id as Any,
                   username: othername,
                   user_latitude: nil,
                   user_longitude: nil,
                   visible_bar: nil,
                   visible_for: nil,
                   visibility_status: nil,
                   person_status: nil)
            
            

        }
        else  if tableView == followChildVc?.tblFollowers
        {
          followChildVc?.view.isHidden = true
          var dict = NSDictionary()
          dict = followChildVc?.followersArray.object(at: indexPath.row) as! NSDictionary
          
          print("dict is \(dict)")
          let otherprofile_id: Int? = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "id") as? Int
          
          let othername = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "name")
          let otherimage = ((dict.value(forKey: "data") as? NSArray)?.object(at: 0) as? NSDictionary)?.value(forKey: "profile_image")

                 profileChildVc?.view.isHidden = false
                 profileChildVc?.isOtherUserProfile = true
                 profileChildVc?.otherUserId  = otherprofile_id!
                 profileChildVc?.setUpProfileDetails()
          
          
          profileChildVc? .selectedPeopleObj = PeopleList.init(
            user_blocked_by:  nil,
            user_blocked_id:  nil,
                block_id: nil,
                user_1: nil,
                 user_2: nil,
                 device_token: nil,
                 initiate_id:nil,
                 address: nil,
                 city: nil,
                 country: nil,
                 distance: nil,
                 email: nil,
                 fav_cocktail: nil,
                 fav_drink: nil,
                 fav_spirit: nil,
                 follow_by: nil,
                 follow_to: nil,
                 follower: nil,
                 following: nil,
                 my_status: nil,
                 name: nil,
                 phone: nil,
                 profile_image: otherimage,
                 public_user: nil,
                 requested: nil,
                 role: nil,
                 state: nil,
                 user_id: otherprofile_id as Any,
                 username: othername,
                 user_latitude: nil,
                 user_longitude: nil,
                 visible_bar: nil,
                 visible_for: nil,
                 visibility_status: nil,
                 person_status: nil)
          
          
            
//            return 71
        }
       else if tableView == childVc?.tblsearch
        {
            
            //HB 2 MARCH
        appdelegate.selectedLatitude = 0.0
        appdelegate.selectedLongitude = 0.0
        childVc?.selectedPlaceDict = nil
            
            //hb 2 mar
        timerforPinDropping?.invalidate()
        if timerforPinDropping != nil
        {
        timerforPinDropping = nil
        }
        indexforDropPin = 0
            
            
        childVc?.isSearchingPlaces = false

        self.downTheMenuIfNeeded()
            
        childVc!.tblsearch.isHidden = true
            
        childVc?.txtSearchbar.text =  (childVc!.placesArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "description") as? String
            
        childVc?.searchView.isHidden = true
            
//    childVc?.tblsearch.layer.borderColor = UIColor.lightGray.cgColor
            
//    childVc?.tblsearch.layer.borderWidth = 1.0
            
    childVc?.selectedPlaceDict =  (childVc?.placesArray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
    self.searchLatitudeandLongitudeFromAddress()
            
    print("check dict is \(childVc?.selectedPlaceDict)")

        }
      else  if tableView == childVc?.tblPeople
        {
            var user_blocked_by :Int = 0
                  let myIdStr :String = "\(self.savedataInstance.id!)"
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
            
            
            
           print("came in selection of people and returned by me ")
            
        print("OPEN PROFILE SCREEN here for searched people people array here  inmain child")
        profileChildVc?.view.isHidden = false
        profileChildVc?.isOtherUserProfile = true
        profileChildVc?.otherUserId  = peopleArray[indexPath.row].user_id as! Int
        profileChildVc?.setUpProfileDetails()
            
        profileChildVc?.selectedPeopleObj = peopleArray[indexPath.row]
            
//            frdews profile child.messagesobj
//            selectedPeopleObj
            return
        }
        else if tableView == messageHistoryChildVc?.tblMessagesHistory
        {
            print("table message history selected")
            print("user selected is \(messageHistoryChildVc?.messageHistoryArray[indexPath.row].from_name)")
            
            editmessageChildVc?.view.isHidden = false
                        
            if "\(messageHistoryChildVc?.messageHistoryArray[indexPath.row].from_id ?? "")" == "\(savedataInstance.id!)"
            {
                editmessageChildVc? .selectedPeopleObj = PeopleList.init(
                    user_blocked_by:  nil,
                    user_blocked_id:  nil,
                    block_id: nil,
                    user_1: nil,
        user_2: nil,
        device_token: nil,
        initiate_id:nil,
        address: nil,
        city: nil,
        country: nil,
        distance: nil,
        email: nil,
        fav_cocktail: nil,
        fav_drink: nil,
        fav_spirit: nil,
        follow_by: nil,
        follow_to: nil,
        follower: nil,
        following: nil,
        my_status: nil,
        name: nil,
        phone: messageHistoryChildVc?.messageHistoryArray[indexPath.row].to_name,
        profile_image: messageHistoryChildVc?.messageHistoryArray[indexPath.row].to_profileImage,
        public_user: nil,
        requested: nil,
        role: nil,
        state: nil,
        user_id: messageHistoryChildVc?.messageHistoryArray[indexPath.row].to_id,
        username: messageHistoryChildVc?.messageHistoryArray[indexPath.row].to_name,
        user_latitude: nil,
        user_longitude: nil,
        visible_bar: nil,
        visible_for: nil,
        visibility_status: nil,
        person_status: nil)
            }
            else
            {
        editmessageChildVc?.selectedPeopleObj = PeopleList.init(
            user_blocked_by:  nil,
            user_blocked_id:  nil,
                    block_id: nil,
                    user_1: nil,
                    user_2: nil,
                    device_token: nil,
                    initiate_id:nil,
                    address: nil,
                    city: nil,
                    country: nil,
                    distance: nil,
                    email: nil,
                    fav_cocktail: nil,
                    fav_drink: nil,
                    fav_spirit: nil,
                    follow_by: nil,
                    follow_to: nil,
                    follower: nil,
                    following: nil,
                    my_status:nil,
                    name: messageHistoryChildVc?.messageHistoryArray[indexPath.row].from_name,
                    phone: nil,
                    profile_image: messageHistoryChildVc?.messageHistoryArray[indexPath.row].from_profileImage,
                    public_user:nil,
                    requested: nil,
                    role: nil,
                    state: nil,
                    user_id: messageHistoryChildVc?.messageHistoryArray[indexPath.row].from_id,
                    username: messageHistoryChildVc?.messageHistoryArray[indexPath.row].from_name,
                    user_latitude: nil,
                    user_longitude: nil,
                    visible_bar: nil,
                    visible_for: nil,
                    visibility_status: nil,
                    person_status: nil)
            }
            
            editmessageChildVc?.isCreatingNewMessage = false
            
            editmessageChildVc?.loadUI()
//        editmessageChildVc?.txtMessageonEditMessage.becomeFirstResponder()
//            if messageHistoryChildVc?.messageHistoryArray
        }
        //ONLY FOR SELECTING BARS AND STORES
        
        //HB 2 MAR
//        else if (tableView == childVc?.tblsearch)
//        {
//            if childVc?.searchType == "bar"
//            {
//                self.getBarsDetailsApi(index: indexPath.row, isSearchEnabled: true)
//
//            }
//            else if childVc?.searchType == "store"
//            {
//                self.getStoresDetailsApi(index: indexPath.row, isSearchEnabled: true)
//            }
//            else if childVc?.searchType == "people"
//            {
//            print("OPEN PROFILE SCREEN here for searched people searchedpeoplearray inmain child")
////                de3s
//                profileChildVc?.view.isHidden = false
//                profileChildVc?.isOtherUserProfile = true
//                profileChildVc?.otherUserId  = childVc?.searchedpeopleArray[indexPath.row].user_id as! Int
//                      profileChildVc?.setUpProfileDetails()
//
//                profileChildVc?.selectedPeopleObj = childVc?.searchedpeopleArray[indexPath.row]
//            }
//
//        }
    }
        
    func getStoreListCell (indexPath:IndexPath , collectionView : UICollectionView) -> UICollectionViewCell
    {
         
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarsListCell", for: indexPath) as? BarsListCell
         
         if indexPath.item == selectedStore {
             
             cell?.contentView.layer.borderColor = UIColor.init(red: 163/255.0, green: 201/255.0, blue: 183/255.0, alpha: 1.0).cgColor
             
             cell?.contentView.layer.borderWidth = 3.0
             
         }
         else{
             cell?.contentView.layer.borderColor = UIColor.clear.cgColor
                            
             cell?.contentView.layer.borderWidth = 0.0
             
         }
             
     cell?.lblBarName.text = (storeListArray[indexPath.item].store_name as! String).uppercased()
             
     let distance = storeListArray[indexPath.item].distance as! Double
             
     cell!.lblDistanceandDollar.text = String(format: "%.2f mi", distance)
    
     var imgStr: String = Constant.imageBaseUrl + "\(storeListArray[indexPath.item].store_image!)"
        
     imgStr = RandomObjects.geturlEncodedString(string: imgStr)

     cell?.imgViewBar.sd_imageIndicator = SDWebImageActivityIndicator.gray
     
     cell?.imgViewBar.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "loadingbarimages"))

     return cell!
     }
    
    func getBarListCell (indexPath:IndexPath , collectionView : UICollectionView) -> UICollectionViewCell
    {
         
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarsListCell", for: indexPath) as? BarsListCell
         
         if indexPath.item == selectedBar {
             
             cell?.contentView.layer.borderColor = UIColor.init(red: 163/255.0, green: 201/255.0, blue: 183/255.0, alpha: 1.0).cgColor
             
             cell?.contentView.layer.borderWidth = 3.0
             
         }
         else{
             cell?.contentView.layer.borderColor = UIColor.clear.cgColor
                            
             cell?.contentView.layer.borderWidth = 0.0
             
         }
             
     cell?.lblBarName.text = (barListArray[indexPath.item].bar_name as! String).uppercased()
             
     let distance = barListArray[indexPath.item].distance as! Double
             
     
     let dollar = barListArray[indexPath.item].dollars as! Int
     
     var dollarStr = ""
     if dollar == 0 {
         dollarStr = ""
     }
     else if dollar == 1{
         dollarStr = "$"
     }
     else if dollar == 2{
         dollarStr = "$$"
     }
     else if dollar == 3{
         dollarStr = "$$$"
     }
     
     if dollarStr == ""{
     cell!.lblDistanceandDollar.text = String(format: "%.2f mi", distance)
     }
     else{
    cell!.lblDistanceandDollar.text =      "\(dollarStr)" + "  " + String(format: "%.2f mi", distance)
     }
     
     
        var imgStr: String = Constant.imageBaseUrl + "\(barListArray[indexPath.item].bar_image!)"
        
        print("bar image is \("\(barListArray[indexPath.item].bar_image!)")")
        print("indexpath  is \(indexPath.item)")
        print("full url is \(imgStr)")
        imgStr = RandomObjects.geturlEncodedString(string: imgStr)

     
    cell?.imgViewBar.contentMode = .scaleToFill
        
     cell?.imgViewBar.sd_imageIndicator = SDWebImageActivityIndicator.gray
     
     cell?.imgViewBar.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: "loadingbarimages"))
     return cell!
     }
    
    func getPeopleDetailCell (indexPath:IndexPath , tableView : UITableView) -> UITableViewCell
       {
               let cell : BarDetailsCell = tableView.dequeueReusableCell(withIdentifier: "BarDetailsCell") as! BarDetailsCell
        return cell
    }

    func checkSpecialInBars() ->(String)
    {
        let mainTodayEventArray : NSArray = barDetailsObj?.todayEvent as? NSArray ?? []
        
        var mjPredicate = NSPredicate(format: "event_category contains[c] %@", "Mj Promotion")
        var mjArray : Any?
        
        mjArray = mainTodayEventArray.filtered(using: mjPredicate)
        
        if (mjArray as? NSArray)?.count ?? 0 > 0
        {
        print("got mj count and returned")
            
            return "\(((mjArray as? NSArray)?.object(at: 0) as! NSDictionary)["event_desc"] ?? "")"

        }
        
        mjPredicate = NSPredicate(format: "event_category contains[c] %@", "Drink Special")
        
        mjArray = mainTodayEventArray.filtered(using: mjPredicate)
        
        if (mjArray as? NSArray)?.count ?? 0 > 0
        {
        print("Drink Special count and returned")
            
            return "\(((mjArray as? NSArray)?.object(at: 0) as! NSDictionary)["event_desc"] ?? "")"
            
        }
        
        mjPredicate = NSPredicate(format: "event_category contains[c] %@", "Food & Drink Special")
              
              mjArray = mainTodayEventArray.filtered(using: mjPredicate)
              
              if (mjArray as? NSArray)?.count ?? 0 > 0
              {
                  print("Food & Drink Special count and returned")
                return "\(((mjArray as? NSArray)?.object(at: 0) as! NSDictionary)["event_desc"] ?? "")"

              }
        
        
        mjPredicate = NSPredicate(format: "event_category contains[c] %@", "Event")
        
        mjArray = mainTodayEventArray.filtered(using: mjPredicate)
        
        if (mjArray as? NSArray)?.count ?? 0 > 0
        {
            print("Event count and returned")
            return "\(((mjArray as? NSArray)?.object(at: 0) as! NSDictionary)["event_desc"] ?? "")"

        }
                  
    return ""
    }
    
    
    
    func getBarsDetailCell (indexPath:IndexPath , tableView : UITableView) -> UITableViewCell
    {
            let cell : BarDetailsCell = tableView.dequeueReusableCell(withIdentifier: "BarDetailsCell") as! BarDetailsCell
                
            let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(gesture:)))
                swipeGestureLeft.direction = .left
                
            let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(gesture:)))
                swipeGestureRight.direction = .right
        cell.contentView.addGestureRecognizer(swipeGestureLeft)
        cell.contentView.addGestureRecognizer(swipeGestureRight)
                
            cell.selectionStyle = .none

            //LOADING BAR DETAILS >
            if barDetailsObj != nil
            {
              let strSpecial =   self.checkSpecialInBars()
                
                cell.lblBarName.text = (barDetailsObj?.bar_name as! String).uppercased()
                
                print(strSpecial)
             
                if strSpecial.isEmpty == true
                {                      cell.lblEmptySpecial.isHidden = true
                    cell.lblEmptySpecial.text = ""
                }
                else
                {
                cell.lblEmptySpecial.isHidden = false
                cell.lblEmptySpecial.text = "SPECIAL :-\(strSpecial)"
                }
                
//                lblline.ishi
                
                cell.txtBarAddress.text = (barDetailsObj?.bar_street_address as! String)
                
                if RandomObjects.checkValueisNilorNull(value: barDetailsObj?.owner_phone) == false
                {
                cell.txtBarPhone.text = (barDetailsObj?.owner_phone as! String)
                    
                cell.btnPhoneBars.tag = indexPath.row
                    
                cell.btnPhoneBars.addTarget(self, action: #selector(callBarOwnerAction(_:)), for: .touchUpInside)
                    
                }
                else
                {
                     cell.txtBarPhone.text = ""
                }
                
    //            show address
    //            show phone
                
//                cell.txtBarDescriptionFull.text = (barDetailsObj?.bar_desc as! String)
                var storetimimgString : String  = (barDetailsObj?.bar_timing as! String).replacingOccurrences(of: "From: ", with: "")
                storetimimgString =  (storetimimgString).replacingOccurrences(of: "from: ", with: "")
                             
                             
                             cell.lblTime.text = storetimimgString
//                cell.lblTime.text = (barDetailsObj?.bar_timing as! String)
                
                let distance = barDetailsObj?.miles as! Double
                               
                var dollar: Int = 0
                if   RandomObjects.checkValueisNilorNull(value: barDetailsObj?.dollar) == true
                {
                }
                else
                {
                    dollar = barDetailsObj?.dollar as! Int
                }
                var dollarStr = ""
                if dollar == 0 {
                    dollarStr = ""
                }
                else if dollar == 1{
                    dollarStr = "$"
                }
                else if dollar == 2{
                    dollarStr = "$$"
                }
                else if dollar == 3{
                    dollarStr = "$$$"
                }
                       
                if dollarStr == ""{
                    cell.lblDistanceandDollars.text = String(format: "%.2f mi", distance)
                }
                else{
                cell.lblDistanceandDollars.text =      "\(dollarStr)" + "  " + String(format: "%.2f mi", distance)
                }
             cell.collectionViewBarImages.register(UINib.init(nibName: "BarImagesCell", bundle: nil), forCellWithReuseIdentifier: "BarImagesCell")
                
                cell.collectionViewBarImages.delegate = self
                cell.collectionViewBarImages.dataSource = self
                
                cell.collectionViewBarImages.reloadData()
                imgesChildVcForbarandStore?.collectionViewBarImagesNew.reloadData()
                
                //features work started from here
                if (barDetailsObj?.features as! NSArray).count > 0
                {

                let arr : NSArray = (barDetailsObj?.features as! NSArray)
                var mainFeaturesStr : NSString = ""
                for i in 0..<arr.count {
                if mainFeaturesStr == ""
                {
                    mainFeaturesStr = "                             \(arr.object(at: i) as! NSString)" as NSString
                }
                else
                {
                    mainFeaturesStr = NSString.init(format: "%@, %@", mainFeaturesStr,(arr.object(at: i) as! NSString))
                }
                }

                    cell.lblFeatures.text =  mainFeaturesStr as String

                    print(cell.lblFeatures.text!)
                    cell.lblFeaturesEmpty.text =  "FEATURES :"
                    cell.lblFeaturesTopConstraint.constant = 7
                }
                else{
                    cell.lblFeatures.text =  ""
                    cell.lblFeaturesEmpty.text =  ""
                    cell.lblFeaturesTopConstraint.constant = 0
                }
                
                cell.lblWebsiteLink.text = self.getWebsiteLinkforBar()

    if (barDetailsObj?.bar_team as! NSArray).count > 0
    {
    cell.lblWhoWorkHere.text =  "EMPLOYEES :"
    cell.collectionViewWorkHereHeightConstraint.constant = 180
//        (cell.collectionViewWorkHere.frame.size.width / 3 + 40)
    }
    else
    {
    cell.lblWhoWorkHere.text =  ""
    cell.collectionViewWorkHereHeightConstraint.constant = 0.0
    }
                
                //HERE
                
                if savedataInstance.getUserDetails() == nil
                {
                    cell.btnFollowUnfollowBar.setTitle("Follow Bar", for: .normal)
                    
                }
                else
                {
                    
                    //                    print("check value \(storeDetailsObj?.store_follow)")
                    
                    //            print("check is it \(storeDetailsObj?.store_follow  == 0)")
                    
                    if "\(barDetailsObj?.bar_follow ?? "0")" == "0"
                    {
                        cell.btnFollowUnfollowBar.setTitle("Follow Bar", for: .normal)
                        cell.btnFollowUnfollowBar.layer.borderColor = UIColor.clear.cgColor
                        cell.btnFollowUnfollowBar.layer.borderWidth = 0.0
                        cell.btnFollowUnfollowBar.isUserInteractionEnabled = true
                        cell.btnFollowUnfollowBar.setTitle("Follow Bar", for: .normal)
                        cell.btnFollowUnfollowBar.backgroundColor =  UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)
                        cell.btnFollowUnfollowBar.setTitleColor(UIColor.white, for: .normal)
                        
                    }
                    else
                    {
                        cell.btnFollowUnfollowBar.setTitle("Unfollow Bar", for: .normal)
                        cell.btnFollowUnfollowBar.isUserInteractionEnabled = true
                        cell.btnFollowUnfollowBar.backgroundColor =  UIColor.white
                        cell.btnFollowUnfollowBar.setTitleColor(UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0), for: .normal)
                        
                        cell.btnFollowUnfollowBar.layer.borderColor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0).cgColor
                        cell.btnFollowUnfollowBar.layer.borderWidth = 2.0
                        
                    }
                    //                    if storedetail
                    
                }
                
                cell.btnFollowUnfollowBar.addTarget(self, action: #selector(followUnfollowBarAction(_:)), for: .touchUpInside)
                
                
                //HERE
                
                
                
                
  cell.collectionViewWorkHere.register(UINib.init(nibName: "WorkhereBarCell", bundle: nil), forCellWithReuseIdentifier: "WorkhereBarCell")
                
    cell.collectionViewWorkHere.delegate = self
    cell.collectionViewWorkHere.dataSource = self
    cell.collectionViewWorkHere.reloadData()
                                                                
        cell.btnGetDirections.addTarget(self, action: #selector(getDirections(_:)), for: .touchUpInside)
                
        cell.btnGetDirectionsUpside.addTarget(self, action: #selector(getDirections(_:)), for: .touchUpInside)
                
        cell.btnUber.tag = indexPath.row
        cell.btnUber.addTarget(self, action: #selector(setUpUberRideforBarDetails(_:)), for: .touchUpInside)

        self.getTodayEventTableContentHeight(cell: cell)
        self.getUpcomingEventTableContentHeight(cell: cell)
                
            }
            
            return cell
        }
    
    @objc func callStoreOwnerAction(_ sender: UIButton)
        {

            if RandomObjects.checkValueisNilorNull(value: storeDetailsObj?.owner_phone) == false
            {
                
                var urlStr : String = "\(storeDetailsObj!.owner_phone!)"
                
    //            if urlStr.contains("("){
    //                urlStr = urlStr.replacingOccurrences(of: "(", with: "+(")
    //            }
    //            if urlStr.contains("("){
    //                urlStr = urlStr.replacingOccurrences(of: "(", with: "")
    //            }
                
                if let phoneCallURL = URL(string: "tel://\(urlStr)") {
                  let application:UIApplication = UIApplication.shared
                  if (application.canOpenURL(phoneCallURL)) {
                      application.open(phoneCallURL, options: [:], completionHandler: nil)
                  }
                  else
                  {
                    
                    }
                }
                
                
    //            urlStr =  "234888574493"
                
    //            let url : URL = URL.init(string: urlStr)!

    //            if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
    //
    //              let application:UIApplication = UIApplication.shared
    //              if (application.canOpenURL(phoneCallURL)) {
    //                  application.open(phoneCallURL, options: [:], completionHandler: nil)
    //              }
    //            }
                
                
    //            UIApplication.sharedApplication().openURL(NSURL(scheme: NSString(), host: "tel://", path: busPhone)!)
    //
    //
    //
    //          if UIApplication.shared.canOpenURL(url) {
    //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //                //If you want handle the completion block than
    //                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
    //                     print("Open url : \(success)")
    //                })
    //            }
                
            }

        }
    
    
    @objc func callBarOwnerAction(_ sender: UIButton)
    {

        if RandomObjects.checkValueisNilorNull(value: barDetailsObj?.owner_phone) == false
        {
            
            var urlStr : String = "\(barDetailsObj!.owner_phone!)"
            
//            if urlStr.contains("("){
//                urlStr = urlStr.replacingOccurrences(of: "(", with: "+(")
//            }
//            if urlStr.contains("("){
//                urlStr = urlStr.replacingOccurrences(of: "(", with: "")
//            }
            
            if let phoneCallURL = URL(string: "tel://\(urlStr)") {
              let application:UIApplication = UIApplication.shared
              if (application.canOpenURL(phoneCallURL)) {
                  application.open(phoneCallURL, options: [:], completionHandler: nil)
              }
              else
              {
                
                }
            }
            
            
//            urlStr =  "234888574493"
            
//            let url : URL = URL.init(string: urlStr)!

//            if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
//
//              let application:UIApplication = UIApplication.shared
//              if (application.canOpenURL(phoneCallURL)) {
//                  application.open(phoneCallURL, options: [:], completionHandler: nil)
//              }
//            }
            
            
//            UIApplication.sharedApplication().openURL(NSURL(scheme: NSString(), host: "tel://", path: busPhone)!)
//
//
//
//          if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                //If you want handle the completion block than
//                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
//                     print("Open url : \(success)")
//                })
//            }
            
        }

    }
    
//        if RandomObjects.checkValueisNilorNull(value: barDetailsObj?.owner_phone) == false
//
//        {
//
//            if UIApplication.shared.canOpenURL(URL.init(string: "\(barDetailsObj?.owner_phone!)") == true,
//            {
//                UIApplication.shared.openURL(URL.init(string: "\(barDetailsObj?.owner_phone!)")!)
//            }
//        }
//
//    }

        
    


    
    func getTodayEventTableContentHeight(cell :BarDetailsCell)
    {
            if (barDetailsObj?.todayEvent as! NSArray).count > 0
            {
                print("coming events count is here \((barDetailsObj?.todayEvent as! NSArray).count)")
            cell.tblTodayEvents.register(UINib.init(nibName: "BarsEventsCell", bundle: nil), forCellReuseIdentifier: "BarsEventsCell")
                            
            cell.tblTodayEvents.dataSource = self
            cell.tblTodayEvents.delegate = self
            cell.lblTodayEvents.text = "TODAY EVENTS :"
                       
            var contentHeight : CGFloat = 0.0
                
                
            for i in 0..<(barDetailsObj?.todayEvent as! NSArray).count{
                
            let dict : NSDictionary =  ((barDetailsObj?.todayEvent as! NSArray).object(at: i) as! NSDictionary)
                
                var  eventNameHeight: CGFloat? = 0.0
                var  descriptionHeight: CGFloat? = 0.0
                var  timeHeight: CGFloat? = 0.0
                var  foodPriceHeight: CGFloat? = 0.0
                var  drinKPriceHeight: CGFloat? = 0.0

                if (dict.value(forKey: "event_type") as! String) == "Other"{
                eventNameHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "other_type") as! String).uppercased(), width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)!)
                    }
                else
                    {
                eventNameHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "event_type") as! String).uppercased(), width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)!)
                }
                
                if eventNameHeight != 0.0
                {
                //for top and bottom of cell
                    eventNameHeight = eventNameHeight! + 5.0
                }
        
                
                if dict.value(forKey: "start_time") != nil
                {
                let strTime : NSString = NSString.init(format: "%@ to %@",((dict.value(forKey: "start_time") as! NSString) as NSString),((dict.value(forKey: "end_time") as! NSString) as NSString) )
                                  
                timeHeight  = RandomObjects.estimatedLabelHeight(text: strTime as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                    
                    if timeHeight != 0.0
                    {
                    //for top and bottom of cell
                        timeHeight = timeHeight! + 5.0
                    }
                                  
                }
                
               
                //description height calculated
                descriptionHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "event_desc") as? String)!, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue", size: 12.0)!)
                
                if descriptionHeight != 0.0
                {
                                 //for top and bottom of cell
                    descriptionHeight = descriptionHeight! + 5.0
                }
                
                
                
               
              
                if (dict["food_price"] as? String) != nil
                {
                let food_price : NSString = NSString.init(format: "Appetizers($): %@", dict["food_price"] as! String)
                    
                foodPriceHeight =  RandomObjects.estimatedLabelHeight(text: food_price as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                    
                    if foodPriceHeight != 0.0
                    {
                                                  //for top and bottom of cell
                    foodPriceHeight = foodPriceHeight! + 5.0
                    }
                
                }
                
                if (dict["drink_price"] as? String) != nil {
                    //empty aae
                    let drink_price : NSString = NSString.init(format: "Mix Drink($):  %@", dict["drink_price"] as! String)
                    
                    drinKPriceHeight =  RandomObjects.estimatedLabelHeight(text: drink_price as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                    
                    
                    if drinKPriceHeight != 0.0
                    {
                    drinKPriceHeight = drinKPriceHeight! + 10.0
                    }
                    }
                
                var totalHeight : CGFloat = eventNameHeight! + descriptionHeight! + timeHeight! + foodPriceHeight! + drinKPriceHeight!
                
                if totalHeight < 137.0
                {
                    totalHeight = 137.0
                }
                else{
                     totalHeight = totalHeight + 40
                }
                                                
                contentHeight = contentHeight + totalHeight

            }

                
        cell.tblTodayEvents.estimatedRowHeight = 140
        cell.tblTodayEvents.rowHeight = UITableView.automaticDimension

        cell.tblTodayEvents.isScrollEnabled = false
        cell.tblTodayEvents.reloadData()

        if contentHeight > cell.tblTodayEvents.contentSize.height
        {
        cell.tblTodayEventsHeightConstraint.constant = contentHeight
        }
        else
        {
        cell.tblTodayEventsHeightConstraint.constant = cell.tblTodayEvents.contentSize.height
        }
                
//        print("total Height Calculated is TODAY EVENT \(contentHeight)")
//        print("TODAY EVENT total Height content size is here \(cell.tblTodayEvents.contentSize.height)")
        

              //  }
            //cell.contentView.layoutIfNeeded()

            }
            else
            {
                cell.tblTodayEventsHeightConstraint.constant = 0
            cell.lblTodayEvents.text = ""
            }

    }
    
    
    
    func getUpcomingEventTableContentHeight(cell :BarDetailsCell)
    {
            if (barDetailsObj?.comingEvents as! NSArray).count > 0
            {
//                print("coming events count is here \((barDetailsObj?.comingEvents as! NSArray).count)")
            cell.tblUpcomingEvents.register(UINib.init(nibName: "BarsEventsCell", bundle: nil), forCellReuseIdentifier: "BarsEventsCell")
                            
            cell.tblUpcomingEvents.dataSource = self
            cell.tblUpcomingEvents.delegate = self
            cell.lblUpcomingEvents.text = "UPCOMING EVENTS :"
                       
                var contentHeight : CGFloat = 0.0
                
                
            for i in 0..<(barDetailsObj?.comingEvents as! NSArray).count{
                
            let dict : NSDictionary =  ((barDetailsObj?.comingEvents as! NSArray).object(at: i) as! NSDictionary)
                
                var  eventNameHeight: CGFloat? = 0.0
                var  descriptionHeight: CGFloat? = 0.0
                var  timeHeight: CGFloat? = 0.0
                var  foodPriceHeight: CGFloat? = 0.0
                var  drinKPriceHeight: CGFloat? = 0.0

                if (dict.value(forKey: "event_type") as! String) == "Other"{
                eventNameHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "other_type") as! String).uppercased(), width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)!)
                    }
                else
                    {
                eventNameHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "event_type") as! String).uppercased(), width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)!)
                }
                
                if eventNameHeight != 0.0
                {
                //for top and bottom of cell
                    eventNameHeight = eventNameHeight! + 5.0
                }
        
                
                if dict.value(forKey: "start_time") != nil
                {
                let strTime : NSString = NSString.init(format: "%@ to %@",((dict.value(forKey: "start_time") as! NSString) as NSString),((dict.value(forKey: "end_time") as! NSString) as NSString) )
                                  
                timeHeight  = RandomObjects.estimatedLabelHeight(text: strTime as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                    
                    if timeHeight != 0.0
                    {
                    //for top and bottom of cell
                        timeHeight = timeHeight! + 5.0
                    }
                                  
                }
                
               
                //description height calculated
                descriptionHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "event_desc") as? String)!, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue", size: 12.0)!)
                
                if descriptionHeight != 0.0
                {
                                 //for top and bottom of cell
                    descriptionHeight = descriptionHeight! + 5.0
                }
                
                
                
               
              
                if (dict["food_price"] as? String) != nil
                {
                let food_price : NSString = NSString.init(format: "Appetizers($): %@", dict["food_price"] as! String)
                    
                foodPriceHeight =  RandomObjects.estimatedLabelHeight(text: food_price as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                    
                    if foodPriceHeight != 0.0
                    {
                                                  //for top and bottom of cell
                    foodPriceHeight = foodPriceHeight! + 5.0
                    }
                
                }
                
                if (dict["drink_price"] as? String) != nil {
                    //empty aae
                    let drink_price : NSString = NSString.init(format: "Mix Drink($):  %@", dict["drink_price"] as! String)
                    
                    drinKPriceHeight =  RandomObjects.estimatedLabelHeight(text: drink_price as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                    
                    
                    if drinKPriceHeight != 0.0
                    {
                    drinKPriceHeight = drinKPriceHeight! + 10.0
                    }
                    }
                
                var totalHeight : CGFloat = eventNameHeight! + descriptionHeight! + timeHeight! + foodPriceHeight! + drinKPriceHeight!
                
                if totalHeight < 137.0
                {
                    totalHeight = 137.0
                }
                else{
                     totalHeight = totalHeight + 40
                }
                                                
                contentHeight = contentHeight + totalHeight

            }

                
        cell.tblUpcomingEvents.estimatedRowHeight = 140
        cell.tblUpcomingEvents.rowHeight = UITableView.automaticDimension

        cell.tblUpcomingEvents.isScrollEnabled = false
        cell.tblUpcomingEvents.reloadData()

        if contentHeight > cell.tblUpcomingEvents.contentSize.height
        {
        cell.tblUpcomingEventsHeightConstraint.constant = contentHeight
        }
        else
        {
        cell.tblUpcomingEventsHeightConstraint.constant = cell.tblUpcomingEvents.contentSize.height
        }
                
//        print("total Height Calculated is \(contentHeight)")
//        print("total Height content size is here \(cell.tblUpcomingEvents.contentSize.height)")
        

              //  }
            //cell.contentView.layoutIfNeeded()

            }
            else
            {
                cell.tblUpcomingEventsHeightConstraint.constant = 0
            cell.lblUpcomingEvents.text = ""
            }

    }
    
    
    
    @objc  func followUnfollowStoreTeamAction(_ sender: UIButton)
    {
        if savedataInstance.getUserDetails() == nil
        {
            signupChildVc?.view.isHidden = false
            signupChildVc?.getAllCountriesAndStatesAPI()
            SVProgressHUD.showError(withStatus: "Please login or sign up first to follow store team.")
            
        }
        else
        {
            //
            let params = NSMutableDictionary()
            params.setValue(savedataInstance.id, forKey: "user_id")
            
            if sender.currentTitle == "Follow"
            {
                params.setValue(1, forKey: "followStatus")
            }
            else if sender.currentTitle == "Follower"
            {
                params.setValue(0, forKey: "followStatus")
            }
            
            params.setValue(storeDetailsObj!.id, forKey: "store_id")
            
            params.setValue(((storeDetailsObj?.store_team as! NSArray).object(at: sender.tag) as? NSDictionary)!.value(forKey: "team_id"), forKey: "follow_id")
            
            params.setValue(((storeDetailsObj?.store_team as! NSArray).object(at: sender.tag) as? NSDictionary)!.value(forKey: "device_token"), forKey: "device_token")
       

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
                ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.followUnFollowStoreTeamApi as NSString,currentView: self.view)
            }
            
            //
        }
        
    }
    
    @objc func followUnfollowBarTeamAction(_ sender: UIButton)
    {
        if savedataInstance.getUserDetails() == nil
        {
            signupChildVc?.view.isHidden = false
            signupChildVc?.getAllCountriesAndStatesAPI()
            SVProgressHUD.showError(withStatus: "Please login or register first to follow bar team.")
            
        }
        else
        {
            //
            let params = NSMutableDictionary()
            params.setValue(savedataInstance.id, forKey: "user_id")
            
            if sender.currentTitle == "Follow"
            {
                params.setValue(1, forKey: "followStatus")
            }
            else if sender.currentTitle == "Follower"
            {
                params.setValue(0, forKey: "followStatus")
            }
            
            params.setValue(barDetailsObj!.id, forKey: "bar_id")
            
            params.setValue(((barDetailsObj?.bar_team as! NSArray).object(at: sender.tag) as? NSDictionary)!.value(forKey: "team_id"), forKey: "follow_id")
            
            params.setValue(((barDetailsObj?.bar_team as! NSArray).object(at: sender.tag) as? NSDictionary)!.value(forKey: "device_token"), forKey: "device_token")
            
            
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
                ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.followUnFollowBarTeamApi as NSString,currentView: self.view)
            }
            
            //
        }
        
    }
    
    @objc  func followUnfollowBarAction(_ sender: UIButton)
    {
        if savedataInstance.getUserDetails() == nil
        {
            signupChildVc?.view.isHidden = false
            signupChildVc?.getAllCountriesAndStatesAPI()
            SVProgressHUD.showError(withStatus: "Please login or register first to follow bar.")
        }
        else
        {
                        
            let params = NSMutableDictionary()
            params.setValue(savedataInstance.id, forKey: "user_id")
            if sender.currentTitle == "Follow Bar"
            {
                params.setValue(1, forKey: "followStatus")
            }
            else if sender.currentTitle == "Unfollow Bar"
            {
                params.setValue(0, forKey: "followStatus")
            }
            
            params.setValue(barDetailsObj!.id, forKey: "bar_id")
            
            print("params for FOLLOW bar API api \(params)")
            
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
                ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.followUnFollowBarApi as NSString,currentView: self.view)
            }
            //
        }
        
    }
    
    @objc  func followUnfollowStoreAction(_ sender: UIButton)
    {
        if savedataInstance.getUserDetails() == nil
        {
//            SVProgressHUD.showError(withStatus: "Please login first to follow store.")
            signupChildVc?.view.isHidden = false
            signupChildVc?.getAllCountriesAndStatesAPI()
            SVProgressHUD.showError(withStatus: "Please login or register first to follow store.")
        }
        else
        {
        
            
            //
            
                let params = NSMutableDictionary()
                params.setValue(savedataInstance.id, forKey: "user_id")
                if sender.currentTitle == "Follow Store"
                {
                    params.setValue(1, forKey: "followStatus")
                }
                else if sender.currentTitle == "Unfollow Store"
                {
                    params.setValue(0, forKey: "followStatus")
                }
            params.setValue(storeDetailsObj!.id, forKey: "store_id")
            
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
                    ApiManager.sharedManager.postDataOnserver(params: params,postUrl:Constant.followUnFollowStoreApi as NSString,currentView: self.view)
                }
           
            //
        }
        
    }
    
    
    func getStoreDetailCell (indexPath:IndexPath , tableView : UITableView) -> UITableViewCell
    {
            let cell : StoreDetailCell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailCell") as! StoreDetailCell
                
                let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(gesture:)))
                swipeGestureLeft.direction = .left
                
                let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(gesture:)))
                swipeGestureRight.direction = .right
            cell.contentView.addGestureRecognizer(swipeGestureLeft)
            cell.contentView.addGestureRecognizer(swipeGestureRight)
                
            cell.selectionStyle = .none

            //LOADING BAR DETAILS >
            if storeDetailsObj != nil{
                cell.lblBarName.text = (storeDetailsObj?.store_name as! String).uppercased()
                                
                cell.txtBarAddress.text = (storeDetailsObj?.store_street_address as! String)
                                
    //            show address
    //            show phone
                
                cell.txtBarDescriptionFull.text = (storeDetailsObj?.store_desc as! String)
                
                var storetimimgString : String  = (storeDetailsObj?.store_timing as! String).replacingOccurrences(of: "From: ", with: "")
                storetimimgString =  (storetimimgString).replacingOccurrences(of: "from: ", with: "")
                
                
                cell.lblTime.text = storetimimgString
                
                let distance = storeDetailsObj?.miles as! Double
 
                cell.lblDistanceandDollars.text = String(format: "%.2f mi", distance)

             cell.collectionViewBarImages.register(UINib.init(nibName: "BarImagesCell", bundle: nil), forCellWithReuseIdentifier: "BarImagesCell")
                
                cell.collectionViewBarImages.delegate = self
                cell.collectionViewBarImages.dataSource = self
                
                cell.collectionViewBarImages.reloadData()
                imgesChildVcForbarandStore?.collectionViewBarImagesNew.reloadData()
                //features work started from here
                if (storeDetailsObj?.features as! NSArray).count > 0
                {

                let arr : NSArray = (storeDetailsObj?.features as! NSArray)
                var mainFeaturesStr : NSString = ""
                for i in 0..<arr.count {
                if mainFeaturesStr == ""
                {
                    mainFeaturesStr = "• \(arr.object(at: i) as! NSString)" as NSString
                }
                else
                {
                    mainFeaturesStr = NSString.init(format: "%@\n• %@", mainFeaturesStr,(arr.object(at: i) as! NSString))
                }
                }

                    cell.lblFeatures.text =  mainFeaturesStr as String

//                    print(cell.lblFeatures.text!)
                    cell.lblFeaturesEmpty.text =  "Features :"
                    cell.lblFeaturesTopConstraint.constant = 10
                }
                else{
                    cell.lblFeatures.text =  ""
                    cell.lblFeaturesEmpty.text =  ""
                    cell.lblFeaturesTopConstraint.constant = 0
                }
                
                //HERE ADDING STORE TEAM CELL
                
                
                
                if (storeDetailsObj?.store_team as! NSArray).count > 0
                  {
                  cell.lblWhoWorkHereStore.text =  "EMPLOYEES :"
                  cell.collectionViewWhoWorkHereStoreHeightConstraint.constant = 180
//                    (cell.collectionViewWhoWorkHereStore.frame.size.width / 3 + 80)
                  }
                  else
                  {
                  cell.lblWhoWorkHereStore.text =  ""
                  
                  cell.collectionViewWhoWorkHereStoreHeightConstraint.constant = 0.0

                  }
                
                
                
                
                if savedataInstance.getUserDetails() == nil
                {
                    cell.btnFollowUnfollowStore.setTitle("Follow Store", for: .normal)
                
                }
                else
                {
                    
//                    print("check value \(storeDetailsObj?.store_follow)")

//            print("check is it \(storeDetailsObj?.store_follow  == 0)")
                 
                    if "\(storeDetailsObj?.store_follow ?? "0")" == "0"
                    {
                        cell.btnFollowUnfollowStore.setTitle("Follow Store", for: .normal)
                        cell.btnFollowUnfollowStore.layer.borderColor = UIColor.clear.cgColor
                        cell.btnFollowUnfollowStore.layer.borderWidth = 0.0
                        cell.btnFollowUnfollowStore.isUserInteractionEnabled = true
                        cell.btnFollowUnfollowStore.setTitle("Follow Store", for: .normal)
                        cell.btnFollowUnfollowStore.backgroundColor =  UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0)
                        cell.btnFollowUnfollowStore.setTitleColor(UIColor.white, for: .normal)
                        
                    }
                    else
                    {
                        cell.btnFollowUnfollowStore.setTitle("Unfollow Store", for: .normal)
                        cell.btnFollowUnfollowStore.setTitle("Unfollow Store", for: .normal)
                        cell.btnFollowUnfollowStore.isUserInteractionEnabled = true
                        cell.btnFollowUnfollowStore.backgroundColor =  UIColor.white
                        cell.btnFollowUnfollowStore.setTitleColor(UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0), for: .normal)
                        
                        cell.btnFollowUnfollowStore.layer.borderColor = UIColor.init(red: 45/255.0, green: 95/255.0, blue: 131/255.0, alpha: 1.0).cgColor
                        cell.btnFollowUnfollowStore.layer.borderWidth = 2.0
                        
                        
                        
                        
                    }
//                    if storedetail
                    
                }
                
                cell.btnFollowUnfollowStore.addTarget(self, action: #selector(followUnfollowStoreAction(_:)), for: .touchUpInside)
                
                
                cell.collectionViewWhoWorkHereStore.register(UINib.init(nibName: "WorkhereStoreCell", bundle: nil), forCellWithReuseIdentifier: "WorkhereStoreCell")
                              
            cell.collectionViewWhoWorkHereStore.delegate = self
            cell.collectionViewWhoWorkHereStore.dataSource = self
            cell.collectionViewWhoWorkHereStore.reloadData()
                
                
        cell.lblDeliveryCharges.text = self.getDeliveryChargesTextToShow()
        cell.lblWebsiteLink.text = self.getWebsiteLinkforStore()
                
        print("website link is \(self.getWebsiteLinkforStore())")
        if RandomObjects.checkValueisNilorNull(value: storeDetailsObj?.owner_phone) == false
        {
            cell.txtStorePhone.text = (storeDetailsObj?.owner_phone as! String)
                    
            cell.btnPhoneStore.tag = indexPath.row
                    
            cell.btnPhoneStore.addTarget(self, action: #selector(callStoreOwnerAction(_:)), for: .touchUpInside)
                    
                }
                else
                {
                     cell.txtStorePhone.text = ""
                }
                
                
        cell.btnGetDirections.addTarget(self, action: #selector(getDirections(_:)), for: .touchUpInside)
                
        cell.btnUber.tag = indexPath.row
                
        cell.btnUber.addTarget(self, action: #selector(setUpUberRideforStoreDetails(_:)), for: .touchUpInside)
                
    //            cell.btnu.addTarget(self, action: #selector(getDirections(_:)), for: .touchUpInside)
                
                if (storeDetailsObj?.todayEvent as! NSArray).count > 0
                {
                cell.tblTodayEvents.register(UINib.init(nibName: "BarsEventsCell", bundle: nil), forCellReuseIdentifier: "BarsEventsCell")
                    
                cell.tblTodayEvents.dataSource = self
                cell.tblTodayEvents.delegate = self
                cell.lblTodayEvents.text = "TODAY EVENTS :"
                    
                cell.tblTodayEvents.estimatedRowHeight = 156
                cell.tblTodayEvents.isScrollEnabled = false
                cell.tblTodayEvents.reloadData()
                cell.tblTodayEventsHeightConstraint.constant = cell.tblTodayEvents.contentSize.height
    //                    CGFloat(148 * (barDetailsObj?.todayEvent as! NSArray).count)
                }
                else{
                    cell.tblTodayEventsHeightConstraint.constant = 0
                    cell.lblTodayEvents.text = ""
                }
                
                
                //upcoming events work
                
                if (storeDetailsObj?.comingEvents as! NSArray).count > 0
                {
//                    print("coming events count is here \((storeDetailsObj?.comingEvents as! NSArray).count)")
                cell.tblUpcomingEvents.register(UINib.init(nibName: "BarsEventsCell", bundle: nil), forCellReuseIdentifier: "BarsEventsCell")
                                
                cell.tblUpcomingEvents.dataSource = self
                cell.tblUpcomingEvents.delegate = self
                cell.lblUpcomingEvents.text = "UPCOMING EVENTS :"
                           
                var contentHeight : CGFloat = 0.0
                    
                    
                for i in 0..<(storeDetailsObj?.comingEvents as! NSArray).count{
                    
                let dict : NSDictionary =  ((storeDetailsObj?.comingEvents as! NSArray).object(at: i) as! NSDictionary)
                    
                    var  eventNameHeight: CGFloat? = 0.0
                    var  descriptionHeight: CGFloat? = 0.0
                    var  timeHeight: CGFloat? = 0.0
                    var  foodPriceHeight: CGFloat? = 0.0
                    var  drinKPriceHeight: CGFloat? = 0.0

                    if (dict.value(forKey: "event_type") as! String) == "Other"{
                    eventNameHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "other_type") as! String).uppercased(), width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)!)
                        }
                    else
                        {
                    eventNameHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "event_type") as! String).uppercased(), width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)!)
                    }
                    
                    if eventNameHeight != 0.0
                    {
                    //for top and bottom of cell
                        eventNameHeight = eventNameHeight! + 5.0
                    }
                    
                    if dict.value(forKey: "start_time") != nil
                    {
                    let strTime : NSString = NSString.init(format: "%@ to %@",((dict.value(forKey: "start_time") as! NSString) as NSString),((dict.value(forKey: "end_time") as! NSString) as NSString) )
                                      
                    timeHeight  = RandomObjects.estimatedLabelHeight(text: strTime as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                        
                        if timeHeight != 0.0
                        {
                        //for top and bottom of cell
                            timeHeight = timeHeight! + 5.0
                        }
                                      
                    }
                    
                   
                    //description height calculated
                    descriptionHeight =  RandomObjects.estimatedLabelHeight(text: (dict.value(forKey: "event_desc") as? String)!, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue", size: 12.0)!)
                    
                    if descriptionHeight != 0.0
                    {
                                     //for top and bottom of cell
                        descriptionHeight = descriptionHeight! + 5.0
                    }
                    
                    
                    
                   
                  
                    if (dict["food_price"] as? String) != nil
                    {
                    let food_price : NSString = NSString.init(format: "Appetizers($): %@", dict["food_price"] as! String)
                        
                    foodPriceHeight =  RandomObjects.estimatedLabelHeight(text: food_price as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                        
                        if foodPriceHeight != 0.0
                        {
                                                      //for top and bottom of cell
                        foodPriceHeight = foodPriceHeight! + 5.0
                        }
                    
                    }
                    
                    if (dict["drink_price"] as? String) != nil {
                        //empty aae
                        let drink_price : NSString = NSString.init(format: "Mix Drink($):  %@", dict["drink_price"] as! String)
                        
                        drinKPriceHeight =  RandomObjects.estimatedLabelHeight(text: drink_price as String, width: self.view.frame.size.width - 150.0, font: UIFont.init(name: "HelveticaNeue-Bold", size: 12.0)!)
                        
                        
                        if drinKPriceHeight != 0.0
                        {
                        drinKPriceHeight = drinKPriceHeight! + 10.0
                        }
                        }
                    
                    var totalHeight : CGFloat = eventNameHeight! + descriptionHeight! + timeHeight! + foodPriceHeight! + drinKPriceHeight!
                    
                    if totalHeight < 137.0
                    {
                        totalHeight = 137.0
                    }
                    else{
                         totalHeight = totalHeight + 40
                    }
                                                    
                    contentHeight = contentHeight + totalHeight

                }

                    
            cell.tblUpcomingEvents.estimatedRowHeight = 140
            cell.tblUpcomingEvents.rowHeight = UITableView.automaticDimension

            cell.tblUpcomingEvents.isScrollEnabled = false
            cell.tblUpcomingEvents.reloadData()

            if contentHeight > cell.tblUpcomingEvents.contentSize.height
            {
            cell.tblUpcomingEventsHeightConstraint.constant = contentHeight
            }
            else
            {
            cell.tblUpcomingEventsHeightConstraint.constant = cell.tblUpcomingEvents.contentSize.height
            }
                    
//            print("total Height Calculated is \(contentHeight)")
//            print("total Height content size is here \(cell.tblUpcomingEvents.contentSize.height)")

                  //  }
                //cell.contentView.layoutIfNeeded()

                }
                else
                {
            cell.tblUpcomingEventsHeightConstraint.constant = 0
                cell.lblUpcomingEvents.text = ""
                }
    ///features work till here
            }
            
            return cell
        }
    
    
    func getWebsiteLinkforBar() ->(String)
    {
        var deliveryStr : String = ""
          
                if  RandomObjects.checkValueisNilorNull(value: barDetailsObj?.bar_website) == false
                {
                    if (barDetailsObj?.bar_website  as! String ) == ""
                    {
                        return deliveryStr
                        //when comment is empty
        //                deliveryStr = "\(deliveryStr)"
                    }
                    else
                    {
                        deliveryStr = "\(barDetailsObj!.bar_website! as! String)"

                        //when comment have value
                        
                    }
                }
                else
                {
                    // if nil return value directly
                    return deliveryStr
                }
        
        return deliveryStr
        
    }
    
        func getWebsiteLinkforStore() ->(String)
        {
            var deliveryStr : String = ""
              
                    if  RandomObjects.checkValueisNilorNull(value: storeDetailsObj?.store_website) == false
                    {
                        if (storeDetailsObj?.store_website  as! String ) == ""
                        {
                            return deliveryStr
                            //when comment is empty
            //                deliveryStr = "\(deliveryStr)"
                        }
                        else
                        {
                            deliveryStr = "\(storeDetailsObj!.store_website! as! String)"

                            //when comment have value
                            
                        }
                    }
                    else
                    {
                        // if nil return value directly
                        return deliveryStr
                    }
            
            return deliveryStr
            
        }
    
    
    func getDeliveryChargesTextToShow() ->(String){
        var deliveryStr : String = ""
        
        
         if  RandomObjects.checkValueisNilorNull(value: storeDetailsObj?.delivery_charges) == false
         {
        if (storeDetailsObj?.delivery_charges  as! String ) == ""
        {
             deliveryStr = "No Delivery"
            //khali hai
                    
        }
        else
        {
            //when delivery chages have value
            deliveryStr =  "Delivery Charges : \(storeDetailsObj!.delivery_charges!)"
            //it has value
            
        }
        }
        else
        {
            //nil hai
            deliveryStr = "No Delivery"
        }
        
        if storeDetailsObj?.delivery_comment != nil
        {
            if RandomObjects.checkValueisNilorNull(value: storeDetailsObj?.delivery_comment) == true
            {
//                print("delivery comment crashing previously")
//                return deliveryStr
                //when comment is empty
                deliveryStr = "\(deliveryStr)"
            }
            else
            {
                
              if  (storeDetailsObj?.delivery_comment as? String)?.isEmpty == true
              {
//                print("delivery comment crashing previously")

                deliveryStr = "\(deliveryStr)"

              }
              else
              {
                deliveryStr = "\(deliveryStr)\n\(storeDetailsObj!.delivery_comment! as! String)"
                }
                //when comment have value
            }
        }
        else
        {
            // if nil return value directly
            return deliveryStr
        }
          
//                if storeDetailsObj?.store_website != nil
//                {
//                    if (storeDetailsObj?.store_website  as! String ) == ""
//                    {
//                        return deliveryStr
//                        //when comment is empty
//        //                deliveryStr = "\(deliveryStr)"
//                    }
//                    else
//                    {
//                        deliveryStr = "\(deliveryStr)\n\(storeDetailsObj!.store_website! as! String)"
//
//                        //when comment have value
//
//                    }
//                }
//                else
//                {
//                    // if nil return value directly
//                    return deliveryStr
//                }
        
        return deliveryStr
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if childVc?.collectionViewFilters.isHidden == false
        {
            self.hideAllFilterView()
        }
        
        self.upTheMenuIfNeeded()
        
        childVc?.searchView.isHidden = false
        
        childVc?.isSearchingPlaces = true
                    
        //            delegate?.beginLocationChanges()
        if textField.text?.isEmpty == false
        {
    NSObject.cancelPreviousPerformRequests(withTarget: childVc?.searchPlacesApi)
            
        childVc?.searchPlacesApi()
        }
        
        if childVc?.emptyStateImgView.isHidden == false
        {
           childVc?.emptyStateImgView.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.text?.isEmpty == true
        {
        self.clearAllSearchData()
        childVc?.searchView.isHidden = true
            //hb now 3 mar
//        if self.childVc?.collectionViewBarsandStoresHeightConstraint.constant == 0.0
//        {
//       //here
//        self.childVc?.collectionViewBarsandStoresHeightConstraint.constant = 140.0
//
//            if  (childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
//            {
//            self.getBarsDetailsApi(index: selectedBar, isSearchEnabled: false)
//           }
//           else if  (childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
//           {
//            self.getStoresDetailsApi(index: selectedStore, isSearchEnabled: false)
//            }
//            }
            
        }
        else
        {
        childVc?.searchView.isHidden = false
        }
        
        // hb 2 march changes
        if  childVc?.txtSearchbar.text?.isEmpty == true
        {
            appdelegate.selectedLatitude = 0.0
            appdelegate.selectedLongitude = 0.0
            childVc?.selectedPlaceDict = nil
            childVc?.placesArray.removeAllObjects()
            childVc?.tblsearch.isHidden = true
            childVc?.tblsearch.reloadData()
            self.getAddressfromLatLong()
            
            if (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
                                                    
            self.getBarsApi(barLatiTude: "\(RandomObjects.getLatitude())", bar_longitude: "\(RandomObjects.getLongitude())")
                                
            }
            else if (self.childVc?.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            self.getStoresApi(store_latitude:"\(RandomObjects.getLatitude())",store_longitude:"\(RandomObjects.getLongitude())")
            }
            else if (self.childVc?.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
            {
            self.getPeopleAPI(latitude:
                          "\(RandomObjects.getLatitude())", longitude: "\(RandomObjects.getLongitude())")
            }
            
        }
        
        
//        if appdelegate.selectedLatitude != 0.0 && childVc!.selectedPlaceDict != nil
//        {
//
//            childVc?.txtSearchbar.text =  (childVc?.selectedPlaceDict?.value(forKey: "description") as! String)
//        }
//        else
//        {
//
//            if childVc?.tblsearch.isHidden == true
//            {
//            self.getAddressfromLatLong()
//            }
//
//
//        }
//
//        childVc?.tblsearch.reloadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        self.clearAllSearchData()
        childVc?.searchView.isHidden = true
//        print("clear textfield now called")
//        rvefcds
        
        return true
    }
    
    
    //clear searched bars , stores and people
    func clearAllSearchData()
    {
//        if childVc?.txtSearchbar.text?.isEmpty == false
//        {
//            childVc?.txtSearchbar.text = ""
//        }
//        if (childVc?.searchStoreListArray.count)! > 0 {
//            childVc?.searchStoreListArray.removeAll()
//        }
//        if (childVc?.searchBarListArray.count)! > 0 {
//            childVc?.searchBarListArray.removeAll()
//        }
//        if (childVc?.searchedpeopleArray.count)! > 0
//        {
//            childVc?.searchedpeopleArray.removeAll()
//        }
        childVc?.tblsearch.reloadData()
    }
    

    
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage
    {

        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()

        let newImage = imageWithView(view: imgView)
        return newImage
    }

    func imageWithView(view: UIView) -> UIImage
    {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if scrollView == childVc?.tableBarDetails{
//
//            self.view.endEditing(true)
//            if scrollView.contentOffset.y < 30
//            {
////                if childVc?.collectionViewBarsandStoresHeightConstraint.constant == 140.0
////                {
////                    print("faltu less than 30")
////                }
////                else
////                {
//                childVc?.collectionViewBarsandStoresHeightConstraint.constant = 140.0
//                print("Open bar list")
//                    childVc?.imgleftArrowBarsandStores.isHidden = false
//                    childVc?.imgrightArrowBarsandStores.isHidden = false
//
////                }
//
//            }
//            else if scrollView.contentOffset.y > 30
//            {
//                if childVc?.collectionViewBarsandStoresHeightConstraint.constant == 0.0
//                {
//                    print("faltu greater than 30")
//                }
//                else
//                {
//                    if self.childVc?.collectionViewFilters.isHidden == false && (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
//                        {
//                    self.allFiltersButtonClicked((self.childVc?.btnShowFilters!)!)
//                        }
//                    
//                    childVc?.collectionViewBarsandStoresHeightConstraint.constant = 0.0
//                    print("close bar list")
//                    childVc?.imgleftArrowBarsandStores.isHidden = true
//                    childVc?.imgrightArrowBarsandStores.isHidden = true
//
//                   
//
//                }
//            }
//        }
//
//
//    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if scrollView == childVc?.tableBarDetails{

            if (self.lastContentOffset > scrollView.contentOffset.y)
            {
                // move up
                if scrollView.contentOffset.y < 30{
                    if childVc?.collectionViewBarsandStoresHeightConstraint.constant == 140.0
                    {
                        print("faltu less than 30")
                    }
                    else
                    {
                    childVc?.collectionViewBarsandStoresHeightConstraint.constant = 140.0
                    print("Open bar list")
                        childVc?.imgleftArrowBarsandStores.isHidden = false
                        childVc?.imgrightArrowBarsandStores.isHidden = false

                    }
                }
                
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y)
            {
               // move down
                 if scrollView.contentOffset.y > 30
                 {
                    if childVc?.collectionViewBarsandStoresHeightConstraint.constant == 0.0
                    {
                        print("faltu greater than 30")
                    }
                    else
                    {
                        if self.childVc?.collectionViewFilters.isHidden == false && (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
                            {
                        self.allFiltersButtonClicked((self.childVc?.btnShowFilters!)!)
                            }
                        
                        childVc?.collectionViewBarsandStoresHeightConstraint.constant = 0.0
                        print("close bar list")
                        childVc?.imgleftArrowBarsandStores.isHidden = true
                        childVc?.imgrightArrowBarsandStores.isHidden = true

                    }
                }
            }

            
            
            
            
            self.view.endEditing(true)
//            if scrollView.contentOffset.y < 30
//            {
//                if childVc?.collectionViewBarsandStoresHeightConstraint.constant == 140.0
//                {
//                    print("faltu less than 30")
//                }
//                else
//                {
//                childVc?.collectionViewBarsandStoresHeightConstraint.constant = 140.0
//                print("Open bar list")
//                    childVc?.imgleftArrowBarsandStores.isHidden = false
//                    childVc?.imgrightArrowBarsandStores.isHidden = false
//
//                }
//
//            }
//            else if scrollView.contentOffset.y > 30
//            {
//                if childVc?.collectionViewBarsandStoresHeightConstraint.constant == 0.0
//                {
//                    print("faltu greater than 30")
//                }
//                else
//                {
//                    if self.childVc?.collectionViewFilters.isHidden == false && (self.childVc?.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
//                        {
//                    self.allFiltersButtonClicked((self.childVc?.btnShowFilters!)!)
//                        }
//
//                    childVc?.collectionViewBarsandStoresHeightConstraint.constant = 0.0
//                    print("close bar list")
//                    childVc?.imgleftArrowBarsandStores.isHidden = true
//                    childVc?.imgrightArrowBarsandStores.isHidden = true
//
//
//
//                }
//            }
        }


    }
    
    
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//
//    }
//    func scrolltob
}

//extension UINavigationController {
//     func shouldAutorotate() -> Bool {
//        if visibleViewController is HomeViewController {
//            return true   // rotation
//        } else {
//            return false  // no rotation
//        }
//    }

//   func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//    return (visibleViewController?.supportedInterfaceOrientations)!
//    }
//}
