//
//  ItemsCoordinator.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

protocol ItemsCoordinatorDelegate: AnyObject {
    func didTapItem(item: Item, categoryName: String)
}

final class ItemsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let factory: Factory
    
    init(factory: Factory, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let viewModel = factory.makeItemsViewModel()
        viewModel.coordinatorDelegate = self
        let viewController = factory.makeItemsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension ItemsCoordinator: ItemsCoordinatorDelegate {
    func didTapItem(item: Item, categoryName: String) {
        let detailViewModel = factory.makeItemDetailViewModel(item: item, categoryName: categoryName)
        let detailViewController = factory.makeItemDetailViewController(viewModel: detailViewModel)

        guard #available(iOS 13.0, *) else {
            let presentNavigationController = UINavigationController(rootViewController: detailViewController)
            presentNavigationController.navigationBar.backgroundColor = .white
            
            detailViewController.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .didClose), animated: true)
            navigationController.present(presentNavigationController, animated: true, completion: nil)
            return
        }
        
        navigationController.present(detailViewController, animated: true, completion: nil)
    }
}

private extension ItemsCoordinator {
    @objc func didClose() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

private extension Selector {
    static let didClose = #selector(ItemsCoordinator.didClose)
}
