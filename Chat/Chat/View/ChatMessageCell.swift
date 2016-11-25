//
//  ChatMessageCell.swift
//  Chat
//
//  Created by george on 25/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell
{
    let textView: UITextView =
    {
        let tv = UITextView()
        tv.text = "example"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //backgroundColor = UIColor.red
        addSubview(textView)
        
        //position
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
