//
//  PersonController.swift
//  Chat
//
//  Created by george on 28/10/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class PersonController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = UIColor(255,255,255)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }

}

extension PersonController
{
    func handleLogout()
    {
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
}
