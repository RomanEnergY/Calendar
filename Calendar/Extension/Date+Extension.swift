//
//  Date+Extension.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import Foundation

// MARK: - calculated properties for DateFormatter

extension DateFormatter {
    enum CustomTimeZone {
        case not
        case zone(TimeZone?)
        
        var timeZone: TimeZone? {
            switch self {
            case .not:
                return .init(secondsFromGMT: 0)
            case let .zone(timeZone):
                return timeZone
            }
        }
    }
}



extension Date {
    func toString(
        dateFormat: String,
        timeZone: DateFormatter.CustomTimeZone
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone.timeZone
        return formatter.string(from: self)
    }
}

// MARK: - extension for toDateString

extension Date {
    func equalsDay(for date: Self) -> Bool {
        let dateFormat: String = "yyyy.MM.dd"
        return toString(dateFormat: dateFormat, timeZone: .zone(.current)) == date.toString(dateFormat: dateFormat, timeZone: .zone(.current))
    }
    
    func equalsMonth(for date: Self) -> Bool {
        let dateFormat: String = "yyyy.MM"
        return toString(dateFormat: dateFormat, timeZone: .zone(.current)) == date.toString(dateFormat: dateFormat, timeZone: .zone(.current))
    }
}
