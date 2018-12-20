//
//  LoginController.swift
//  BitPoloniexService
//
//  Created by Anton on 18.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit
import JGProgressHUD

class LoginController: UIViewController {

//    var delegate: LoginControllerDelegate?
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Enter email")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Enter password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: RegisterButton = {
        let btn = RegisterButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    fileprivate let backToRegisterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Go back", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupKeyboadDismissTapGesture()
        setupLoginViewModelObservers()
    }
    
    //MARK:- Fileprivate
    
    //MARK:- TextField Observer
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    let loginViewModel = LoginViewModel()
    let loginHUD = JGProgressHUD(style: .dark)
    
    fileprivate func setupLoginViewModelObservers() {
        loginViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
            self.loginButton.isEnabled = isFormValid
            if isFormValid {
                self.loginButton.setupEnableState()
            } else {
                self.loginButton.setupDisableState()
            }
        }
        
        loginViewModel.isLoggingInObserver = { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Login..."
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    //MARK:- Keyboard
    
    fileprivate func setupKeyboadDismissTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }

    //MARK:- SetupLayout
    
    lazy var verticalStackView = UIStackView(arrangedSubviews: [emailTextField,
                                                                passwordTextField,
                                                                loginButton,
                                                                ])
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        self.view.addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    //MARK:- Button Actions
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { (err) in
            self.loginHUD.dismiss()
            if let err = err {
                print("Failed to log in:", err)
                return
            }

            UserManager.user.signIn()
            self.dismiss(animated: true, completion: {
//                self.delegate?.didFinishLoggingIn()
            })
        }
    }
    
}
