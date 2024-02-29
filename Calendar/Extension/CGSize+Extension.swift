//
//  Array+Extension.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import Foundation

// MARK: - extension for rectangle

extension CGSize {
    init(rect: CGFloat) {
        self.init(width: rect, height: rect)
    }
}
