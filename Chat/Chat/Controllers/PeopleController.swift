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
                tempUser.name = dictionary["name"] as! String?
                tempUser.email = dictionary["email"] as! String?
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let tempUser = users[indexPath.row]
        cell.textLabel?.text = tempUser.name
        cell.detailTextLabel?.text = tempUser.email
        
        return cell
    }
    
}

extension PeopleController
{
    func handleCancel()
    {
        self.navigationController?.pushViewController(DialogsController(), animated: true)
    }
}

class UserCell: UITableViewCell
{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


