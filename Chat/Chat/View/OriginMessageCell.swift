//
//  OriginMessageCell.swift
//  Chat
//
//  Created by george on 18/12/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class OriginMessageCell: UICollectionViewCell
{
    public var message1: Message? = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var text1 : UITextView =
        {
            let text = UITextView()
            text.isUserInteractionEnabled = true
            text.isEditable = false
            text.isSelectable = false
            text.font = UIFont.systemFont(ofSize: 16)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.backgroundColor = UIColor.white
            text.textColor = UIColor.black
            text.isScrollEnabled = false
            text.text = "Origin message:"
            return text
    }()
    
    lazy var text2 : UITextView =
        {
            let text = UITextView()
            text.isUserInteractionEnabled = true
            text.isEditable = false
            text.isSelectable = false
            text.font = UIFont.systemFont(ofSize: 16)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.backgroundColor = UIColor.white
            text.textColor = UIColor.black
            text.text = "Translation memory:"
            text.isScrollEnabled = false
            return text
    }()
    
    lazy var originMessageTextField : UITextView =
        {
            let text = UITextView()
            text.isUserInteractionEnabled = true
            text.isEditable = false
            text.isSelectable = false
            text.font = UIFont.systemFont(ofSize: 16)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.backgroundColor = UIColor.clear
            text.textColor = UIColor.white
            return text
    }()

}

extension OriginMessageCell
{
    func setupView()
    {
        self.addSubview(text1)
        text1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        text1.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        text1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        text1.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let bubble = UIView()
        bubble.backgroundColor = UIColor(0, 137, 249)
        bubble.layer.cornerRadius = 16
        bubble.layer.masksToBounds = true
        bubble.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bubble)
        bubble.addSubview(originMessageTextField)
        

        let size = rectForText(text: (message1?.text!)!, font: UIFont.systemFont(ofSize: 16) , maxSize: CGSize(width: 200, height: 1000))
        
        bubble.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        bubble.widthAnchor.constraint(equalToConstant: size.width + 23 ).isActive = true
        bubble.topAnchor.constraint(equalTo: text1.bottomAnchor, constant: 4).isActive = true
        bubble.heightAnchor.constraint(equalToConstant: size.height + 20  ).isActive = true
        
        originMessageTextField.text = message1?.text
        
        originMessageTextField.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 8).isActive = true
        originMessageTextField.widthAnchor.constraint(equalToConstant: size.width + 15 ).isActive = true
        originMessageTextField.topAnchor.constraint(equalTo: bubble.topAnchor).isActive = true
        originMessageTextField.heightAnchor.constraint(equalToConstant: size.height + 20  ).isActive = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(200,200,200)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorLine)
        separatorLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.addSubview(text2)
        text2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        text2.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -8).isActive = true
        text2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        text2.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
    }
    
    //Stuff
    
        func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize
        {
            let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
            let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            let size = CGSize(width: rect.size.width, height: rect.size.height)
            return size
        }
    
}
