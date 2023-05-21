//
//  ImageCacheMock.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import UIKit
@testable import BreedsProject

class ImageCacheMock: ImageCacheProtocol {
    
    var images = [URL: UIImage]()
    
    func image(for url: URL?) -> UIImage? {
        
        return images[url ?? URL(string: "")!]
    }
    
    func saveImage(_ image: UIImage?, for url: URL?) {
        
        guard let image = image,
                let url = url else { return }
        
        self.images[url] = image
    }
    
    func removeImage(for url: URL?) {
        
        guard let url = url else { return }
        
        self.images.removeValue(forKey: url)
    }
}
