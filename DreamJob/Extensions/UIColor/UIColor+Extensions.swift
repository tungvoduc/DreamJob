//
//  UIColor+Extensions.swift
//  DreamJob
//
//  Created by Vo Tung on 09/03/2019.
//  Copyright © 2019 Vo Tung. All rights reserved.
//

import UIKit

extension UIColor {
    // For use with css style hex strings #FFFFFF
    convenience init(hex: String) {
        let index = hex.index(hex.startIndex, offsetBy: 1)
        var hexstring = String(hex[index...])
        hexstring = "0x" + hexstring
        let scanner = Scanner(string: hexstring)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    static var available: UIColor {
        return UIColor(hex: "#02A676")
    }
    
    static var notAvailable: UIColor {
        return UIColor(hex: "#D82B03")
    }
}
