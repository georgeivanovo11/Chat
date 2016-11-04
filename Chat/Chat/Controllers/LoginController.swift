//
//  LoginController.swift
//  Chat
//
//  Created by george on 28/10/2016.
//  Copyright © 2016 george. All rights reserved.
//

import UIKit
import Firebase

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
            button.setTitle("OK", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            
            //Actions:
            button.addTarget(self, action: #selector(toPressButton), for: .touchUpInside)
        
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

    lazy var profileImageView: UIImageView =
    {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "logo")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleToFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
        imageView.isUserInteractionEnabled = true
        
            return imageView
    }()
    
    lazy var segmentedControl: UISegmentedControl =
    {
            let sc = UISegmentedControl(items: ["Login","Check-in"])
            sc.translatesAutoresizingMaskIntoConstraints = false
            sc.tintColor = UIColor.white
            sc.selectedSegmentIndex = 1
            sc.addTarget(self, action: #selector(toChangeType), for: .valueChanged)
            return sc
    }()
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var profileImageViewWidthAnchor: NSLayoutConstraint?
    
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
        
        view.addSubview(segmentedControl)
        setupSegmentedControl()
    }

}

// MARK:- Actions of elements
extension LoginController
{
    func toPressButton()
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            toLogIn()
        }
        else
        {
            toCheckin()
        }
    }
    
    func toLogIn()
    {
        guard let tempEmail = emailTextField.text, let tempPassword = passwordTextField.text
        else
        {
            print("error1: no text in field")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: tempEmail, password: tempPassword, completion: nil)
        
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            print("error2: no such user in database")
        }
        else
        {
            //successfully auth
            self.navigationController?.pushViewController(DialogsController(), animated: true)
        }
    }
    
    func toCheckin()
    {
        guard let tempEmail = emailTextField.text, let tempPassword = passwordTextField.text, let tempName = nameTextField.text
            else
        {
            print("error1: no text in field")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: tempEmail, password: tempPassword, completion: nil)
        
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            print("error2: wrong input data")
        }
        else
        {
            //successfully auth
            let imageName = NSUUID().uuidString
            let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
            let storageRef = FIRStorage.storage().reference().child("ImagesOfUsers").child("\(imageName).png")
            
            let registerUser: ((FIRStorageMetadata?,Error?) -> Void) =
            {
                (metadata, error) in
                
                if error != nil
                {
                    print("error3: problems with server")
                    return
                }
                
                let imageURL = (metadata?.downloadURL()?.absoluteString)!
                let uid = FIRAuth.auth()?.currentUser?.uid
                let ref = FIRDatabase.database().reference(fromURL: "https://chat-6a19a.firebaseio.com/")
                let usersRef = ref.child("users").child(uid!)
                
                usersRef.updateChildValues(["name": tempName, "email": tempEmail, "imageURL": imageURL])
                
            }
            storageRef.put(uploadData!, metadata: nil, completion: registerUser)
            
            self.navigationController?.pushViewController(DialogsController(), animated: true)
        }

    }
    
    func toChangeType()
    {
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            inputsContainerViewHeightAnchor?.constant = 100
            
            nameTextFieldHeightAnchor?.isActive = false
            emailTextFieldHeightAnchor?.isActive = false
            passwordTextFieldHeightAnchor?.isActive = false
            
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            
            nameTextFieldHeightAnchor?.isActive = true
            emailTextFieldHeightAnchor?.isActive = true
            passwordTextFieldHeightAnchor?.isActive = true
            
            
            profileImageView.isUserInteractionEnabled = false
            profileImageView.image = UIImage(named: "logo")
            profileImageViewWidthAnchor?.isActive = false
            profileImageViewWidthAnchor = profileImageView.widthAnchor.constraint(equalToConstant: 250)
            profileImageViewWidthAnchor?.isActive = true
        }
        else
        {
            inputsContainerViewHeightAnchor?.constant = 150
            
            nameTextFieldHeightAnchor?.isActive = false
            emailTextFieldHeightAnchor?.isActive = false
            passwordTextFieldHeightAnchor?.isActive = false
            
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            
            nameTextFieldHeightAnchor?.isActive = true
            emailTextFieldHeightAnchor?.isActive = true
            passwordTextFieldHeightAnchor?.isActive = true
            
            
            profileImageView.isUserInteractionEnabled = true

        }
    }
}

// MARK:- PickerController
extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func chooseImage()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            profileImageViewWidthAnchor?.isActive = false
            profileImageViewWidthAnchor = profileImageView.widthAnchor.constraint(equalToConstant: 159)
            profileImageViewWidthAnchor?.isActive = true
            profileImageView.layer.cornerRadius = 10
            profileImageView.layer.masksToBounds = true

            profileImageView.image = editedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
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
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
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
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
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
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    func setupEmailSeparatorView()
    {
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPasswordTextField()
    {
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupProfileImageView()
    {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        profileImageViewWidthAnchor = profileImageView.widthAnchor.constraint(equalToConstant: 250)
        profileImageViewWidthAnchor?.isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 159).isActive = true
    }
    
    func setupSegmentedControl()
    {
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension UIColor
{
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}



