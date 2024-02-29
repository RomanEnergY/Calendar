//
//  BaseView+Extension.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

// MARK: - extension for initializers

extension BaseView {
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}

// MARK: - extension for shadowContent

extension BaseView {
    enum ShadowType {
        case not
        case lightGray
        case lightBlue
        case lightBlueEasy
        case lightBlack
        
        fileprivate var shadowColor: UIColor {
            switch self {
            case .not:
                return .init(red: 0, green: 0, blue: 0, alpha: 0)
            case .lightGray:
                return .init(red: 0, green: 0, blue: 0, alpha: 0.15)
            case .lightBlue:
                return .init(red: 0, green: 0.478, blue: 1, alpha: 0.4)
            case .lightBlueEasy:
                return .init(red: 0, green: 0.478, blue: 1, alpha: 0.35)
            case .lightBlack:
                return .init(red: 0, green: 0, blue: 0, alpha: 0.4)
            }
        }
    }
    
    func setShadowContent(shadowType: ShadowType = .lightGray) {
        backgroundColor = .hFFFFFF
        layer.shadowColor = shadowType.shadowColor.cgColor
        layer.shadowOpacity = shadowType == .not ? 0 : 1
        layer.shadowRadius = shadowType == .not ? 0 : 20
        layer.shadowOffset = .zero
        clipsToBounds = shadowType == .not
    }
}
