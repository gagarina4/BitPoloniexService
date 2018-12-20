//
//  ViewController.swift
//  BitPoloniexService
//
//  Created by Anton on 18.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit
import JGProgressHUD

class RegistrartionController: UIViewController {

//    var delegate: LoginControllerDelegate?
    
    let logoView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 98).isActive = true
        return view
    }()
    
    let fullNameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Enter full name")
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Enter email")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Enter password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return tf
    }()
    
    let registerButton: RegisterButton = {
        let btn = RegisterButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return btn
    }()
    
    let goToLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Go to Login", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return btn
    }()

    //MARK:- LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupKeyboadNotificationObservers()
        setupKeyboadDismissTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    //MARK:- Fileprivate
    
    //MARK:- TextField Observer
    
    @objc fileprivate func handleTextChanged(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }

    let registrationViewModel = RegistrationViewModel()
    let loginHUD = JGProgressHUD(style: .dark)
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.setupEnableState()
            } else {
                self.registerButton.setupDisableState()
            }
        }
        
        registrationViewModel.isRegistrationObserver = { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Registeration..."
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
    
    fileprivate func setupKeyboadNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - verticalStackView.frame.origin.y - verticalStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
    }
    
    @objc fileprivate func handleKeyboardDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    //MARK:- SetupLayout

    lazy var verticalStackView = UIStackView(arrangedSubviews: [logoView,
                                                                fullNameTextField,
                                                                emailTextField,
                                                                passwordTextField,
                                                                registerButton])
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        self.view.addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let logoImage = UIImageView(image: UIImage(named: "logo_colored"))
        logoView.addSubview(logoImage)
        logoImage.anchor(top: logoView.topAnchor, leading: logoView.leadingAnchor, bottom: logoView.bottomAnchor, trailing: logoView.trailingAnchor)
        logoImage.contentMode = .scaleAspectFit
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    //MARK:- Button Actions
    
    @objc fileprivate func handleRegistration() {
        registrationViewModel.performRegistration { (err) in
            self.loginHUD.dismiss()
            if let err = err {
            print("Failed to reg:", err)
            return
            }
            
            UserManager.user.signIn()
            self.dismiss(animated: true, completion: {
//                self.delegate?.didFinishLoggingIn()
            })
        }
    }
    
    @objc fileprivate func handleGoToLogin() {
        let loginController = LoginController()
//        loginController.delegate = delegate
        navigationController?.pushViewController(loginController, animated: true)
    }
    
}
