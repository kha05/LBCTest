//
//  CurrencyFormatter.swift
//  LBCTest
//
//  Created by Ha Kevin on 29/03/2021.
//

import Foundation

protocol CurrencyFormatterRepresentable {
    func formatAmountToString(amount: NSDecimalNumber) -> String?
}

final class CurrencyFormatter: CurrencyFormatterRepresentable {
    private lazy var currencyFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "fr-FR")
        numberFormatter.numberStyle = .currencyAccounting
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }()
    
    func formatAmountToString(amount: NSDecimalNumber) -> String? {
        return currencyFormatter.string(from: amount)
    }
}
