//
//  ImageCache.swift
//  ResponsiveApp
//
//  Created by Stoyan Kostov on 2.02.18.
//  Copyright © 2018 Stoyan Kostov. All rights reserved.
//

import UIKit


class ImageCache {
    static let shared = ImageCache()
    
    private let imageCache:NSCache<NSString, UIImage>!
    
    private init() {
        imageCache = NSCache<NSString, UIImage>()
    }
}

extension ImageCache {
    func getImage(url:URL) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
           return cachedImage
        }
        return nil
    }
    
    func setImage(image:UIImage, url:URL) {
        imageCache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
