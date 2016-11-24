//
//  MyDate.swift
//  Chat
//
//  Created by george on 24/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class myDate
{
    static func getTime(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: newDate!)
    }
    
    static func getDay(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: newDate!)
    }
    
    static func getDate(string: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.date(from: string)!
    }
    
    static func compare (date1: Date, date2: Date) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if dateFormatter.string(from: date1) == dateFormatter.string(from: date2)
        {return true}
        else
        {return false}
    }
    
    static func sort (m1: Message, m2: Message) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        let a = dateFormatter.date(from: m1.time!)!
        let b = dateFormatter.date(from: m2.time!)!
        
        return a > b
    }
}
