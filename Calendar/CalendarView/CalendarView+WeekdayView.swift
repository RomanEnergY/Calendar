//
//  CalendarView+WeekdayView.swift
//  Calendar
//
//  Created by ZverikRS on 12.10.2023.
//  Copyright © 2023 SCSR. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - extension for WeekdayView

extension CalendarView {
    final class WeekdayView: BaseView {
        
        // MARK: - private properties
        
        private lazy var items: [String] = {
            (0 ..< 7).map { item in
                let firstWeekday = Calendar.current.firstWeekday
                return getWeekdaySymbol(for: Calendar.current.firstWeekday + item - 1)
            }
        }()
        
        // MARK: - life cycle
        
        override func addSubviews() {
            super.addSubviews()
            let stackView: BaseStackView = .init(
                axis: .horizontal,
                distribution: .equalSpacing)
            
            addSubview(stackView)
            stackView.addArrangedSubviews(items.map { getItemView(text: $0) })
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        // MARK: - private methods
        
        private func getItemView(text: String) -> BaseView {
            let view: BaseView = .init()
            let label: BaseLabel = .init()
            
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.textColor = .h000000
            label.textAlignment = .center
            label.text = text
            
            view.addSubview(label)
            label.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(40)
            }
            
            return view
        }
        
        private func getWeekdaySymbol(for dayCount: Int) -> String {
            switch dayCount {
            case 0:
                return "Вс"
            case 1:
                return "Пн"
            case 2:
                return "Вт"
            case 3:
                return "Ср"
            case 4:
                return "Чт"
            case 5:
                return "Пт"
            case 6:
                return "Сб"
            default:
                if dayCount < 0 {
                    return getWeekdaySymbol(for: dayCount + 7)
                } else {
                    return getWeekdaySymbol(for: dayCount - 7)
                }
            }
        }
    }
}
