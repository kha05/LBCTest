//
//  DependencyContainer.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

typealias Factory = ViewControllerFactory & ServiceFactory & ViewControllerFactory

final class DependencyContainer {
    
}

extension DependencyContainer: ViewControllerFactory {}

extension DependencyContainer: ViewModelFactory {}

extension DependencyContainer: ServiceFactory {}
