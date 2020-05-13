//
//  ChoosePlacesViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 10/02/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation



protocol BeginLocationChangesDelegateNew {
    func beginLocationChangesNew()
}
//    var delegate        : BeginLocationChangesDelegateNew?


class ChoosePlacesViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate
{
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet  var viewSearchPlaces : UIView!

    var isSearchingPlaces : Bool = false
    
//    var delegate        : BeginLocationChangesDelegateNew?

    @IBOutlet  var txtSearchPlaces : UITextField!
    @IBOutlet  var mainPlacesSuperview : UIView!
    @IBOutlet  var tblPlaces : UITableView!
    @IBOutlet  var btnSearchPlaces : UIButton!
    var placesArray = NSMutableArray()
    var selectedPlaceDict:NSMutableDictionary? = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//       @IBAction func crossButtonClickedonChooseAddress(_ sender: Any)
//       {
//           self.view.isHidden = true
//       }
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtSearchPlaces
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
    
    @objc func textFieldDidChange(_ textField: UITextField)
      {
          if textField.text?.isEmpty == false
          {
        NSObject.cancelPreviousPerformRequests(withTarget: searchPlacesApi)
            
            self.searchPlacesApi()
          }
          else
          {
             self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 35)
            self.tblPlaces.isHidden = true
            placesArray.removeAllObjects()
            tblPlaces.reloadData()
          }
      }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        isSearchingPlaces = false
        if textField.text?.isEmpty == true
        {
        self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 35)
            self.tblPlaces.isHidden = true
      
        let delegate = UIApplication.shared.delegate as! AppDelegate
                
    if delegate.selectedLatitude != 0.0 && selectedPlaceDict != nil
    {
                
        self.txtSearchPlaces.text =  (selectedPlaceDict?.value(forKey: "description") as! String)
    }
    else
    {
        self.getAddressfromLatLong()
        delegate.selectedLatitude = 0.0
        delegate.selectedLongitude = 0.0
        placesArray.removeAllObjects()
        selectedPlaceDict = nil
        
    }
            self.tblPlaces.reloadData()
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

                CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in

                    if error != nil {
                        return
                    }
                    if placemarks?.count ?? 0 > 0 {
                        let pm = placemarks?[0] as! CLPlacemark
                        
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
                self.txtSearchPlaces.text = addressString

                                        
                    }
                    else {
                        print("Problem with the data received from geocoder")
                    }
                })
                
            }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        isSearchingPlaces = true
        
//        delegate?.beginLocationChangesNew()
        
        if textField.text?.isEmpty == false
        {
          NSObject.cancelPreviousPerformRequests(withTarget: searchPlacesApi)
          self.searchPlacesApi()
        }
        
    }
    
    func searchPlacesApi()
        {
                let manager: AFHTTPSessionManager = AFHTTPSessionManager()
                manager.requestSerializer = AFJSONRequestSerializer()
                manager.responseSerializer = AFJSONResponseSerializer()
                
                var urlStr = NSString.init(format:"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=AIzaSyAY0B4xNSzIrro5kII02w8GQwXmt9byMGo", txtSearchPlaces.text!)
                 urlStr =    RandomObjects.geturlEncodedString(string: urlStr as String) as NSString
                
                
                
                print(urlStr)
                
                print(urlStr)
                manager.get(urlStr as String, parameters: nil, progress: { (progress) in
                    print(progress)
                }, success: { (task, response) in
                    
                    self.placesArray.removeAllObjects()
                    
                    let responseDict : NSDictionary?
                    responseDict = response as? NSDictionary
                    
                    let status = responseDict?["status"] as! String
                    var results:NSArray?
                               
                    if responseDict?["predictions"] != nil
                    {
                        results = responseDict?["predictions"] as? NSArray
                    }

                    if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                     {
                         SVProgressHUD.showError(withStatus: (responseDict?["status"] as! String) )
                                         
                         return
                     }
                  
                    
                    if results?.count ?? 0 > 0
                    {
                        self.placesArray.addObjects(from: results as! [Any])
                    }
                    
                    if self.placesArray.count > 0
                    {
                        
                        if self.txtSearchPlaces.text?.isEmpty == false && self.isSearchingPlaces == true
                    {
                    self.tblPlaces.isHidden = false
                    self.tblPlaces.reloadData()
               
                self.perform(#selector(self.setTableHeightToContentSize), with: nil, afterDelay: 0.4)
                        
                    }
                    else
                    {
                        self.placesArray.removeAllObjects()
                        self.tblPlaces.reloadData()
                        
                        self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 35)
                        self.tblPlaces.isHidden = true
                    }
                    }
                    else
                    {
                        self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 35)
                        self.tblPlaces.isHidden = true
                        
                    }
                            

                }) { (task, error) in
                    print("error in autocomplete api \(error)")
                }
                
            }
    
    @objc func setTableHeightToContentSize()
    {
            if self.tblPlaces.contentSize.height > 200
            {
                  self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 235)
            }
            else
            {
                self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.tblPlaces.contentSize.height + 35)
            }
    }
    
    
        //MARK:- TABLEVIEW DELEGATES AND DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return placesArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
