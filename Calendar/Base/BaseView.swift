//
//  BaseView.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

// MARK: - class

class BaseView: UIView {
    
    // MARK: - initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        config()
        addSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    
    func config() {
        backgroundColor = .clear
    }
    
    func addSubviews() { }
}
