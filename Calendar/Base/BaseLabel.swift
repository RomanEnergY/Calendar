//
//  BaseLabel.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

// MARK: - class

class BaseLabel: UILabel {
    
    // MARK: - enum
    
    enum LineBreakType {
        case pushOut
        case normal
    }
    
    // MARK: - private properties
    
    private let hitTestBoundsInsetByd: CGFloat
    
    // MARK: - initializers
    
    init(hitTestBoundsInsetByd: CGFloat = 0) {
        self.hitTestBoundsInsetByd = hitTestBoundsInsetByd
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertToSelfView = convert(point, to: self)
        let newBounds: CGRect = bounds.insetBy(dx: -hitTestBoundsInsetByd, dy: -hitTestBoundsInsetByd)
        if isUserInteractionEnabled, newBounds.contains(convertToSelfView) {
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }
}
