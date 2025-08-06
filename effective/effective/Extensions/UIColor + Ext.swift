//
//  UIColor + Ext.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var intValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&intValue)
        
        let a, r, g, b: UInt64
        
        let start = hex.index(hex.startIndex, offsetBy: 0)
        let rString = String(hex[start..<hex.index(hex.startIndex, offsetBy: 2)])
        let gString = String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])
        let bString = String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.endIndex])
        
        r = UInt64(rString, radix: 16) ?? 0
        g = UInt64(gString, radix: 16) ?? 0
        b = UInt64(bString, radix: 16) ?? 0
        
        a = 255
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
