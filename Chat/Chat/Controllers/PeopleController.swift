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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.textLabel?.text = "Hey nigga!"
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
