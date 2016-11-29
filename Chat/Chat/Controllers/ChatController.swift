//
//  ChatController.swift
//  Chat
//
//  Created by george on 19/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout
{
    let cellId = "cellId"
    var messages = [Message]()
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    var user: User?
    {
        didSet
        {
            navigationItem.title = user?.name
            downloadMessages()
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
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupInputArea()
        setupKeyboard()
    }
    
    func downloadMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let tempReceiver = user?.id
            else {return}
        let currentUserRer = FIRDatabase.database().reference().child("user-messages").child(uid).child(tempReceiver)
        currentUserRer.observe(.childAdded, with:
        {
            (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject]
                else {return}
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                DispatchQueue.main.async(execute: {self.collectionView?.reloadData()})
            })
        })
    }
    
    func uploadImageToFirebase(image: UIImage)
    {
        
    }

}

//Collection view
extension ChatController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }

    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.row].text
        {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect
    {
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message)
    {
        if let profileImageUrl = self.user?.imageURL
        {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        if message.sender == FIRAuth.auth()?.currentUser?.uid
        {
            cell.bubbleView.backgroundColor = ChatMessageCell.currentUserColor
            cell.textView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.profileImageView.isHidden = true
        }
        else
        {
            cell.bubbleView.backgroundColor = ChatMessageCell.partnerUserColor
            cell.textView.textColor = UIColor.black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
    }
}


//Actions
extension ChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
            
            self.inputTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(sender).child(receiver)
            let messageRef = childRef.key
            userMessagesRef.updateChildValues([messageRef: 1])
            
            let receiverUserMessageRer = FIRDatabase.database().reference().child("user-messages").child(receiver).child(sender)
            receiverUserMessageRer.updateChildValues([messageRef: 1])
            
        })
    }
    
    func handleUploadTap()
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            uploadImageToFirebase(image: editedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}


//View
extension ChatController
{
    func setupInputArea()
    {
        //Container
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //ImageView
        let uploadImage = UIImageView()
        uploadImage.isUserInteractionEnabled = true
        uploadImage.image = UIImage(named: "newImage")
        uploadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImage)
        uploadImage.translatesAutoresizingMaskIntoConstraints = false
        uploadImage.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        uploadImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
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
        inputTextField.leftAnchor.constraint(equalTo: uploadImage.rightAnchor, constant: 4).isActive = true
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

//Keyboard
extension ChatController
{
    func setupKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        containerViewBottomAnchor?.constant = -keyboardSize!.height
        print(111111)
        let keyboardDirection = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        UIView.animate(withDuration: keyboardDirection as! TimeInterval)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        containerViewBottomAnchor?.constant = 0
        
        let keyboardDirection = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]
        UIView.animate(withDuration: keyboardDirection as! TimeInterval)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}





