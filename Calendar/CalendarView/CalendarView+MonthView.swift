//
//  CalendarView+MonthView.swift
//  Calendar
//
//  Created by ZverikRS on 13.10.2023.
//  Copyright © 2023 SCSR. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - delegate

protocol CalendarViewMonthDelegate: CalendarViewDayItemDelegate, CalendarPageMonthViewDisplayLogic { }

// MARK: - extension for MonthView

extension CalendarView {
    final class MonthView: BaseView {
        struct ViewModel {
            let month: Date
            let lastDaysMonth: [CalendarView.DayItemView.ViewModel]
            let currentDaysMonth: [CalendarView.DayItemView.ViewModel]
            let nextDaysMonth: [CalendarView.DayItemView.ViewModel]
            
            static var emptyModel: Self {
                .init(
                    month: .init(),
                    lastDaysMonth: [],
                    currentDaysMonth: [],
                    nextDaysMonth: [])
            }
        }
        
        // MARK: - public properties
        
        weak var delegate: CalendarViewMonthDelegate?
        var model: ViewModel? {
            didSet {
                weekdayView.isHidden = model?.isHidden ?? true
                titleLabel.text = model?.title
                let calendarDates = model?.calendarDates(lineCount: lineCount)
                (calendarDates ?? []).enumerated().forEach { item in
                    if let dayView = daysView[safe: item.offset] {
                        dayView.delegate = self
                        dayView.model = item.element
                    }
                }
            }
        }
        
        // MARK: - private properties
        
        private let lineCount: Int = 6
        private let titleLabel: BaseLabel = {
            let label: BaseLabel = .init()
            label.font = .systemFont(ofSize: 18, weight: .bold)
            label.textColor = .h000000
            label.textAlignment = .left
            label.numberOfLines = 0
            return label
        }()
        private let weekdayView: WeekdayView = .init()
        private var daysView: [DayItemView] = []
        
        // MARK: - life cycle
        
        override func addSubviews() {
            super.addSubviews()
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(20)
                $0.top.equalToSuperview()
            }
            
            let stackView: BaseStackView = .init(
                axis: .vertical,
                spacing: 10,
                distribution: .equalSpacing)
            
            let wrapperWeekdayView: BaseView = .init()
            wrapperWeekdayView.addSubview(weekdayView)
            weekdayView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            stackView.addArrangedSubview(wrapperWeekdayView)
            
            (0 ..< lineCount).forEach { _ in
                let lineStackView: BaseStackView = .init(
                    axis: .horizontal,
                    distribution: .equalSpacing)
                
                (0 ..< 7).forEach { _ in
                    let dayView: DayItemView = .init(shadowType: .not)
                    daysView.append(dayView)
                    lineStackView.addArrangedSubview(dayView)
                }
                
                stackView.addArrangedSubview(lineStackView)
            }
            
            addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(17)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - extension for CalendarViewDayItemDelegate

extension CalendarView.MonthView: CalendarViewDayItemDelegate {
    func eventCell(_ view: CalendarView.DayItemView) {
        delegate?.eventCell(view)
    }
    
    func activePressed(_ view: CalendarView.DayItemView) {
        if let date = view.model?.date,
           let month = model?.month,
           !date.equalsMonth(for: month) {
            let month = Calendar.current.dateComponents([.year, .month], from: month)
            let date = Calendar.current.dateComponents([.year, .month], from: date)
            if ((month.year ?? 0) * 12 + (month.month ?? 0)) < ((date.year ?? 0) * 12 + (date.month ?? 0)) {
                delegate?.nextPage()
            } else {
                delegate?.lastPage()
            }
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.activePressed(view)
            }
            
        } else {
            delegate?.activePressed(view)
        }
    }
}

// MARK: - calculated properties

private extension CalendarView.MonthView.ViewModel {
    var isHidden: Bool {
        currentDaysMonth.isEmpty
    }
    
    var title: String {
        let year = Calendar.current.component(.year, from: month)
        let month = Calendar.current.component(.month, from: month)
        return "\(month.monthToString) \(year)"
    }
    
