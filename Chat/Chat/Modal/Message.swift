//
//  Message.swift
//  Chat
//
//  Created by george on 21/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject
{
    var sender: String?
    var receiver: String?
    var text: String?
    var time: String?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init (dictionary: [String: AnyObject])
    {
        super.init()
        sender = dictionary["sender"] as? String
        receiver = dictionary["receiver"] as? String
        time = dictionary["time"] as? String
        text = dictionary["text"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
    }
    
    func partnerId() -> String?
    {
        if sender == FIRAuth.auth()?.currentUser?.uid
        {
            return receiver
        }
        else
        {
            return sender
        }
    }
}
