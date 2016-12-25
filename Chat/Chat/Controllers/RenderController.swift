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
    public var linkToChatController: ChatController? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Render"
        collectionView?.backgroundColor = UIColor.white
        //collectionView?.contentInset = UIEdgeInsets(top: 130, left: 10, bottom: 10, right: 0)
        
        collectionView?.alwaysBounceVertical = false
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.isScrollEnabled = false
        collectionView?.register(OriginMessageCell.self, forCellWithReuseIdentifier: cellId1)
        collectionView?.register(TranslationCell.self, forCellWithReuseIdentifier: cellId2)
        
        downloadMemory()

    }
}

//Action
extension RenderController
{
   /* func saveSegment()
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
    */
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
                
                self.memory.sort(by:
                {
                        (m1, m2) -> Bool in
                        return m1.rate! > m2.rate!
                })
                
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
                    
                    self.memory.sort(by:
                        {
                            (m1, m2) -> Bool in
                            return m1.rate! > m2.rate!
                    })
                    
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
            cell.motherController = self
            cell.linkToChatController = linkToChatController
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
        if indexPath.row == 0
        {
            return CGSize(width: view.frame.width, height: 340)
        }
        else
        {
            return CGSize(width: view.frame.width, height: 150)
        }
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
        /*print("-------")
        for a in mas1
        {
           print(a)
        }
        
        for b in mas2
        {
            print(b)
        }
        print(sum)
        print(delitel)
        print("-------")*/
        return (Double) (sum) / (Double) (delitel) * 100
    }
    
}

//Keyboard
/*extension RenderController
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
    
}*/
