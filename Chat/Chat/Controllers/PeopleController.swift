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
        
        fetchUser()
    }
    
    func fetchUser()
    {
        let getUsers: ((FIRDataSnapshot) -> Void) =
        {
            (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let tempUser = User()
                tempUser.name = dictionary["name"] as! String?
                tempUser.email = dictionary["email"] as! String?
                print(tempUser.name! + "\n")
                self.users.append(tempUser)
            }
            
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
        
        FIRDatabase.database().reference().child("Users").observeSingleEvent(of: .childAdded, with: getUsers, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let tempUser = users[indexPath.row]
        cell.textLabel?.text = tempUser.name
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
