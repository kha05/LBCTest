//
//  ViewControllerFactory.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

protocol ViewControllerFactory {
    func makeItemsViewController(viewModel: ItemsViewModelRepresentable) -> ItemsViewController
    func makeItemDetailViewController(viewModel: ItemDetailViewModelRepresentable) -> ItemDetailViewController
}
