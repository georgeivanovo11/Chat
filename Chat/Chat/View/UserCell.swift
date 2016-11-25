//
//  UserCell.swift
//  Chat
//
//  Created by george on 24/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        textLabel?.frame = CGRect(origin: CGPoint(x:64,y: textLabel!.frame.origin.y - 1), size: CGSize(width: textLabel!.frame.width, height:textLabel!.frame.height))
        detailTextLabel?.frame = CGRect(origin: CGPoint(x:64,y: detailTextLabel!.frame.origin.y + 1), size: CGSize(width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height))
    }
    
    func showUserMessage(message: Message)
    {
        if message.sender == FIRAuth.auth()?.currentUser?.uid
        {
            self.detailTextLabel?.text = "Me: " + message.text!
        }
        else
        {
            self.detailTextLabel?.text = message.text
        }
        
        if let id = message.partnerId()
        {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with:
                {
                    (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]
                    {
                        self.textLabel?.text = dictionary["name"] as? String
                        if let imageUrl = dictionary["imageURL"] as? String
                        {
                            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
                        }
                    }
            })
        }
        
        
        
        let today = Date()
        let thatDay = myDate.getDate(string: message.time!)
        if myDate.compare(date1: today, date2: thatDay)
        {
            self.timeLabel.text = myDate.getTime(date: message.time!)
        }
        else
        {
            self.timeLabel.text = myDate.getDay(date: message.time!)
        }
    }
    
    let profileImageView: UIImageView =
        {
            let imageView = UIImageView()
            //imageView.image = UIImage(named: "UnknownUser")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 24
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
    }()
    
    let timeLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
