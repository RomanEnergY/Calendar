//
//  BaseShadowContentView.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

// MARK: - class

class BaseShadowContentView: BaseView {
    
    // MARK: - private properties
    
    var shadowType: ShadowType {
        didSet {
            showShadow()
        }
    }
    
    // MARK: - initializers
    
    init(
        frame: CGRect = .zero,
        shadowType: ShadowType = .lightGray
    ) {
        self.shadowType = shadowType
        super.init(frame: frame)
    }
    
    override func config() {
        super.config()
        layer.cornerRadius = 15
        showShadow()
    }
    
    // MARK: - public methods
    
    func showShadow() {
        setShadowContent(shadowType: shadowType)
    }
}
