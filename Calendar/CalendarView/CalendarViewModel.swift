//
//  CalendarViewModel.swift
//  Calendar
//
//  Created by ZverikRS on 12.10.2023.
//  Copyright © 2023 SCSR. All rights reserved.
//

import Foundation

// MARK: - class

final class CalendarViewModel {
    
    // MARK: - public properties
    
    var selectedDate: Date?
    let dates: [Date]
    let onPressed: (Date?) -> Void
    let onCallPressed: (Date?) -> Void
    
    // MARK: - initializers
    
    init(
        selectedDate: Date?,
        dates: [Date],
        onPressed: @escaping (Date?) -> Void,
        onCallPressed: @escaping (Date?) -> Void
    ) {
        self.selectedDate = selectedDate
        self.dates = dates
        self.onPressed = onPressed
        self.onCallPressed = onCallPressed
    }
}
