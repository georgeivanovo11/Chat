//
//  LoginController.swift
//  Chat
//
//  Created by george on 28/10/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit

class LoginController: UIViewController
{
    let inputsContainerView: UIView =
        {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            return view
    } ()
    
    lazy var loginRegisterButton: UIButton =
        {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(80, 101, 161)
            button.setTitle("Check-in", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            
            //Actions:
            button.addTarget(self, action: #selector(toCheckIn), for: .touchUpInside)
        
            return button
    } ()
    
    let nameTextField: UITextField =
        {
            let text = UITextField()
            text.placeholder = "Name"
            text.translatesAutoresizingMaskIntoConstraints = false
            return text
    }()
    
    let nameSeparatorView: UIView =
        {
            let view = UIView()
            view.backgroundColor = UIColor(220, 220,220)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
    }()
    
    let emailTextField: UITextField =
        {
            let text = UITextField()
            text.placeholder = "Email"
            text.translatesAutoresizingMaskIntoConstraints = false
            return text
    }()
    
    let emailSeparatorView: UIView =
        {
            let view = UIView()
            view.backgroundColor = UIColor(220, 220, 220)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
    }()
    
    let passwordTextField: UITextField =
        {
            let text = UITextField()
            text.placeholder = "Password"
            text.translatesAutoresizingMaskIntoConstraints = false
            text.isSecureTextEntry = true
            return text
    }()

    let profileImageView: UIImageView =
        {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "logo")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleToFill
            return imageView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(61,91,151)
        
        view.addSubview(inputsContainerView)
        setupInputsContainerView()
        
        view.addSubview(loginRegisterButton)
        setupLoginRegisterButton()
        
        view.addSubview(profileImageView)
        setupProfileImageView()
    }

}

// MARK:- Actions of elements
extension LoginController
{
    func toCheckIn()
    {
        self.navigationController?.pushViewController(PersonController(), animated: true)
        
    }
}

// MARK:- Location of elements
extension LoginController
{
    func setupInputsContainerView()
    {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        setupNameTextField()
        inputsContainerView.addSubview(nameSeparatorView)
        setupNameSeparatorView()
        inputsContainerView.addSubview(emailTextField)
        setupEmailTextField()
        inputsContainerView.addSubview(emailSeparatorView)
        setupEmailSeparatorView()
        inputsContainerView.addSubview(passwordTextField)
        setupPasswordTextField()
    }
    
    func setupLoginRegisterButton()
    {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupNameTextField()
    {
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupNameSeparatorView()
    {
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupEmailTextField()
    {
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupEmailSeparatorView()
    {
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true    }
    
    func setupPasswordTextField()
    {
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupProfileImageView()
    {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 159).isActive = true
    }
}

extension UIColor
{
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}



