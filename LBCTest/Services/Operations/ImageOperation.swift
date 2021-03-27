//
//  ImageOperation.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

final class FetchImageOperation: AsynchronousOperation {
    private let imageService: ImagesServiceRepresentable
    private let imageUrl: String
    
    init(imageUrl: String, factory: ServiceFactory) {
        self.imageService = factory.imageService
        self.imageUrl = imageUrl
    }
    override func main() {
        guard !isCancelled else { return }
        
        imageService.fetchImage(from: imageUrl) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.state = .isFinished
            }
        }
    }
}
