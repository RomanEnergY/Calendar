//
//  CalendarView+DayItemView.swift
//  Calendar
//
//  Created by ZverikRS on 13.10.2023.
//  Copyright © 2023 SCSR. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - delegate

protocol CalendarViewDayItemDelegate: AnyObject {
    func eventCell(_ view: CalendarView.DayItemView)
    func activePressed(_ view: CalendarView.DayItemView)
}

// MARK: - extension for DayItemView

extension CalendarView {
    final class DayItemView: BaseShadowContentView {
        struct ViewModel {
            let date: Date
            let isSelected: Bool
            let isActive: Bool
            
            init(
                date: Date,
                isSelected: Bool,
                isActive: Bool
            ) {
                self.date = date
                self.isSelected = isSelected
                self.isActive = isActive
            }
            
            static func notActive(date: Date) -> ViewModel {
                .init(
                    date: date,
                    isSelected: false,
                    isActive: false)
            }
        }
        
        // MARK: - public properties
        
        weak var delegate: CalendarViewDayItemDelegate?
        var model: ViewModel? {
            didSet {
                shadowType = model?.shadowType ?? .not
                layer.borderColor = (model?.borderColor ?? .clear).cgColor
                backgroundColor = model?.backgroundColor ?? .clear
                label.textColor = model?.textColor ?? .h000000
                label.text = model?.value ?? ""
            }
        }
        
        // MARK: - private properties
        
        private let label: BaseLabel = {
            let label: BaseLabel = .init()
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .h000000
            label.textAlignment = .center
            return label
        }()
        
        // MARK: - life cycle
        
        override func config() {
            super.config()
            shadowType = .not
            layer.borderWidth = 2
            layer.borderColor = UIColor.clear.cgColor
            layer.cornerRadius = 10
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))
        }
        
        override func addSubviews() {
            super.addSubviews()
            snp.makeConstraints {
                $0.size.equalTo(CGSize(rect: 40))
            }
            addSubview(label)
            label.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        // MARK: - private methods
        
        @objc private func onViewTap(_ sender: UIGestureRecognizer) {
            guard let model else { return }
            delegate?.eventCell(self)
            if model.isActive {
                sender.view?.blinkAlpha { [weak self] in
                    guard let self else { return }
                    self.delegate?.activePressed(self)
                }
            }
        }
    }
}

// MARK: - calculated properties

private extension CalendarView.DayItemView.ViewModel {
    var isCurrent: Bool {
        Date().equalsDay(for: date)
    }
    
    var value: String {
        "\(Calendar.current.component(.day, from: date))"
    }
    
    var borderColor: UIColor {
        isCurrent ? .h007AFF : .clear
    }
    
    var backgroundColor: UIColor {
        isSelected ? .h007AFF : .clear
    }
    
    var textColor: UIColor {
        if isActive {
            return isSelected ? .hFFFFFF : .h000000
        } else {
            return .hDDDDDD
        }
    }
    
    var shadowType: BaseView.ShadowType {
        isSelected ? .lightBlue : .not
    }
}