    func calendarDates(
        lineCount: Int
    ) -> [CalendarView.DayItemView.ViewModel] {
        let onDayViewPressed: (Date) -> Void = { date in
            print("🟢 onDayViewPressed \(#function):\(#line) \(date)")
        }
        
        let onCallEventDayViewPressed: (Date) -> Void = { date in
            print("🟢 onCallEventDayViewPressed \(#function):\(#line) \(date)")
        }
        
        var calendarDates: [CalendarView.DayItemView.ViewModel] = []
        currentDaysMonth.enumerated().forEach { item in
            if item.offset == 0 {
                let currentNumberDay: Int = Calendar.current.component(.day, from: item.element.date)
                if currentNumberDay != 1 {
                    calendarDates.insert(
                        contentsOf: createDecrementNotActiveDay(
                            for: item.element.date,
                            count: currentNumberDay - 1,
                            lastDays: lastDaysMonth,
                            onDayViewPressed: onDayViewPressed,
                            onCallEventDayViewPressed: onCallEventDayViewPressed),
                        at: 0)
                }
                
                let firstDay = calendarDates.first?.date ?? item.element.date
                let startOfWeek = Calendar.current.startOfWeek(firstDay)
                if let diffInDays = Calendar.current.dateComponents([.day], from: startOfWeek, to: firstDay).day {
                    calendarDates.insert(
                        contentsOf: createDecrementNotActiveDay(
                            for: firstDay,
                            count: diffInDays,
                            lastDays: lastDaysMonth,
                            onDayViewPressed: onDayViewPressed,
                            onCallEventDayViewPressed: onCallEventDayViewPressed),
                        at: 0)
                }
                
                calendarDates.append(item.element)
                
            } else if let lastElement = currentDaysMonth[safe: item.offset - 1] {
                calendarDates.append(item.element)
                
                let countLastDay = Calendar.current.dateComponents([.day], from: lastElement.date, to: item.element.date).day ?? 0
                if let index = calendarDates.firstIndex(where: { $0.date == lastElement.date }) {
                    if countLastDay > 1 {
                        calendarDates.insert(
                            contentsOf: createDecrementNotActiveDay(
                                for: item.element.date,
                                count: countLastDay - 1,
                                lastDays: lastDaysMonth,
                                onDayViewPressed: onDayViewPressed,
                                onCallEventDayViewPressed: onCallEventDayViewPressed),
                            at: index + 1)
                    }
                }
                
            } else {
                calendarDates.append(item.element)
            }
        }
        
        let countDates: Int = lineCount * 7
        if calendarDates.count < countDates,
           let lastDate = calendarDates.last?.date {
            calendarDates.append(contentsOf: createIncrementNotActiveDay(
                for: lastDate,
                count: countDates - calendarDates.count,
                nextDays: nextDaysMonth,
                onDayViewPressed: onDayViewPressed,
                onCallEventDayViewPressed: onCallEventDayViewPressed))
        }
        
        return calendarDates
    }
    
    private func createIncrementNotActiveDay(
        for date: Date,
        count: Int,
        nextDays: [CalendarView.DayItemView.ViewModel],
        onDayViewPressed: @escaping (Date) -> Void,
        onCallEventDayViewPressed: @escaping (Date) -> Void
    ) -> [CalendarView.DayItemView.ViewModel] {
        var calendarDates: [CalendarView.DayItemView.ViewModel] = []
        (0 ..< count).forEach { i in
            if let day = Calendar.current.date(byAdding: .day, value: (i + 1), to: date) {
                if let nextDay = nextDays.first(where: { $0.date.equalsDay(for: day) }) {
                    calendarDates.append(nextDay)
                } else {
                    calendarDates.append(.notActive(date: day))
                }
            }
        }
        return calendarDates
    }
    
    private func createDecrementNotActiveDay(
        for date: Date,
        count: Int,
        lastDays: [CalendarView.DayItemView.ViewModel],
        onDayViewPressed: @escaping (Date) -> Void,
        onCallEventDayViewPressed: @escaping (Date) -> Void
    ) -> [CalendarView.DayItemView.ViewModel] {
        var calendarDates: [CalendarView.DayItemView.ViewModel] = []
        (0 ..< count).forEach { i in
            if let day = Calendar.current.date(byAdding: .day, value: -(i + 1), to: date) {
                if let lastDay = lastDays.first(where: { $0.date.equalsDay(for: day) }) {
                    calendarDates.insert(lastDay, at: 0)
                } else {
                    calendarDates.insert(.notActive(date: day), at: 0)
                }
            }
        }
        return calendarDates
    }
}

private extension Int {
    var monthToString: String {
        switch self {
        case 1:
            return "Январь"
        case 2:
            return "Февраль"
        case 3:
            return "Март"
        case 4:
            return "Апрель"
        case 5:
            return "Май"
        case 6:
            return "Июнь"
        case 7:
            return "Июль"
        case 8:
            return "Август"
        case 9:
            return "Сентябрь"
        case 10:
            return "Октябрь"
        case 11:
            return "Ноябрь"
        default:
            return "Декабрь"
        }
    }
}
