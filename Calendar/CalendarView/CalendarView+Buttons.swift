//
//  CalendarView+Buttons.swift
//  Calendar
//
//  Created by ZverikRS on 12.10.2023.
//  Copyright © 2023 SCSR. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - extension for Buttons

extension CalendarView {
    class HeaderBaseButton: UIButton {
        
        // MARK: - public properties
        
        override var isEnabled: Bool {
            didSet {
                super.isEnabled = isEnabled
                tintColor = isEnabled ? .h000000 : .h888888
            }
        }
        
        // MARK: - initializers
        
        init() {
            super.init(frame: .zero)
            let image: UIImage? = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            setImage(image, for: .normal)
            setImage(image, for: .highlighted)
            tintColor = .h000000
            backgroundColor = .hFFFFFF
            layer.cornerRadius = 10
            snp.makeConstraints {
                $0.size.equalTo(CGSize(rect: 30))
            }
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension CalendarView {
    final class HeaderLeftButton: HeaderBaseButton {
        override init() {
            super.init()
            transform = transform.rotated(by: .pi)
        }
    }
}

extension CalendarView {
    final class HeaderRightButton: HeaderBaseButton {
        
    }
}
