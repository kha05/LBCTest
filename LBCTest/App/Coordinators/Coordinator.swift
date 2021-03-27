//
//  Coordinator.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0 !== coordinator })
    }
}
