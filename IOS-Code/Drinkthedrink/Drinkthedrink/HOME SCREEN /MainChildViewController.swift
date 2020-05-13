//
//  MainChildViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 24/12/19.
//  Copyright © 2019 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import CoreLocation


protocol BeginLocationChangesDelegate
{
    func beginLocationChanges()
}


class MainChildViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate,UIScrollViewDelegate
{
    
    @IBOutlet  var imgunderLineAtBarandStoreList : UIImageView!
    @IBOutlet  var  imgleftArrowBarsandStores: UIImageView!
    @IBOutlet  var imgrightArrowBarsandStores : UIImageView!

    
    var delegate        : BeginLocationChangesDelegate?

    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "

//    VARIABLES FOR CHOOSE PLACES FUNCTIONALITY :
    var isSearchingPlaces : Bool = false
    var placesArray = NSMutableArray()
    var selectedPlaceDict:NSMutableDictionary? = NSMutableDictionary()
    
    
    @IBOutlet  var btnShowFilters : UIButton!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate


    let savedataInstance = SaveDataClass.sharedInstance

    var searchedpeopleArray  = [PeopleList]()

    @IBOutlet  var peopleFilteruperView: UIView!

    @IBOutlet  var tblPeople: UITableView!
    @IBOutlet  var peopleTableSuperView: UIView!
    
    //latest for search functionality
    var searchBarListArray  = [SearchBarList]()
    var searchStoreListArray  = [SearchStoreList]()
    var searchType : String = ""
    @IBOutlet  var searchView: UIView!
    
    @IBOutlet  var tblsearch: UITableView!
//    search Results for bars and stores :
    @IBOutlet  var txtSearchbar: UITextField!
//    @IBOutlet  var btnSearch: UIButton!
//    @IBOutlet  var btnCrossSearchBar: UIButton!

//previous
    //for bars and stores both
    @IBOutlet  var tableBarDetails: UITableView!
    @IBOutlet  var collectionViewBarsandStores : UICollectionView!
    
    @IBOutlet  var collectionViewBarsandStoresHeightConstraint: NSLayoutConstraint!
    
    
    
    
    @IBOutlet  var collectionViewFilters : UICollectionView!
    @IBOutlet  var collectionViewFiltersHeightConstraint : NSLayoutConstraint!
       
    @IBOutlet  var emptyStateImgView: UIImageView!
//    @IBOutlet  var storeFilterView: UIStackView!
    
//    @IBOutlet  var barsFilterView: UIStackView!
//
//    @IBOutlet  var btnDeliveryFilter: UIButton!
//    //EVENT AND TESTING LABEL
//    @IBOutlet  var btnTestingFilter: UIButton!
//    @IBOutlet  var imgRadioDelivery : UIImageView!
//    @IBOutlet  var imgRadioTesting  : UIImageView!
    
//    @IBOutlet  var imgRadioSpecial: UIImageView!
//    @IBOutlet  var imgRadioEvents: UIImageView!

    //DELIVERY AND SPECIAL LABEL
//    @IBOutlet  var btnSpecialFilter: UIButton!
////EVENT AND TESTING LABEL
//    @IBOutlet  var btnEventFilter: UIButton!
//
//    @IBOutlet  var lblSpecial: UILabel!
//    @IBOutlet  var lblEvent: UILabel!
    
    @IBOutlet  var btnStores: UIButton!
    @IBOutlet  var btnBars: UIButton!
    @IBOutlet  var btnPeople: UIButton!
    
    
    @IBOutlet  var imgRadioBars: UIImageView!
    @IBOutlet  var imgRadioStores: UIImageView!
    @IBOutlet  var imgRadioPeople: UIImageView!

    
//    @IBOutlet  var btnOnOffBarFilter: UIButton!
//    @IBOutlet  var imgViewFilter: UIImageView!

    
    @IBOutlet  var btnDismissHeightConstraint: NSLayoutConstraint!
    @IBOutlet  var btnDismiss: UIButton!
    
    @IBOutlet  var mainView: UIView!

