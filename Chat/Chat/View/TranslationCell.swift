//
//  TranslationCell.swift
//  Chat
//
//  Created by george on 18/12/2016.
//  Copyright © 2016 george. All rights reserved.
//
import UIKit

class TranslationCell: UICollectionViewCell
{
    let message: Message? = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupView1()
        
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
            text.text = "Translation:"
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

extension TranslationCell
{
    func setupView1()
    {
        self.addSubview(text1)
        text1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        text1.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        text1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        text1.widthAnchor.constraint(equalToConstant: 150).isActive = true
        /*
         let bubble = UIView()
         bubble.backgroundColor = UIColor(0, 137, 249)
         bubble.layer.cornerRadius = 16
         bubble.layer.masksToBounds = true
         bubble.translatesAutoresizingMaskIntoConstraints = false
         
         outputContainerView.addSubview(bubble)
         bubble.addSubview(originMessageTextField)
         
         let size = rectForText(text: message!.text!, font: UIFont.systemFont(ofSize: 16) , maxSize: CGSize(width: 200, height: 1000))
         
         bubble.leftAnchor.constraint(equalTo: outputContainerView.leftAnchor, constant: 8).isActive = true
         bubble.widthAnchor.constraint(equalToConstant: size.width + 23 ).isActive = true
         bubble.topAnchor.constraint(equalTo: text1.bottomAnchor, constant: 4).isActive = true
         bubble.heightAnchor.constraint(equalToConstant: size.height + 20  ).isActive = true
         
         originMessageTextField.text = message?.text
         
         originMessageTextField.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 8).isActive = true
         originMessageTextField.widthAnchor.constraint(equalToConstant: size.width + 15 ).isActive = true
         originMessageTextField.topAnchor.constraint(equalTo: bubble.topAnchor).isActive = true
         originMessageTextField.heightAnchor.constraint(equalToConstant: size.height + 20  ).isActive = true
         
         outputContainerView.addSubview(text2)
         text2.leftAnchor.constraint(equalTo: outputContainerView.leftAnchor, constant: 8).isActive = true
         text2.topAnchor.constraint(equalTo: bubble.bottomAnchor, constant: 8).isActive = true
         text2.heightAnchor.constraint(equalToConstant: 30).isActive = true
         text2.widthAnchor.constraint(equalToConstant: 250).isActive = true
         
         //SeparatorLine
         let separatorLine = UIView()
         separatorLine.backgroundColor = UIColor(200,200,200)
         separatorLine.translatesAutoresizingMaskIntoConstraints = false
         outputContainerView.addSubview(separatorLine)
         separatorLine.leftAnchor.constraint(equalTo: outputContainerView.leftAnchor, constant: 10).isActive = true
         separatorLine.rightAnchor.constraint(equalTo: outputContainerView.rightAnchor,constant: -10).isActive = true
         separatorLine.topAnchor.constraint(equalTo: text2.bottomAnchor, constant: 2).isActive = true
         separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
         
         
         outputViewBottomAnchor?.isActive = false
         outputViewBottomAnchor = outputContainerView.bottomAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 1)
         outputViewBottomAnchor?.isActive = true*/
    }
    
}
