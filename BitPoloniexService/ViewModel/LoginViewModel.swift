//
//  LoginViewModel.swift
//  BitPoloniexService
//
//  Created by Anton on 19.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

class LoginViewModel {
    
    var email: String? { didSet { checkFormValidity() }}
    var password: String? { didSet { checkFormValidity() }}
    
    var isFormValidObserver: ((Bool) -> ())?
    var isLoggingInObserver: ((Bool) -> ())?
    
    fileprivate func checkFormValidity() {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false && isEmailValid(email)
        isFormValidObserver?(isFormValid)
    }
    
    fileprivate func isEmailValid(_ email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingInObserver?(true)
        ApiManager.shared.userLogin(withEmail: email, password: password) { (err) in
            completion(err)
        }
    }
    
}
