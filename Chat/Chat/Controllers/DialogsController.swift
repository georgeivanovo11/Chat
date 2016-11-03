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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(255,255,255)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(handleNewDialog))
        
        downloadInfo()
    }
    
    func downloadInfo()
    {
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            handleLogout()
        }
        else
        {
            // Write name of the User in the Bar
            let setTitle: ((FIRDataSnapshot) -> Void) =
            {
                (snapshop) in
                
                let dictionary = snapshop.value as? [String: AnyObject]
                self.navigationItem.title = dictionary?["name"] as? String
            }
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: setTitle, withCancel: nil)
            
        }
        
    }

}

extension DialogsController
{
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
}
