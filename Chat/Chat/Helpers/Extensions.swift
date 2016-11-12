//
//  Extensions.swift
//  Chat
//
//  Created by george on 12/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

let imageCache = NSCache <AnyObject, AnyObject> ()

extension UIImageView
{
    func loadImageUsingCacheWithUrlString(urlString: String)
    {
        //check cache for image first
        if let cache = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.image = cache
            return
        }
        
        //if no such image in cache 
        let url = NSURL(string: urlString)
        let a = URLRequest(url: url as! URL)
        URLSession.shared.dataTask(with: a, completionHandler:
            {
                (data, response ,error) in
                
                if error != nil
                {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async(execute:
                {
                    if let downloadedImage = UIImage(data: data!)
                    {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                    
                })
                
                
                
        }).resume()
    }
}
