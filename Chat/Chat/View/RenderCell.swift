//
//  RenderCell.swift
//  Chat
//
//  Created by george on 18/12/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class RenderCell: UICollectionViewCell
{
    static let CellColor = UIColor(240, 240, 240)
    
    /*lazy var textView: UITextView =
        {
            let tv = UITextView()
            tv.font = UIFont.systemFont(ofSize: 16)
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = UIColor.clear
            tv.textColor = UIColor.white
            tv.isEditable = false
            tv.isSelectable = false
            tv.isUserInteractionEnabled = true
            return tv
    }()*/
    
    let bubbleView: UIView =
    {
            let view = UIView()
            view.backgroundColor = CellColor
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubview(bubbleView)
        //addSubview(textView)
        //addSubview(profileImageView)
        
        //bubbleView.addSubview(messageImageView)
        
        //position of bubbleView
        bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = false
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
