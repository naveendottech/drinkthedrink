//
//  LoginViewController.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 07/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit
import SVProgressHUD

class FirstTimeFlowViewController: UIViewController,UITextViewDelegate,UIScrollViewDelegate
{

//    @IBOutlet  var lblFeedbackDummy: UILabel!
      var indexofFirstTimeFlow: Int = 0

    let savedataInstance = SaveDataClass.sharedInstance
    @IBOutlet  var mainSuperViewNewBarImages: UIView!
    @IBOutlet  var btnNextOnFirstTimeFlow: UIButton!
    @IBOutlet  var scrollViewOnFirstTimeFlow: UIScrollView!
    @IBOutlet  var pageControl: UIPageControl!

    override func viewDidLoad()
    {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        indexofFirstTimeFlow = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        if indexofFirstTimeFlow == 2
        {
            btnNextOnFirstTimeFlow.setTitle("Start", for: .normal)
        }
        else
        {
            btnNextOnFirstTimeFlow.setTitle("Next", for: .normal)
        }
        pageControl.currentPage = indexofFirstTimeFlow
    }
    
    func loadUI()
    {
    print("came in")
        indexofFirstTimeFlow = 0
        scrollViewOnFirstTimeFlow.contentOffset = CGPoint.init(x: 0.0, y: 0.0)
        scrollViewOnFirstTimeFlow.delegate = self
        pageControl.currentPage = 0
    }
    override func viewDidLayoutSubviews() {
//        pageControl.subviews.forEach {
//            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
//        }
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)

    }
    //MARK:-  SEND FEEDBACK API HIT
    
    @IBAction func nextButtonClickedonFirstTimefLOW(_ sender: Any)
    {
        UIView.animate(withDuration: 0.4)
        {
            if self.indexofFirstTimeFlow == 0
        {
            self.scrollViewOnFirstTimeFlow.contentOffset = CGPoint.init(x: self.scrollViewOnFirstTimeFlow.frame.size.width, y: 0.0)
            self.indexofFirstTimeFlow = 1
            self.btnNextOnFirstTimeFlow.setTitle("Next", for: .normal)

        }
        else if self.indexofFirstTimeFlow == 1
        {
            self.scrollViewOnFirstTimeFlow.contentOffset = CGPoint.init(x: self.scrollViewOnFirstTimeFlow.frame.size.width * 2, y: 0.0)
            self.indexofFirstTimeFlow = 2
            self.btnNextOnFirstTimeFlow.setTitle("Start", for: .normal)

        }
        else if self.indexofFirstTimeFlow == 2
        {
        self.view.isHidden = true
        }
            self.pageControl.currentPage = self.indexofFirstTimeFlow
        }
        
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





//class UserData {
//    let email: Any?
//    let follow_by: Any?
//    let follow_to: Any?
//    let id: Any?
//    let message: Any?
//    let my_status: Any?
//    let name: Any?
//    let phone: Any?
//    let profile_image: Any?
//    let role: Any?
//    let role_name: Any?
//    let token: Any?
//    let username: Any?
//    let visibility_status: Any?
//    init(email : Any?,follow_by:Any?, follow_to: Any?, id: Any? , message : Any? , my_status : Any? , name: Any? , phone:Any? , profile_image : Any?,role : Any?,role_name : Any? ,token : Any?,username : Any?,visibility_status : Any? )
//    {
//        self.email = email
//        self.follow_by = follow_by
//        self.follow_to = follow_to
//        self.id = id
//        self.message = message
//        self.my_status = my_status
//        self.name = name
//        self.phone = phone
//        self.profile_image = profile_image
//        self.role = role
//        self.role_name = role_name
//        self.token = token
//        self.username = username
//        self.visibility_status = visibility_status
//    }
//}

