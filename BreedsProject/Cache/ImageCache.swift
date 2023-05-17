//
//  ImageCache.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit

protocol ImageCacheProtocol: AnyObject {

    func image(for url: URL?) -> UIImage?
    func saveImage(_ image: UIImage?, for url: URL?)
    func removeImage(for url: URL?)
}

final class ImageCache: ImageCacheProtocol {
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        
        let cache = NSCache<AnyObject, AnyObject>()

        return cache
    }()
    
    private let lock = NSLock()
    
    func image(for url: URL?) -> UIImage? {
        
        self.lock.lock()
        
        defer {
            
            self.lock.unlock()
        }
        
        guard let urlString = url?.absoluteString,
              let url = NSURL(string: urlString),
              let image = self.imageCache.object(forKey: url) else {
            
            return nil
        }
        
        return image as? UIImage
    }
    
    func saveImage(_ image: UIImage?, for url: URL?) {
        
        guard let image = image,
              self.image(for: url) == nil,
              let urlString = url?.absoluteString,
              let url = NSURL(string: urlString) else {
            
            return
        }
        
        self.lock.lock()
        
        defer {
            
            self.lock.unlock()
        }
        
        self.imageCache.setObject(image, forKey: url)
    }
    
    func removeImage(for url: URL?) {
        
        guard let urlString = url?.absoluteString,
              let url = NSURL(string: urlString) else {
            
            return
        }
        
        self.lock.lock()
        
        defer {
            
            self.lock.unlock()
        }
        
        self.imageCache.removeObject(forKey: url)
    }
}
