//
//  CustomTextField.swift
//  BitPoloniexService
//
//  Created by Anton on 18.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding: CGFloat
    
    init(padding: CGFloat = 16, placeholder: String) {
        self.padding = padding
        super.init(frame: .zero)
        self.placeholder = placeholder
        tintColor = #colorLiteral(red: 0, green: 0.4235294118, blue: 0.4392156863, alpha: 1)
        layer.cornerRadius = 8
        layer.borderColor = #colorLiteral(red: 0.6745098039, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
        layer.borderWidth = 1
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

