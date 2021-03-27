//
//  ImageCache.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation
import UIKit

protocol ImageCacheRepresentable {
    func insertImage(image: UIImage, for url: String)
    func fetchImage(url: String) -> UIImage?
}

final class ImageCache: ImageCacheRepresentable {
    private let defaultCountLimit: Int = 0
    private let defaultMemoryLimit: Int = 1024 * 1024 * 100
    
    private lazy var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = defaultCountLimit
        return cache
    }()
    
    func insertImage(image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }

    func fetchImage(url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }
}
