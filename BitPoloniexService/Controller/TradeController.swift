//
//  TradeController.swift
//  BitPoloniexService
//
//  Created by Anton on 19.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit
import SwiftWebSocket

//protocol LoginControllerDelegate {
//    func didFinishLoggingIn()
//}

class TradeController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentifier = "TickerCell"
    let cellSecondIdentifier = "TickerSecondCell"
    var dataArray: [TickerViewModel] = []
    var cells: [BaseTradeCell] = []
    
    let limitValueField: UITextField = {
        let tf = CustomTextField(placeholder: "Enter limit value")
        tf.keyboardType = .numbersAndPunctuation
        return tf
    }()
    
    let tableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tb.separatorStyle = .none
        return tb
    }()
    
    //MARK:- LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        
        limitValueField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: cellSecondIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        let valueView = UIView()
        valueView.addSubview(limitValueField)
        limitValueField.anchor(top: valueView.topAnchor, leading: valueView.leadingAnchor, bottom: valueView.bottomAnchor, trailing: valueView.trailingAnchor, padding: .init(top: 4, left: 100, bottom: 4, right: 100))
        view.addSubview(valueView)
        valueView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        view.addSubview(tableView)
        tableView.anchor(top: valueView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TradeController did appear")
        
        if UserManager.user.isLogged() {
            startListeningWebSocket()
        } else {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showAutorisationScreen(from: self)
            }
        }
    }
    
    //MARK:- Fileprivate
    
    //MARK:- FetchData

    func startListeningWebSocket(){
        print("Run Data Fetching")
        ApiManager.shared.subscribeWebSocket(fromView: self.view) { (ticker) in
            if let cTicker = self.dataArray.first(where: {$0.id == ticker.id}) {
                cTicker.lastTradePrice = ticker.lastTradePrice
                cTicker.lowestAsk = ticker.lowestAsk
                cTicker.highestBid = ticker.highestBid
                cTicker.baseCurrencyVolume = ticker.baseCurrencyVolume
            } else {
                var cell: BaseTradeCell!
                if UserManager.user.getCurrentTradeStyle() {
                    cell = Bundle.main.loadNibNamed(self.cellSecondIdentifier, owner: self, options: nil)?[0] as! TickerSecondCell
                } else {
                    cell = Bundle.main.loadNibNamed(self.cellIdentifier, owner: self, options: nil)?[0] as! TickerCell
                }
                self.cells.append(cell)
                self.dataArray.append(ticker.convertToTickerViewModel())
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath.init(row: self.dataArray.count-1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
    
    //MARK:- UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        cell.tickerViewModel = dataArray[indexPath.row]
        return cell
    }
    
    //MARK:- SetupLayout
    
    fileprivate func setupNavigationItems() {
        navigationController?.navigationBar.isTranslucent = false;
        navigationController?.navigationBar.barTintColor = UIColor.color_blueLight()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "Trade Highlight"
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.color_blueLight()
        }
        view.backgroundColor = .white
        
        let leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Style", style: .plain, target: self, action: #selector(handleStyle))
        rightBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //MARK:- Button Actions
    
    @objc fileprivate func handleLogout() {
        UserManager.user.signOut()
        ApiManager.shared.unsubscribeWebSocket()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showAutorisationScreen(from: self)
        }
    }

    @objc fileprivate func handleStyle() {
        cells.removeAll()
        let currentTradeStyle = UserManager.user.changeTradeStyle(with: UserManager.user.getCurrentTradeStyle())
        var cell: BaseTradeCell!
        dataArray.forEach {_ in
            if currentTradeStyle {
                cell = Bundle.main.loadNibNamed(self.cellSecondIdentifier, owner: self, options: nil)?[0] as! TickerSecondCell
            } else {
                cell = Bundle.main.loadNibNamed(self.cellIdentifier, owner: self, options: nil)?[0] as! TickerCell
            }
            self.cells.append(cell)
        }
        tableView.reloadData()
    }

}

extension TradeController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            let array = Array(textField.text!)
            var decimalCount = 0
            for character in array {
                if character == "." {
                    decimalCount+=1
                }
            }
            if decimalCount == 1 {
                return false
            } else {
                return true
            }
        default:
            let array = Array(string)
            if array.count == 0 {
                return true
            }
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let _ = Double(textField.text!) {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.dataArray.forEach { (tickerViewModel) in
            if let value = Double(textField.text!) {
                tickerViewModel.updateLimitValue(newLimitValue: value)
            }
        }
    }
    
}

//extension TradeController: LoginControllerDelegate {
//
//    func didFinishLoggingIn() {
//        startListeningWebSocket()
//    }
//
//}
