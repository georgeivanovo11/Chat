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
    var currentMessage : Message? = nil
    
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
        text.backgroundColor = UIColor(245,245,245)
        text.returnKeyType = .done
        return text
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        keyboardSettings()
    }
    
    lazy var inputContainerView: UIView =
    {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor(200,200,200)
        
        //imageButton
        let imageButton = UIButton(type: .system)
        imageButton.setTitle("+", for: .normal)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        containerView.addSubview(imageButton)
        imageButton.addTarget(self, action: #selector(handleUploadTap), for: .touchUpInside)
        imageButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -2).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //sendButton
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendText), for: .touchUpInside)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let centerContainer = UIView()
        centerContainer.backgroundColor = UIColor(245,245,245)
        centerContainer.translatesAutoresizingMaskIntoConstraints = false
        centerContainer.layer.cornerRadius = 10
        centerContainer.layer.masksToBounds = true
        containerView.addSubview(centerContainer)
        centerContainer.leftAnchor.constraint(equalTo: imageButton.rightAnchor, constant: 4).isActive = true
        centerContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        centerContainer.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        centerContainer.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -16).isActive = true
        
        
        
        centerContainer.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: centerContainer.leftAnchor, constant: 4).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerContainer.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: centerContainer.rightAnchor, constant: -24).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: centerContainer.heightAnchor).isActive = true
        
        //renderButton
        let renderButton = UIButton(type: .system)
        renderButton.backgroundColor = UIColor(245,245,245)
        renderButton.layer.cornerRadius = 10
        renderButton.layer.masksToBounds = true
        renderButton.setTitle("R", for: .normal)
        renderButton.translatesAutoresizingMaskIntoConstraints = false
        centerContainer.addSubview(renderButton)
        renderButton.addTarget(self, action: #selector(toRender), for: .touchUpInside)
        renderButton.rightAnchor.constraint(equalTo: centerContainer.rightAnchor, constant: -4).isActive = true
        renderButton.centerYAnchor.constraint(equalTo: centerContainer.centerYAnchor).isActive = true
        renderButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        renderButton.heightAnchor.constraint(equalTo: centerContainer.heightAnchor).isActive = true
        
        return containerView
    }()
    
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
                
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                DispatchQueue.main.async(execute:
                {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    let number = self.messages.count-1
                    if number > 1
                    {
                        let index = IndexPath(item: number, section: 0)
                        self.collectionView?.scrollToItem(at: index, at: .bottom, animated: true)
                    }
                })
            })
        })
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
        
        let message = messages[indexPath.item]
        
        if message.imageUrl == nil
        {
            let text = message.text
            height = estimateFrameForText(text: text!).height + 20
        }
        else
        {
            if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue
            {
                height = CGFloat(imageHeight / imageWidth * 200)
            }
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
        
        if message.imageUrl == nil
        {
            cell.textView.isHidden = false
            cell.textView.text = message.text
            setupCell(cell: cell, message: message)
            cell.messageImageView.isHidden = true
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        }
        else
        {
            cell.textView.isHidden = true
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: message.imageUrl!)
            cell.messageImageView.isHidden = false
            setupCell(cell: cell, message: message)
            cell.bubbleWidthAnchor?.constant = 200
        }
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message)
    {
        cell.motherController = self
        cell.message = message
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
    func sendText()
    {
        if(inputTextField.text! != "" && !inputTextField.text!.hasPrefix(" "))
        {
            let properties = ["text": inputTextField.text!]
            sendMessageWithProperties(properties: properties)
        }
    }
    
    func sendImage(imageUrl: String, image: UIImage)
    {
        let properties = ["text": "Image", "imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String: Any])
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let receiver = user!.id!
        let sender = FIRAuth.auth()!.currentUser!.uid
        let time: String = dateFormatter.string(from: Date())
        
        var values = ["sender": sender, "receiver": receiver, "time": time] as [String : Any]
        properties.forEach({values[$0] = $1})
        
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
        var selectedImage = UIImage()
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImage = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImage = originalImage
        }
        
        uploadImageToFirebase(image: selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(image: UIImage)
    {
        let imageName = NSUUID().uuidString
        let ref = FIRStorage.storage().reference().child("message-images").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image,0.2)
        {
            ref.put(uploadData, metadata: nil, completion:
            {
                (metadata, error) in
                
                if error != nil
                {
                    print(error)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString
                {
                    self.sendImage(imageUrl: imageUrl, image: image)
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func toRender()
    {
        if(inputTextField.text! != "" && !inputTextField.text!.hasPrefix(" "))
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            let receiver = user!.id!
            let sender = FIRAuth.auth()!.currentUser!.uid
            let time: String = dateFormatter.string(from: Date())
        
            let message2 = Message (dictionary: ["text": inputTextField.text!,"sender": sender, "receiver": receiver, "time": time] as [String : Any] as [String : AnyObject])
            let newController = RenderController(collectionViewLayout: UICollectionViewFlowLayout())
            newController.linkToChatController = self
            newController.message = message2
            self.navigationController?.pushViewController(newController, animated: true)
        }
    }
}


//Keyboard
extension ChatController
{
    func keyboardSettings()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardofInputTextField))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard2), name: .UIKeyboardDidShow, object: nil)
    }
    
    func dismissKeyboardofInputTextField()
    {
        inputTextField.resignFirstResponder()
    }
    
    func handleKeyboard2()
    {
        if messages.count > 1
        {
            let index = IndexPath(item: self.messages.count-1, section: 0)
            self.collectionView?.scrollToItem(at: index, at: .top, animated: true)
        }
    }
}





