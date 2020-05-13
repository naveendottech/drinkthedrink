



import UIKit
import SystemConfiguration
import SVProgressHUD

public protocol WebServiceDelegate : NSObjectProtocol
{
    //MARK:- SUCESS RESPONSE
    func serverReponse(responseData: Data?,serviceurl:NSString)
    //MARK:- ERROR RESPONSE
    func failureRsponseError(failureError:NSError?,serviceurl:NSString)
    
}

public class ApiManager: NSObject {
    
    var arr_passCountryList : NSMutableArray = NSMutableArray()
    
    public var delegate: WebServiceDelegate?
    
    //********* Make Instance Of class ***********//
    
    private struct Constants {
        static let sharedManager = ApiManager()
    }
    
    public class var sharedManager: ApiManager {
        return Constants.sharedManager
    }
    
    //************ Check Internet Connectivity **********//
    
    public class NetWorkReachability
    {
        class func isConnectedToNetwork() -> Bool
        {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, { pointer in
                // Converts to a generic socket address
                return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                    // $0 is the pointer to `sockaddr`
                    return SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            })
            
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
            {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
    }
    
    
    //MARK:- APPEND API NAME WITH BASE URL
    func createServerPath(requestPath: String) -> String {
        return "\(Constant.baseUrl)\(requestPath)"
    }
    
    //MARK:- POST DATA ON SERVER
    public func postDataOnserver(params:NSMutableDictionary,postUrl:NSString,currentView:UIView)
    {
        let serverpath: String = self.createServerPath(requestPath: postUrl as String)
        
//        var request = URLRequest(url: NSURL(string: serverpath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! as URL)
        
        let request = NSMutableURLRequest(url: URL(string: serverpath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!,       cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        request.timeoutInterval   = 30.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do
            {
            SVProgressHUD.dismiss()
            if(error == nil)
            {
            let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
            if (response as? HTTPURLResponse)?.statusCode == 200
            {
               
                self.delegate?.serverReponse(responseData:data, serviceurl: postUrl)
                    }
                else
                {
                if jsonDictionary.value(forKey: "status")  != nil
                {
                self.delegate?.serverReponse(responseData:data, serviceurl: postUrl)
                }
                else
                {
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Server Error Occured!!!")
            self.delegate?.failureRsponseError(failureError: (error as NSError?), serviceurl: postUrl)
                }
                }
                }
                else
                {
                    //here hb
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Something went wrong!!!")

            self.delegate?.failureRsponseError(failureError: (error as NSError?), serviceurl: postUrl)
                }
            }
            catch {
                 DispatchQueue.main.async{
                    
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "Something went wrong!!!")
                    
               self.delegate?.failureRsponseError(failureError: (error as NSError), serviceurl: postUrl)
                }
            }
        }
        task.resume()
        return
    }
    
    
    public func getDataFromserver(params:NSMutableDictionary,postUrl:NSString,currentView:UIView)
    {
        let serverpath: String = self.createServerPath(requestPath: postUrl as String)
        var request = URLRequest(url: NSURL(string: "\(serverpath)")! as URL)

//        var request = URLRequest(url: NSURL(string: "\(serverpath)\(params)")! as URL)
        request.httpMethod = "GET"
        request.timeoutInterval   = 90.0
        request.cachePolicy = .useProtocolCachePolicy
       
        let headers = [
            "Cache-Control": "no-cache",
            ]
        request.allHTTPHeaderFields = headers
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                    do
                    {
                    SVProgressHUD.dismiss()
                    if(error == nil)
                    {
                    let jsonDictionary : NSDictionary = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            
                    if (response as? HTTPURLResponse)?.statusCode == 200
                    {
                        self.delegate?.serverReponse(responseData:data, serviceurl: postUrl)
                            }
                        else
                        {
                        if jsonDictionary.value(forKey: "status")  != nil
                        {
                        self.delegate?.serverReponse(responseData:data, serviceurl: postUrl)
                        }
                        else
                        {
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showError(withStatus: "Server Error Occured!!!")
                    self.delegate?.failureRsponseError(failureError: (error as NSError?), serviceurl: postUrl)
                        }
                        }
                        }
                        else
                        {
                            //here hb
                    print("CAME IN ERROR != NIL")
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Something went wrong!!!")

                    self.delegate?.failureRsponseError(failureError: (error as NSError?), serviceurl: postUrl)
                        }
                    }
                    catch {
                         DispatchQueue.main.async{
                            
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Something went wrong!!!")
                            
                       self.delegate?.failureRsponseError(failureError: (error as NSError), serviceurl: postUrl)
                        }
                    }
                }
        task.resume()
        return
    }
  
}


//MARK:- NETWORK REACHABILITY
let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

enum ReachabilityType: CustomStringConvertible {
    case wwan
    case wiFi
    
    var description: String {
        switch self {
        case .wwan: return "WWAN"
        case .wiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case offline
    case online(ReachabilityType)
    case unknown
    
    var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online (\(type))"
        case .unknown: return "Unknown"
        }
    }
}

open class Reach {
    
    func connectionStatus() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        
        //        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        //            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        //        }) else {
        //            return .unknown
        //        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return .unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    
    func monitorReachabilityChanges() {
        let host = "google.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let reachability = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
            let status = ReachabilityStatus(reachabilityFlags: flags)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityStatusChangedNotification),
                                            object: nil,
                                            userInfo: ["Status": status.description])
            
        }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes as! CFString)
    }
    
}

extension ReachabilityStatus {
    fileprivate init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wiFi)
            }
        } else {
            self =  .offline
        }
    }
}
