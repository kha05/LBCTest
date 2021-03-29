//
//  DateManager.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation

protocol DateManagerRepresentable {
    func formatDateToString(date: Date) -> String
    func formatStringToDateIso8601(string: String) -> Date?
}

final class DateManager: DateManagerRepresentable {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale    = Locale(identifier: "FR-fr")
        return dateFormatter
    }()
    
    private lazy var isoDateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
    
    func formatDateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func formatStringToDateIso8601(string: String) -> Date? {
        return isoDateFormatter.date(from: string)
    }
}
