//
//  RenderController.swift
//  Chat
//
//  Created by george on 10/12/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class RenderController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout
{
    public var message: Message? = nil
    var memory = [Segment]()
    var outputViewBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Render"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true

        downloadMemory()
        setupOutputContainerView()
        keyboardSettings()
                
    }
    
    lazy var inputTextField: UITextField =
        {
            let text = UITextField()
            text.placeholder = "Enter translation ..."
            text.translatesAutoresizingMaskIntoConstraints = false
            text.delegate = self
            text.returnKeyType = .done
            return text
    }()
    
    lazy var inputContainerView: UIView =
        {
            let containerView = UIView()
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            containerView.backgroundColor = UIColor.white
            
            //Button
            let sendButton = UIButton(type: .system)
            sendButton.setTitle("Save", for: .normal)
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(sendButton)
            sendButton.addTarget(self, action: #selector(saveSegment), for: .touchUpInside)
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
            
            //Text
            containerView.addSubview(self.inputTextField)
            self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
            self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
            self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
            
            //SeparatorLine
            let separatorLine = UIView()
            separatorLine.backgroundColor = UIColor(200,200,200)
            separatorLine.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(separatorLine)
            separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
            separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20).isActive = true
            separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            return containerView
    }()
    
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
        text.text = "Origin message:"
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
    
    func setupOutputContainerView()
    {
        let outputContainerView = UIView()
        outputContainerView.backgroundColor = UIColor.white
        outputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(outputContainerView)
        outputContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        outputContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        outputContainerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65).isActive = true
        //outputContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        outputViewBottomAnchor = outputContainerView.bottomAnchor.constraint(equalTo: outputContainerView.topAnchor, constant: 50)
        outputViewBottomAnchor?.isActive = true
        
        outputContainerView.addSubview(text1)
        text1.leftAnchor.constraint(equalTo: outputContainerView.leftAnchor, constant: 8).isActive = true
        text1.topAnchor.constraint(equalTo: outputContainerView.topAnchor, constant: 8).isActive = true
        text1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        text1.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
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
        
        outputViewBottomAnchor?.isActive = false
        outputViewBottomAnchor = outputContainerView.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: 2)
        outputViewBottomAnchor?.isActive = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        inputTextField.resignFirstResponder()
        return true
    }
    
    override var inputAccessoryView: UIView?
        {
        get
        {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
}

//Action
extension RenderController
{
    func saveSegment()
    {
        guard let text = inputTextField.text, let author = FIRAuth.auth()?.currentUser?.uid
        else
        {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("translation-memory")
        let childRef = ref.childByAutoId()
        
        let eng: String = (message?.text)!
        let rus: String = text
        let isCorrect: String = "true"
        
        let values = ["eng": eng, "rus": rus, "author": author, "isCorrect": isCorrect] as [String : Any]
        
        childRef.updateChildValues(values)
        
        inputTextField.text = nil
        print ("ok")
    }
    
    func downloadMemory()
    {
        let currentUserRer = FIRDatabase.database().reference().child("translation-memory")
        
        currentUserRer.observe(.childAdded, with:
            {
                (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject]
                    else {return}
                
                let segment = Segment(dictionary: dictionary)
                self.memory.append(segment)
                DispatchQueue.main.async(execute:
                {
                        self.collectionView?.reloadData()
                })
            })
    }
}


//Stuff
extension RenderController
{
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize
    {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
}

//Keyboard
extension RenderController
{
    func keyboardSettings()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardofInputTextField))
        view.addGestureRecognizer(tap)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard2), name: .UIKeyboardDidShow, object: nil)
    }
    
    func dismissKeyboardofInputTextField()
    {
        inputTextField.resignFirstResponder()
    }
    
}
