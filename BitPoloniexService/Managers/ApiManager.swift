//
//  ApiManager.swift
//  BitPoloniexService
//
//  Created by Anton on 20.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import SwiftWebSocket
import JGProgressHUD

class ApiManager {
    
    static let shared = ApiManager()
    
    let chars = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().,!"
    let uri = "wss://api2.poloniex.com"
    let tickerChannel = "1002"
    var webSocket: WebSocket?
    
    var dataArray: [TickerModel] = []
    
    private init() {}
    
    func userLogin(withEmail: String, password: String, completion: @escaping (Error?) -> ()) {
        //some API call for login
        completion(nil)
    }
    
    func userRegistration(withFullName: String, email: String, password: String, completion: @escaping (Error?) -> ()) {
        //some API call for registration
        completion(nil)
    }
    

    let loginHUD = JGProgressHUD(style: .dark)

    func subscribeWebSocket(fromView: UIView, completion: @escaping (TickerModel) -> ()) {
        print("Subscribing to \(tickerChannel)")
        webSocket = WebSocket(uri)
        webSocket?.event.message = { message in
            if let text = message as? String {
                guard let index = (text.range(of: ",[")?.upperBound) else { return }
                let removeIdPart = String(text.suffix(from: index))
                let cuttedString = removeIdPart.filter({ self.chars.contains($0) })
                let items = cuttedString.components(separatedBy: ",")
                let ticker = TickerModel(with: items)

//                print("processing id \(ticker.id ?? "")")
                self.loginHUD.dismiss()
                completion(ticker)
            }
        }
        webSocket?.send("{\"command\": \"subscribe\", \"channel\": \(tickerChannel)}")
        self.loginHUD.textLabel.text = "Connecting..."
        self.loginHUD.show(in: fromView)
    }
    
    func unsubscribeWebSocket() {
        print("Unsubscribing to \(tickerChannel)")
        webSocket?.send("{\"command\": \"unsubscribe\", \"channel\": \(tickerChannel)}")
    }

}
