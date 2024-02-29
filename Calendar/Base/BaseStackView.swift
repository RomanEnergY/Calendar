//
//  BaseStackView.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

// MARK: - class

class BaseStackView: UIStackView {
    
    // MARK: - initializers
    
    override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 0
        alignment = .fill
        distribution = .fill
        
        config()
        addSubviews()
    }
    
    init(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) {
        super.init(frame: .zero)
        self.spacing = spacing
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        
        config()
        addSubviews()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    
    func config() {
        backgroundColor = .clear
    }
    
    func addSubviews() {
    }
}
