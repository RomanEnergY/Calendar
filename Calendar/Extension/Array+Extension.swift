//
//  Array+Extension.swift
//  Calendar
//
//  Created by ZverikRS on 29.02.2024.
//

import Foundation

// MARK: - extension for get Element to safe index

extension Array {
    subscript(safe index: Index?) -> Element? {
        guard let index else { return nil }
        
        guard index >= startIndex,
              index < endIndex
        else {
            return nil
        }
        
        return self[index]
    }
}
