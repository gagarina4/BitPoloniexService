//
//  Extensions+UIColor.swift
//  BitPoloniexService
//
//  Created by Anton on 18.12.2018.
//  Copyright © 2018 InterviewTask. All rights reserved.
//

import UIKit

extension UIColor {

    class func color_blueDark() -> UIColor {
        return hexStringToUIColor("#006C70")
    }
    
    class func color_blueLight() -> UIColor {
        return hexStringToUIColor("#4D989B")
    }
    
    class func hexStringToUIColor(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
