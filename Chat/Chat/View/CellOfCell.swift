//
//  RenderCell.swift
//  Chat
//
//  Created by george on 18/12/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class CellOfCell: UICollectionViewCell
{
    static let currentUserColor = UIColor(0, 137, 249)
    static let color2 = UIColor(240, 240, 240)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView()
    {
        backgroundColor = UIColor.clear
        
        self.addSubview(bubbleView)
        bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        
        self.addSubview(rateTextField)
        rateTextField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rateTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        rateTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        rateTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        bubbleView.addSubview(view2)
        view2.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        view2.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -5).isActive = true
        view2.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 60).isActive = true
        view2.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
    }
    
    let bubbleView: UIView =
    {
         let view = UIView()
         view.backgroundColor = currentUserColor
         view.layer.cornerRadius = 16
         view.layer.masksToBounds = true
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
    }()
    
    let view2: UIView =
    {
        let view = UIView()
        view.backgroundColor = color2
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rateTextField : UITextView =
        {
            let text = UITextView()
            text.isUserInteractionEnabled = true
            text.isEditable = false
            text.isSelectable = false
            text.font = UIFont.systemFont(ofSize: 12)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.backgroundColor = UIColor.clear
            text.textColor = UIColor.black
            text.text = "100%"
            text.textAlignment = .center
            return text
    }()
}
