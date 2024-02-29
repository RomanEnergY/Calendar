//
//  MainViewController.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - private properties
    
    private var calendarView: CalendarView?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hFFFFFF
        addCalendarView()
        setViewModel()
        
        
    }
    
    // MARK: - private methods
    
    private func addCalendarView() {
        let calendarView: CalendarView = .init()
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.calendarView = calendarView
    }
    
    private func setViewModel() {
        let currentDate: Date = .init()
        let dates: [Date] = (0 ..< 90).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: currentDate) }
        let viewModel: CalendarViewModel = .init(
            selectedDate: nil,
            dates: dates,
            onPressed: { date in
                if let date {
                    print("🟢 onPressed \(#function):\(#line) \(date.toString(dateFormat: "dd.MM.yyyy", timeZone: .zone(.current)))")
                } else {
                    print("🟢 onPressed \(#function):\(#line) notSelected")
                }
            },
            onCallPressed: { date in
                if let date {
                    print("🟢 onCallPressed \(#function):\(#line) \(date.toString(dateFormat: "dd.MM.yyyy", timeZone: .zone(.current)))")
                } else {
                    print("🟢 onCallPressed \(#function):\(#line) notSelected")
                }
            })
        
        calendarView?.model = viewModel
    }
}
