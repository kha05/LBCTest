//
//  ItemsCoordinator.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

final class ItemsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(factory: ViewControllerFactory, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let viewController = factory.makeItemsViewController()
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
