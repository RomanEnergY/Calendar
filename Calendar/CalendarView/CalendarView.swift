//
//  CalendarView.swift
//  Calendar
//
//  Created by ZverikRS on 12.10.2023.
//  Copyright © 2023 SCSR. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - class

final class CalendarView: BaseView {
    
    // MARK: - public properties
    
    var model: CalendarViewModel? {
        didSet {
            updateView()
        }
    }
    
    // MARK: - private properties
    
    private let insetHitTest: CGFloat = 20
    private let pageMonthView: PageMonthView = .init()
    private let leftButton: HeaderLeftButton = .init()
    private let rightButton: HeaderRightButton = .init()
    
    // MARK: - life cycle
    
    override func config() {
        super.config()
        clipsToBounds = true
        pageMonthView.delegate = self
        leftButton.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(onButtonPressed), for: .touchUpInside)
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(pageMonthView)
        pageMonthView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        let backButtonView: BaseView = .init(backgroundColor: .hFFFFFF)
        addSubview(backButtonView)
        
        addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(10)
        }
        addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.top.bottom.equalTo(rightButton)
            $0.trailing.equalTo(rightButton.snp.leading).offset(-6)
        }
        
        backButtonView.snp.makeConstraints {
            $0.leading.equalTo(leftButton.snp.centerX)
            $0.top.equalTo(leftButton)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(rightButton)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let leftButtonHitTestBounds: CGRect = .init(
            origin: .init(
                x: 0,
                y: -insetHitTest),
            size: .init(
                width: leftButton.bounds.size.width + insetHitTest,
                height: leftButton.bounds.size.height + (insetHitTest * 2)))
        
        let rightButtonHitTestBounds: CGRect = .init(
            origin: .init(
                x: 0,
                y: -insetHitTest),
            size: .init(
                width: rightButton.bounds.size.width + insetHitTest,
                height: rightButton.bounds.size.height + (insetHitTest * 2)))
        
        if leftButtonHitTestBounds.contains(convert(point, to: leftButton)) {
            return leftButton
        } else if rightButtonHitTestBounds.contains(convert(point, to: rightButton)) {
            return rightButton
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    // MARK: - private methods
    
    private func updateView() {
        isHidden = model?.dates.isEmpty ?? true
        pageMonthView.model = model?.viewModel
    }
    
    private func onLeftButtonPressed() {
        pageMonthView.lastPage()
    }
    
    private func onRightButtonPressed() {
        pageMonthView.nextPage()
    }
    
    @objc private func onButtonPressed(_ sender: UIButton) {
        switch sender {
        case leftButton:
            if leftButton.isEnabled {
                sender.blinkAlpha { [weak self] in
                    self?.onLeftButtonPressed()
                }
            }
            
        case rightButton:
            if rightButton.isEnabled {
                sender.blinkAlpha { [weak self] in
                    self?.onRightButtonPressed()
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - extension for CalendarPageMonthViewDelegates

extension CalendarView: CalendarPageMonthViewDelegate {
    func eventCell(_ view: DayItemView) {
        guard let date = view.model?.date else { return }
        DispatchQueue.main.async { [weak self] in
            self?.model?.onCallPressed(date)
        }
    }
    
    func activePressed(_ view: DayItemView) {
        guard let date = view.model?.date else { return }
        if model?.selectedDate != nil && model?.selectedDate == date {
            model?.selectedDate = nil
        } else {
            model?.selectedDate = date
        }
        
        updateView()
        DispatchQueue.main.async { [weak self] in
            self?.model?.onPressed(self?.model?.selectedDate)
        }
    }
    
    func calendarPageMonthViewUpdateHiddenButton(isLast: Bool, isNext: Bool) {
        leftButton.isHidden = isLast
        rightButton.isHidden = isNext
    }
    
    func calendarPageMonthViewUpdateScrollRectToVisible(isLast: Bool, isNext: Bool) {
        leftButton.isEnabled = isLast
        rightButton.isEnabled = isNext
    }
}

// MARK: - calculated properties

extension CalendarViewModel {
    var viewModel: CalendarView.PageMonthView.ViewModel {
        let calendarDates: [Array.ActiveDate] = dates
            .sorted(by: { $0.timeIntervalSince1970 < $1.timeIntervalSince1970 })
            .calendarDates
        
        return .init(
            days: calendarDates.map { item in
                    .init(
                        date: item.date,
                        isSelected: item.date == selectedDate,
                        isActive: item.isActive)
            })
    }
}

private extension Array where Element == Date {
    struct ActiveDate {
        let date: Date
        let isActive: Bool
    }
    
    var calendarDates: [ActiveDate] {
        var calendarDates: [ActiveDate] = []
        let dates = Set<Date>(self).sorted(by: { $0.timeIntervalSince1970 < $1.timeIntervalSince1970 })
        dates.enumerated().forEach { enumerate in
            if let lastElement = dates[safe: enumerate.offset - 1] {
                let countLastDay = Calendar.current.dateComponents([.day], from: lastElement, to: enumerate.element).day ?? 0
                if let index = calendarDates.firstIndex(where: { $0.date == lastElement }) {
                    if countLastDay > 1 {
                        calendarDates.insert(
                            contentsOf: createNotActiveDay(for: enumerate.element, count: countLastDay - 1),
                            at: index + 1)
                    }
                }
            }
            
            calendarDates.append(.init(
                date: enumerate.element,
                isActive: true))
        }
        
        return calendarDates
    }
    
    private func createNotActiveDay(for date: Date, count: Int) -> [ActiveDate] {
        var calendarDates: [ActiveDate] = []
        (1 ... count).forEach { i in
            if let day = Calendar.current.date(byAdding: .day, value: -(i), to: date) {
                calendarDates.insert(
                    .init(date: day, isActive: false),
                    at: 0)
            }
        }
        return calendarDates
    }
}
