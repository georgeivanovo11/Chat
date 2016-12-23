//
//  RenderController.swift
//  Chat
//
//  Created by george on 10/12/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Foundation
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
        
        print(similarity(str1: "What a nice day!", str2: "How are you?"))
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
            
            if isEnglish(str: (message?.text)!) == true
            {
                eng = (message?.text)!
                rus = text
            }
            else
            {
                eng = (message?.text)!
                rus = text
            }
            
            let isCorrect: String = "true"
        
            let values = ["eng": eng, "rus": rus, "author": author, "isCorrect": isCorrect] as [String : Any]
        
            childRef.updateChildValues(values)
        
            inputTextField.text = nil
        }
    }
    
    func downloadMemory()
    {
        let currentUserRer = FIRDatabase.database().reference().child("translation-memory")
        
        if (isEnglish(str: (message?.text)!) == true)
        {
        currentUserRer.observe(.childAdded, with:
            {
                (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject]
                    else {return}
                
                let a = dictionary["eng"]
                let b = self.message?.text
                let segment = Segment(dictionary: dictionary, similarity: self.similarity(str1: a as! String, str2: b!))
                
                if segment.rate! > 10.0
                {
                    self.memory.append(segment)
                }
                
                DispatchQueue.main.async(execute:
                {
                        self.collectionView?.reloadData()
                })
            })
        }
        else
        {
            currentUserRer.observe(.childAdded, with:
                {
                    (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject]
                        else {return}
                    
                    let a = dictionary["rus"]
                    let b = self.message?.text
                    let segment = Segment(dictionary: dictionary, similarity: self.similarity(str1: a as! String, str2: b!))
                    
                    if segment.rate! > 10.0
                    {
                        self.memory.append(segment)
                    }
                    
                    DispatchQueue.main.async(execute:
                        {
                            self.collectionView?.reloadData()
                    })
            })
        }
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
            cell.memory = memory
            cell.message = message
            cell.setupView()
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
    
    func similarity (str1: String, str2: String) ->Double
    {
        let str11 = str1.lowercased()
        let str22 = str2.lowercased()
        
        var mas1 = str11.components(separatedBy: [" ", "!", ".", "?", ","])
        var mas2 = str22.components(separatedBy: [" ", "!", ".", "?", ","])
        
        var count1 = mas1.count
        var i = 0
        
        while i < count1
        {
            if mas1[i] == " " || mas1[i] == ""
            {
                mas1.remove(at: i)
                i -= 1
                count1 -= 1
            }
            i += 1
        }
        
        var count2 = mas2.count
        i = 0
        
        while i < count2
        {
            if mas2[i] == " " || mas2[i] == ""
            {
                mas2.remove(at: i)
                i -= 1
                count2 -= 1
            }
            i += 1
        }
        
        var delitel = 1
        if mas1.count > mas2.count
        {
            delitel = mas1.count
        }
        else
        {
            delitel = mas2.count
        }
        
        var sum = 0
        
        for a in mas1
        {
            for b in mas2
            {
                if a == b
                {
                    sum += 1
                }
            }
        }
        
        print(delitel)
        print(sum)
        
        return (Double) (sum) / (Double) (delitel) * 100
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