    @IBOutlet  var imgArrow: UIImageView!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var btnMenu: UIButton!

    
    //JUST ADDED BOTTOM COLLECTION VIEW FOR SHOWING ADDS OF IMAGES
    @IBOutlet  var collectionViewForAds: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnDismiss.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonClicked(_ sender: Any)
    {
//        self.view.endedit
    if txtSearchbar.text?.isEmpty == false
        {
        
    if (self.imgRadioBars.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            self.searchBarsAPI()
        }
        if (self.imgRadioStores.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
            self.searchStoresAPI()
        }
        if (self.imgRadioPeople.image?.isEqual(UIImage.init(named: "selectionon")))!
        {
          if savedataInstance.getUserDetails() != nil
          {
            self.searchPeopleAPI()
          }
          else
          {
                SVProgressHUD.showError(withStatus: "Please login to search people.")
        }
        }
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Please enter text to search.")
        }
        
    }
    
    
    //CHANGES HB 2 MARCH
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField == txtSearchbar{
        if textField.text?.isEmpty == false
        {
      NSObject.cancelPreviousPerformRequests(withTarget: searchPlacesApi)
          
          self.searchPlacesApi()
        }
        else
        {

          self.tblsearch.isHidden = true
          placesArray.removeAllObjects()
            tblsearch.reloadData()
        }
        }
    }
    
    func searchPlacesApi()
        {
       let manager: AFHTTPSessionManager = AFHTTPSessionManager()
       manager.requestSerializer = AFJSONRequestSerializer()
       manager.responseSerializer = AFJSONResponseSerializer()
       
       var urlStr = NSString.init(format:"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=AIzaSyAY0B4xNSzIrro5kII02w8GQwXmt9byMGo", txtSearchbar.text!)
        urlStr =    RandomObjects.geturlEncodedString(string: urlStr as String) as NSString
                
                print(urlStr)
                
                print(urlStr)
                manager.get(urlStr as String, parameters: nil, progress: { (progress) in
                    print(progress)
                }, success: { (task, response) in
                    print("response autocomplete api is \(response)")
                    
                    
          self.placesArray.removeAllObjects()
          
          let responseDict : NSDictionary?
          responseDict = response as? NSDictionary
//                    matchedSubstringDict = responsed
          let status = responseDict?["status"] as! String
          var results:NSArray?
                               
        if responseDict?["predictions"] != nil
        {
            results = responseDict?["predictions"] as? NSArray
        }
//                    let matchedDict : NSDictionary?
//                    
//                     if results?.count ?? 0 > 0
//                    {
//                        matchedDict = ((results?.object(at: 0) as? NSDictionary)?.value(forKey: "matched_substrings") as? NSArray)?.object(at: 0) as? NSDictionary
//                        let matchedCount : Int? = matchedDict?.value(forKey: "length") as? Int
//                        
//                        if matchedCount == self.txtSearchbar.text?.count
//                        {
//                            
//                        }
//                        else{
//                            print("count not matched")
//                            self.placesArray.removeAllObjects()
//                            self.tblsearch.reloadData()
//                            return 
//                        }
//                    }


        if status == "NOT_FOUND" || status == "REQUEST_DENIED"
        {
            print("response in error case+\(response)+")
            SVProgressHUD.showError(withStatus: (responseDict?["status"] as! String) )
                            
            return
        }
        else
        {
            print("results searched are here \(results!)")
            print("count is  \(results!.count)")

        }
                    
          if results?.count ?? 0 > 0
          {
              self.placesArray.addObjects(from: results as! [Any])
          }
                    
        if self.placesArray.count > 0
        {
                        
        if self.txtSearchbar.text?.isEmpty == false && self.isSearchingPlaces == true
        {
            self.tblsearch.isHidden = false
            self.tblsearch.reloadData()
                        
            }
            else
            {
            self.placesArray.removeAllObjects()
            self.tblsearch.reloadData()
                        
            }
            }
            else
            {
            self.placesArray.removeAllObjects()

            self.tblsearch.reloadData()
            }
                            

                }) { (task, error) in
                    print("error in autocomplete api \(error)")
                    
                    self.placesArray.removeAllObjects()
                    self.tblsearch.reloadData()
                }
            }
    
    
        func textFieldDidBeginEditing(_ textField: UITextField)
        {
            isSearchingPlaces = true
            
//            delegate?.beginLocationChanges()
            if textField.text?.isEmpty == false
            {
            NSObject.cancelPreviousPerformRequests(withTarget: searchPlacesApi)
              self.searchPlacesApi()
            }
            
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == txtSearchbar
        {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
        }
        else
        {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtSearchbar
        {
//        isSearchingPlaces = false
        if textField.text?.isEmpty == true
        {
        self.tblsearch.isHidden = true
      
        let delegate = UIApplication.shared.delegate as! AppDelegate
                
    if delegate.selectedLatitude != 0.0 && selectedPlaceDict != nil
    {
                
        self.txtSearchbar.text =  (selectedPlaceDict?.value(forKey: "description") as! String)
    }
    else
    {
        
    txtSearchbar.text = RandomObjects.getAddressfromLatLongNow()
        
        delegate.selectedLatitude = 0.0
        delegate.selectedLongitude = 0.0
        placesArray.removeAllObjects()
        selectedPlaceDict = nil
        
    }
    self.tblsearch.reloadData()
    }
    }
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        print("came in viewWillAppear ")
        
        self.mainView.layer.cornerRadius = 15        
//        self.mainView.roundCorners([.topLeft, .topRight], radius: 15.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("came in viewDidAppear ")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK:-  searchBarsAPI API HIT
    @objc func searchBarsAPI()
    {
        let params = NSMutableDictionary()
        params.setValue(self.txtSearchbar.text, forKey: "query")
        params.setValue("\(RandomObjects.getLatitude())", forKey: "bar_latitude")
        params.setValue("\(RandomObjects.getLongitude())", forKey: "bar_longitude")
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
        SVProgressHUD.show(withStatus: "Searching Bars...")
        ApiManager.sharedManager.postDataOnserver(
            params: params,
            postUrl:Constant.SEARCHBARSAPI as NSString,
            currentView: self.view)
            }
        }
    
    //MARK:-  searchStoresAPI API HIT
    func searchStoresAPI()
    {
        let params = NSMutableDictionary()
        params.setValue(self.txtSearchbar.text, forKey: "query")
        params.setValue("\(RandomObjects.getLatitude())", forKey: "store_latitude")
        params.setValue("\(RandomObjects.getLongitude())", forKey: "store_longitude")
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
        SVProgressHUD.show(withStatus: "Searching Stores...")
        ApiManager.sharedManager.postDataOnserver(
            params: params,
            postUrl:Constant.SEARCHSTORESAPI as NSString,
            currentView: self.view)
            }
        }
    
    //MARK:-  searchStoresAPI API HIT
    func searchPeopleAPI()
    {
        savedataInstance.getUserDetails()
        let params = NSMutableDictionary()
        params.setValue(self.txtSearchbar.text!, forKey: "search")
        
        
        if self.appdelegate.selectedLatitude! != 0.0
        {
        params.setValue(appdelegate.selectedLatitude!, forKey: "latitude")
        params.setValue(appdelegate.selectedLongitude!, forKey: "longitude")
        
        }
        else
        {
        
        params.setValue("\(RandomObjects.getLatitude())", forKey: "latitude")
        params.setValue("\(RandomObjects.getLongitude())", forKey: "longitude")
        }
                
        params.setValue("\(savedataInstance.id!)", forKey: "user_id")
        print("params for search people api \(params)")
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
        SVProgressHUD.show(withStatus: "Searching People...")
        ApiManager.sharedManager.postDataOnserver(
            params: params,
            postUrl:Constant.SEARCHPEOPLEAPI as NSString,
            currentView: self.view)
            }
        }
    
    //LOGIN API RESPONSE
    func serverReponse(responseData: Data?, serviceurl: NSString)
    {
       SVProgressHUD.dismiss()
       DispatchQueue.main.async {
           do {
            
        if serviceurl as String == Constant.REQUESTTOFOLLOWAPI
        {
        let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with:     responseData! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        print("jsondictionary for api :\(Constant.REQUESTTOFOLLOWAPI) and response is \(jsonDictionary)")
      
        if (jsonDictionary.value(forKey: "status") as! Bool) == true
        {
            SVProgressHUD.dismiss()
          SVProgressHUD.showSuccess(withStatus: "success")
  
            self.searchPeopleAPI()
  
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
    
    //MARK:- ERROR RESPONSE
    func failureRsponseError(failureError: NSError?, serviceurl: NSString) {
    }
    
    
    //MARK:-    TABLEVIEW DELEGATES AND DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

            return placesArray.count

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : PlacesCell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell") as! PlacesCell
        if placesArray.count > 0
        {
            cell.lblPlaceName.text = (placesArray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "description") as? String
        }
              return cell

    }
    
    //NEW FUNCTION BY ME

    

            
            
    
    
     

     
     
     
     
     
     
     

     
    
    
    
    
    
    
    
    
    
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == tblsearch
//        {
//            self.view.endEditing(true)
//        }
//        
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//            return 105
//    }
    

}

class SearchBarList {
    let bar_name: Any?
    let bar_tags: Any?
    let distance: Any?
    let id: Any?
    let place_type: Any?
    let vibes: Any?
    let bar_image: Any?

      
    init(bar_name : Any?,bar_tags:Any?, distance: Any?, id: Any? , place_type : Any? , vibes : Any?,bar_image:Any?)
    {
        self.bar_name = bar_name
        self.bar_tags = bar_tags
        self.distance = distance
        self.id = id
        self.place_type = place_type
        self.vibes = vibes
        self.bar_image = bar_image

        
    }
}

class SearchStoreList {
    let store_name: Any?
    let distance: Any?
    let id: Any?
    let store_image: Any?

    init(store_name : Any?, distance: Any?, id: Any?,store_image:Any? )
    {
        self.store_name = store_name
        self.distance = distance
        self.id = id
        self.store_image = store_image
    }
    
}
