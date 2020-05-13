//
//  MessagesCell.swift
//  Drinkthedrink
//
//  Created by Himanshu bhatia on 29/01/20.
//  Copyright © 2020 Dotttechnologies. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    @IBOutlet weak var heightforImageViewOtherUser: NSLayoutConstraint!

    @IBOutlet   var otherUserView : UIView!
    @IBOutlet   var txtotherUserMessage : UITextView!
    @IBOutlet   var imgOtherUser : UIImageView!

    @IBOutlet   var myView : UIView!
    @IBOutlet   var txtmyMessage : UITextView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtotherUserMessage.superview!.layer.borderColor = UIColor.init(red: 218/255.0, green: 219/255.0, blue: 214/255.0, alpha: 1.0).cgColor
        
        txtotherUserMessage.superview!.layer.borderWidth = 2.0
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
