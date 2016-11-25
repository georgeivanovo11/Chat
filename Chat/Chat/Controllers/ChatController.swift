//
//  ChatController.swift
//  Chat
//
//  Created by george on 19/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController, UITextFieldDelegate
{
    var user: User?
    {
        didSet
        {
            navigationItem.title = user?.name
        }
    }
    
    lazy var inputTextField: UITextField =
    {
        let text = UITextField()
        text.placeholder = "Enter message ..."
        text.translatesAutoresizingMaskIntoConstraints = false
        text.delegate = self
        return text
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //navigationItem.title = "Chat"
        
        collectionView?.backgroundColor = UIColor.white
        setupInputArea()
    }
}

//Actions
extension ChatController
{
    func handleSend()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let receiver = user!.id!
        let sender = FIRAuth.auth()!.currentUser!.uid
        let time: String = dateFormatter.string(from: Date())
        let values = ["text": inputTextField.text!, "receiver": receiver, "sender": sender, "time": time]
        //childRef.updateChildValues(values)
        
        childRef.updateChildValues(values, withCompletionBlock:
        {
            (error, ref) in
            if error != nil
            {
                print (error)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(sender)
            let messageRef = childRef.key
            userMessagesRef.updateChildValues([messageRef: 1])
            
            let receiverUserMessageRer = FIRDatabase.database().reference().child("user-messages").child(receiver)
            receiverUserMessageRer.updateChildValues([messageRef: 1])
            
        })
        
    }
}


//View
extension ChatController
{
    func setupInputArea()
    {
        //Container
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //Text
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //SeparatorLine
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(200,200,200)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        handleSend()
        return true
    }
}








