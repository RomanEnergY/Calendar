//
//  CalendarView+PageMonthView.swift
//  Calendar
//
//  Created by ZverikRS on 13.10.2023.
//  Copyright © 2023 SCSR. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - delegate

protocol CalendarPageMonthViewDelegate: CalendarViewDayItemDelegate {
    func calendarPageMonthViewUpdateHiddenButton(isLast: Bool, isNext: Bool)
    func calendarPageMonthViewUpdateScrollRectToVisible(isLast: Bool, isNext: Bool)
}

protocol CalendarPageMonthViewDisplayLogic: AnyObject {
    func nextPage()
    func lastPage()
}

// MARK: - extension for PageMonthView

extension CalendarView {
    final class PageMonthView: BaseView {
        struct ViewModel {
            let days: [CalendarView.DayItemView.ViewModel]
        }
        
        // MARK: - public properties
        
        weak var delegate: CalendarPageMonthViewDelegate?
        var model: ViewModel? {
            didSet {
                if model?.months.isEmpty == true || stackView.arrangedSubviews.count != model?.months.count {
                    stackView.removeAllArrangedSubview()
                    scrollView.scrollRectToVisible(.zero, animated: false)
                    let months = model?.months ?? []
                    (months.isEmpty ? [.emptyModel] : months).forEach { item in
                        let monthView: MonthView = .init()
                        monthView.delegate = self
                        monthView.model = item
                        stackView.addArrangedSubview(monthView)
                        monthView.snp.makeConstraints {
                            $0.width.equalTo(self)
                        }
                    }
                    
                    let isOneElement: Bool = months.count <= 1
                    scrollView.alwaysBounceHorizontal = !isOneElement
                    delegate?.calendarPageMonthViewUpdateScrollRectToVisible(
                        isLast: false,
                        isNext: !isOneElement)
                    
                    delegate?.calendarPageMonthViewUpdateHiddenButton(
                        isLast: isOneElement,
                        isNext: isOneElement)
                    
                } else {
                    stackView.arrangedSubviews.enumerated().forEach { enumerate in
                        if let monthView = enumerate.element as? MonthView {
                            monthView.delegate = self
                            monthView.model = (model?.months ?? [])[safe: enumerate.offset]
                        }
                    }
                }
            }
        }
        
        // MARK: - private properties
        
        private var stackView: BaseStackView = .init(axis: .horizontal)
        private lazy var scrollView: UIScrollView = {
            let scrollView: UIScrollView = .init()
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            return scrollView
        }()
        
        override func config() {
            super.config()
            scrollView.clipsToBounds = false
        }
        
        // MARK: - life cycle
        
        override func addSubviews() {
            super.addSubviews()
            addSubview(scrollView)
            scrollView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            scrollView.addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(scrollView)
            }
        }
    }
}

// MARK: - extension for CalendarPageMonthViewDisplayLogic

extension CalendarView.PageMonthView: CalendarPageMonthViewDisplayLogic {
    func nextPage() {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width + scrollView.contentOffset.x
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func lastPage() {
        var frame: CGRect = scrollView.frame
        frame.origin.x = scrollView.contentOffset.x - frame.size.width
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}

// MARK: - extension for CalendarViewDayItemDelegate

extension CalendarView.PageMonthView: CalendarViewMonthDelegate {
    func eventCell(_ view: CalendarView.DayItemView) {
        delegate?.eventCell(view)
    }
    
    func activePressed(_ view: CalendarView.DayItemView) {
        delegate?.activePressed(view)
    }
}

// MARK: - extension for UIScrollViewDelegate

extension CalendarView.PageMonthView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.width != 0 else { return }
        let position = scrollView.contentOffset.x
        if position <= 0 {
            delegate?.calendarPageMonthViewUpdateScrollRectToVisible(
                isLast: false,
                isNext: scrollView.contentSize.width > frame.size.width)
            
        } else if position >= scrollView.contentSize.width - frame.size.width {
            delegate?.calendarPageMonthViewUpdateScrollRectToVisible(
                isLast: position != 0,
                isNext: false)
            
        } else {
            delegate?.calendarPageMonthViewUpdateScrollRectToVisible(
                isLast: true,
                isNext: true)
        }
    }
}

// MARK: - calculated properties

private extension CalendarView.PageMonthView.ViewModel {
    var months: [CalendarView.MonthView.ViewModel] {
        let activeDaysSorted: [CalendarView.DayItemView.ViewModel] = days
            .sorted(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
        
        var dicMonth: [Date: [CalendarView.DayItemView.ViewModel]] = [:]
        activeDaysSorted.forEach { day in
            let monthDateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: day.date)
            guard let month = Calendar.current.date(from: monthDateComponents) else { return }
            if var days = dicMonth[month] {
                days.append(day)
                dicMonth[month] = days
            } else {
                dicMonth[month] = [day]
            }
        }
        
        let month = dicMonth
            .sorted(by: { $0.key.timeIntervalSince1970 < $1.key.timeIntervalSince1970 })
            .map { item -> (date: Date, days: [CalendarView.DayItemView.ViewModel]) in
                (date: item.key, days: item.value)
            }
        
        return month.enumerated().map { item in
                .init(
                    month: item.element.date,
                    lastDaysMonth: month[safe: item.offset - 1]?.days ?? [],
                    currentDaysMonth: item.element.days,
                    nextDaysMonth: month[safe: item.offset + 1]?.days ?? [])
        }
    }
    
    func getTitle(for date: Date) -> String {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        return "\(month.monthToString) \(year)"
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
