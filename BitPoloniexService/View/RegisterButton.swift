//
//  RegisterButton.swift
//  BitPoloniexService
//
//  Created by Anton on 18.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

class RegisterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTitleColor(#colorLiteral(red: 0, green: 0.4235294118, blue: 0.4392156863, alpha: 0.2529100251), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5960784314, blue: 0.6078431373, alpha: 1)
        isEnabled = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEnableState() {
        backgroundColor = #colorLiteral(red: 0, green: 0.4235294118, blue: 0.4392156863, alpha: 1)
        setTitleColor(.white, for: .normal)
    }
    
    func setupDisableState() {
        backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.5960784314, blue: 0.6078431373, alpha: 1)
        setTitleColor(#colorLiteral(red: 0, green: 0.4235294118, blue: 0.4392156863, alpha: 0.2529100251), for: .normal)
    }
    
}
