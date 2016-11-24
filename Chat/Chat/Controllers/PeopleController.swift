//
//  PeopleController.swift
//  Chat
//
//  Created by george on 03/11/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

class PeopleController: UITableViewController
{
    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        self.navigationItem.title = "People"
        downloadListOfUsers()
        
    }
    
    func downloadListOfUsers()
    {
        let getUsers: ((FIRDataSnapshot) -> Void) =
        {
            (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let tempUser = User()
                tempUser.id = snapshot.key
                tempUser.name = dictionary["name"] as! String?
                tempUser.email = dictionary["email"] as! String?
                tempUser.imageURL = dictionary ["imageURL"] as! String?
                self.users.append(tempUser)
            }
            DispatchQueue.main.async(execute: {self.tableView.reloadData()})
        }
        
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: getUsers)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let tempUser = users[indexPath.row]
        cell.textLabel?.text = tempUser.name
        cell.detailTextLabel?.text = tempUser.email

        
        if let imageUrl = tempUser.imageURL
        {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = self.users[indexPath.row]
        let dc = DialogsController()
        self.navigationController?.pushViewController(dc, animated: true)
        dc.showChatForUser(user: user)
        
    }
    
}

extension PeopleController
{
    func handleCancel()
    {
        self.navigationController?.pushViewController(DialogsController(), animated: true)
    }
}




