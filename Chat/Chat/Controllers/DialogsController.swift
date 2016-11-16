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
        
        checkIsLoggedIn()
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
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User)
    {
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
}
