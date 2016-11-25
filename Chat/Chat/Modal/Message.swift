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
