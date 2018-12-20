//
//  RegistrationViewModel.swift
//  BitPoloniexService
//
//  Created by Anton on 18.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

class RegistrationViewModel {

    var fullName: String? { didSet { checkFormValidity() }}
    var email: String? { didSet { checkFormValidity() }}
    var password: String? { didSet { checkFormValidity() }}
    
    var isFormValidObserver: ((Bool) -> ())?
    var isRegistrationObserver: ((Bool) -> ())?
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && isEmailValid(email)
        isFormValidObserver?(isFormValid)
    }
    
    fileprivate func isEmailValid(_ email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let fullName = fullName, let email = email, let password = password else { return }
        isRegistrationObserver?(true)
        ApiManager.shared.userRegistration(withFullName: fullName, email: email, password: password) { (err) in
            completion(err)
        }
    }
    
}
