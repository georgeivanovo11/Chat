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
        if let receiver = message.receiver
        {
            let ref = FIRDatabase.database().reference().child("users").child(receiver)
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
        
        self.detailTextLabel?.text = message.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let newDate = dateFormatter.date(from: message.time!)
        dateFormatter.dateFormat = "HH:mm:ss"
        let onlyTime = dateFormatter.string(from: newDate!)
        self.timeLabel.text = onlyTime
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
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
