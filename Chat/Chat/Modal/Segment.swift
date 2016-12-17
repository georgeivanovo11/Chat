//
//  Segment.swift
//  Chat
//
//  Created by george on 17/12/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class Segment: NSObject
{
    var rus: String?
    var eng: String?
    var author: String?
    var isCorrect: String?
    
    init (dictionary: [String: AnyObject])
    {
        super.init()
        
        rus = dictionary["rus"] as? String
        eng = dictionary["eng"] as? String
        author = dictionary["author"] as? String
        isCorrect = dictionary["isCorrect"] as? String
    }
}
