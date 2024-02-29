//
//  UIColor+Extension.swift
//  Kvik
//
//  Created by rasul on 9/30/20.
//

import UIKit

extension UIColor {
    convenience init(_ hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }
    
    /// Белый
    static let hFFFFFF = UIColor("FFFFFF", alpha: 1)
    /// Черный
    static let h000000 = UIColor("000000", alpha: 1)
    /// Серый
    static let h888888 = UIColor("888888", alpha: 1)
    /// Синий
    static let h007AFF = UIColor("007AFF", alpha: 1)
    /// Серый
    static let hDDDDDD = UIColor("DDDDDD", alpha: 1)
}
