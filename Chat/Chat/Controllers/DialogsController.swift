//
//  PersonController.swift
//  Chat
//
//  Created by george on 28/10/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class DialogsController: UITableViewController
{
    var messages = [Message]()
    var messageDictionary = [String: Message]()
    let cellId = "cellId"
    var timer: Timer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(255,255,255)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(handleNewDialog))
        
        checkIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
    }
    
}

extension DialogsController
{
    func checkIsLoggedIn()
    {
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            handleLogout()
        }
        else
        {
            downloadInfo()
        }
    }
    
    func downloadInfo()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid
        else {return}
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with:
        {
            (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User)
    {
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        downloadUserMessages()
        
        self.navigationItem.title = user.name
    }
    
    func handleLogout()
    {
        do
        {
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutError
        {
            print(logoutError)
        }
        
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    func handleNewDialog()
    {
        self.navigationController?.pushViewController(PeopleController(), animated: true)
    }
    
    func showChatForUser(user: User)
    {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    func downloadUserMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid
        else {return}
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with:
        {
            (snapshot) in
            
            let userId = snapshot.key
            let ref2 = FIRDatabase.database().reference().child("user-messages").child(uid).child(userId)
            ref2.observe(.childAdded, with:
            {
                (snapshot) in
                let messageId = snapshot.key
                self.getMessageFromMessageId(messageId: messageId)
            })
            
        })
    }
    
    private func getMessageFromMessageId(messageId: String)
    {
        let messageRef = FIRDatabase.database().reference().child("messages").child(messageId)
        
        messageRef.observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    let message = Message(dictionary: dictionary)
                    
                    if let chatPartnerId = message.partnerId()
                    {
                        self.messageDictionary[chatPartnerId] = message
                    }
                    
                    self.attemptReloadOfTable()
                }
        })

    }
    
    private func attemptReloadOfTable()
    {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer (withTimeInterval: 0.5, repeats: false, block:
        {
            (Timer) in
            self.messages = Array (self.messageDictionary.values)
            self.messages.sort(by:
                {
                    (m1,m2)->Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                    
                    let a = dateFormatter.date(from: m1.time!)!
                    let b = dateFormatter.date(from: m2.time!)!
                    
                    return a > b
            })
            DispatchQueue.main.async(execute: {self.tableView.reloadData()})
                
        })
    }
    
    private func handleReloadTable()
    {
        
    }
}

//Table func
extension DialogsController
{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.showUserMessage(message: message)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let message = messages[indexPath.row]
        guard let id = message.partnerId()
        else
        {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(id)
        ref.observeSingleEvent(of: .value, with:
        {
            (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject]
            else
            {return}
            
            let tempUser = User()
            tempUser.setValuesForKeys(dictionary)
            tempUser.id = id
            self.showChatForUser(user: tempUser)
        })
    }
}




