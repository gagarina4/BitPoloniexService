//
//  UserManager.swift
//  BitPoloniexService
//
//  Created by Anton on 19.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import Foundation

class UserManager {
    
    let kUserLogged = "userLogged"
    let kUserTradeStyle = "userTradeStyle"
    
    static let user = UserManager()
    
    private init() {}
    
    func signIn() {
        UserDefaults.standard.set(true, forKey: kUserLogged)
    }
    
    func signOut() {
        UserDefaults.standard.set(false, forKey: kUserLogged)
    }
    
    func isLogged() -> Bool {
        return UserDefaults.standard.bool(forKey: kUserLogged)
    }
    
    func changeTradeStyle(with style: Bool) -> Bool {
        UserDefaults.standard.set(!style, forKey: kUserTradeStyle)
        return UserDefaults.standard.bool(forKey: kUserTradeStyle)
    }
    
    func getCurrentTradeStyle() -> Bool {
        return UserDefaults.standard.bool(forKey: kUserTradeStyle)
    }

}
