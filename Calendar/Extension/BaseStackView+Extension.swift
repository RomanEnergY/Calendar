//
//  BaseStackView.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit

extension BaseStackView {
    /// Выполнить для всех arrangedSubviews метод removeFromSuperview
    func removeAllArrangedSubview() {
        let arrangedSubviews: [UIView] = arrangedSubviews
        arrangedSubviews.reversed().forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    /// Для передаваемого массива views выполнить метод  addArrangedSubview
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
