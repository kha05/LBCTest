//
//  DateManager.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation

protocol DateManagerRepresentable {
    func formatDateToString(date: Date) -> String
}

final class DateManager: DateManagerRepresentable {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale    = Locale(identifier: "FR-fr")
        return dateFormatter
    }()
    
    func formatDateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
