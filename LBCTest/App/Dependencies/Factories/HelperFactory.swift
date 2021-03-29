//
//  HelperFactory.swift
//  LBCTest
//
//  Created by Ha Kevin on 29/03/2021.
//

import Foundation

protocol HelperFactory {
    var imageCache: ImageCacheRepresentable { get }
    var dateFormatter: DateManagerRepresentable { get }
    var currencyFormatter: CurrencyFormatterRepresentable { get }
}
