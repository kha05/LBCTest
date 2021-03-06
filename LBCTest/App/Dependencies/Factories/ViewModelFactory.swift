//
//  ViewModelFactory.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

protocol ViewModelFactory {
    func makeItemsViewModel() -> ItemsViewModelRepresentable
    func makeItemDetailViewModel(item: Item, categoryName: String) -> ItemDetailViewModelRepresentable
}
