//
//  ItemsCollectionViewFlowLayout.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation
import UIKit

final class ItemsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private let heightConstant: CGFloat = 300.0
    private let estimatedWidth: CGFloat = 160.0
    private let cellMarginSize: CGFloat = 16.0
    
    override init() {
        super.init()

        let screenWidth = UIScreen.main.bounds.width
        
        let cellCount = floor(CGFloat(screenWidth / estimatedWidth))
        let margin = cellMarginSize * 2
        let width = (screenWidth - cellMarginSize * (cellCount - 1) - margin) / cellCount
        
        self.itemSize = CGSize(width: width, height: heightConstant)
        self.minimumInteritemSpacing = 5
        self.minimumLineSpacing = 11
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
