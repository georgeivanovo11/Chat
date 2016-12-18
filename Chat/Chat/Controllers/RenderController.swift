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
    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Render"
        collectionView?.backgroundColor = UIColor.white
        //collectionView?.contentInset = UIEdgeInsets(top: 130, left: 10, bottom: 10, right: 0)
        
        collectionView?.alwaysBounceVertical = false
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.register(OriginMessageCell.self, forCellWithReuseIdentifier: cellId1)
        collectionView?.register(TranslationCell.self, forCellWithReuseIdentifier: cellId2)
        
        downloadMemory()
        //setupOutputContainerView()
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

//Collection view
extension RenderController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! OriginMessageCell
            cell.message1 = message
            cell.setupView()
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! TranslationCell
            return cell
        }
    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width, height: 150)
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
