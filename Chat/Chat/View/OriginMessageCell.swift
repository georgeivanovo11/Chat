//
//  OriginMessageCell.swift
//  Chat
//
//  Created by george on 18/12/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class OriginMessageCell: UICollectionViewCell
{
    public var message1: Message? = nil
    public var motherController: RenderController? = nil
    public var linkToChatController: ChatController? = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        keyboardSettings()
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
            text.text = "Render memory:"
            text.isScrollEnabled = false
            return text
    }()
    
    lazy var text3 : UITextView =
        {
            let text = UITextView()
            text.isUserInteractionEnabled = true
            text.isEditable = false
            text.isSelectable = false
            text.font = UIFont.systemFont(ofSize: 16)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.backgroundColor = UIColor.white
            text.textColor = UIColor.black
            text.text = "Translation:"
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
    
    lazy var inputTextField : UITextView =
        {
            let text = UITextView()
            text.isUserInteractionEnabled = true
            //text.isEditable = false
            //text.isSelectable = false
            text.font = UIFont.systemFont(ofSize: 16)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.backgroundColor = UIColor(240, 240, 240)
            text.textColor = UIColor.black
            text.text = "Enter translation..."
            text.layer.cornerRadius = 16
            text.layer.masksToBounds = true
            return text
    }()
    
    lazy var clearButton: UIButton =
    {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor.clear
            button.setTitle("CL", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            //button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            
            //Actions:
            button.addTarget(self, action: #selector(toClear), for: .touchUpInside)
            
            return button
    } ()
    
    lazy var sendButton: UIButton =
        {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor.clear
            button.setTitle("Send", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            
            //Actions:
            button.addTarget(self, action: #selector(toSend), for: .touchUpInside)
            
            return button
    } ()
    
    lazy var saveButton: UIButton =
        {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor.clear
            button.setTitle("Save", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            
            //Actions:
            button.addTarget(self, action: #selector(toSave), for: .touchUpInside)
            
            return button
    } ()
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
        

        let size = rectForText(text: (message1?.text!)!, font: UIFont.systemFont(ofSize: 16) , maxSize: CGSize(width: 250, height: 1000))
        
        bubble.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        bubble.widthAnchor.constraint(equalToConstant: size.width + 23 ).isActive = true
        bubble.topAnchor.constraint(equalTo: text1.bottomAnchor, constant: 4).isActive = true
        bubble.heightAnchor.constraint(equalToConstant: size.height + 20  ).isActive = true
        
        originMessageTextField.text = message1?.text
        
        originMessageTextField.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 8).isActive = true
        originMessageTextField.widthAnchor.constraint(equalToConstant: size.width + 15 ).isActive = true
        originMessageTextField.topAnchor.constraint(equalTo: bubble.topAnchor).isActive = true
        originMessageTextField.heightAnchor.constraint(equalToConstant: size.height + 20  ).isActive = true
        
        self.addSubview(text3)
        text3.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        text3.topAnchor.constraint(equalTo: bubble.bottomAnchor, constant: 8).isActive = true
        text3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        text3.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let bubble2 = UIView()
        bubble2.backgroundColor = UIColor(240, 240, 240)
        bubble2.layer.cornerRadius = 16
        bubble2.layer.masksToBounds = true
        bubble2.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bubble2)
        bubble2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        bubble2.widthAnchor.constraint(equalToConstant: 270).isActive = true
        bubble2.topAnchor.constraint(equalTo: text3.bottomAnchor, constant: 4).isActive = true
        bubble2.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        bubble2.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: bubble2.leftAnchor, constant: 8).isActive = true
        inputTextField.topAnchor.constraint(equalTo: bubble2.topAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: bubble2.rightAnchor, constant: -8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: bubble2.bottomAnchor).isActive = true
        
        self.addSubview(clearButton)
        clearButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        clearButton.topAnchor.constraint(equalTo: text3.bottomAnchor, constant: 4).isActive = true
        clearButton.leftAnchor.constraint(equalTo: bubble2.rightAnchor, constant: 8).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(sendButton)
        sendButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -60).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50) .isActive = true
        sendButton.topAnchor.constraint(equalTo: bubble2.bottomAnchor, constant: 15).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(saveButton)
        saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 60).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50) .isActive = true
        saveButton.topAnchor.constraint(equalTo: bubble2.bottomAnchor, constant: 15).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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

extension OriginMessageCell
{
    func toClear()
    {
        inputTextField.text = ""
    }
    
    func toSave()
    {
        if(inputTextField.text! != "" && !inputTextField.text!.hasPrefix(" "))
        {
            guard let text = inputTextField.text, let author = FIRAuth.auth()?.currentUser?.uid
                else
            {
                return
            }
            
            let ref = FIRDatabase.database().reference().child("translation-memory")
            let childRef = ref.childByAutoId()
            
            var eng: String
            var rus: String
            
            if isEnglish(str: (message1?.text)!) == true
            {
                eng = (message1?.text)!
                rus = text
            }
            else
            {
                eng = text
                rus = (message1?.text)!
            }
            
            let isCorrect: String = "true"
            
            let values = ["eng": eng, "rus": rus, "author": author, "isCorrect": isCorrect] as [String : Any]
            
            childRef.updateChildValues(values)
        }
    }
    
    func toSend()
    {
        if(inputTextField.text! != "" && !inputTextField.text!.hasPrefix(" "))
        {
            linkToChatController?.inputTextField.text = inputTextField.text
            motherController?.navigationController?.popViewController(animated: true)
        }
    }
}

extension OriginMessageCell
{
        func keyboardSettings()
        {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardofInputTextField))
            self.addGestureRecognizer(tap)
            
            //NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard2), name: .UIKeyboardDidShow, object: nil)
        }
        
        func dismissKeyboardofInputTextField()
        {
            inputTextField.resignFirstResponder()
        }

    func isEnglish(str: String) -> Bool
    {
        let str1 = str.lowercased()
        let mas: [Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","o","p","q","r","s","t","u","v","w","x","y","z"]
        
        for a: Character in mas
        {
            if str1.hasPrefix((String) (a) )
            {
                return true
            }
        }
        return false
    }
}
