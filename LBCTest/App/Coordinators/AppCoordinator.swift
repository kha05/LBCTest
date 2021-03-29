//
//  AppCoordinator.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators: [Coordinator] = []
    let factory: Factory
    
    private lazy var navigationController: UINavigationController = {
        let navigation = UINavigationController()
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }()
    
    init(window: UIWindow, factory: Factory) {
        self.window = window
        self.factory = factory
    }
}

extension AppCoordinator {
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let itemCoordinator = ItemsCoordinator(factory: factory, navigationController: navigationController)
        addChildCoordinator(itemCoordinator)
        itemCoordinator.start()
    }
}
