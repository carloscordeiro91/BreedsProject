//
//  CoreDependencies.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation

protocol HasNetwork {
    
    var network: NetworkProtocol { get }
}

protocol HasImageCache {
    
    var imageCache: ImageCacheProtocol { get }
}

typealias HasCoreDependencies = HasNetwork & HasImageCache

struct CoreDependencies: HasNetwork, HasImageCache {
    
    let network: NetworkProtocol
    let imageCache: ImageCacheProtocol
    
    init(network: NetworkProtocol = NetworkManager(urlSession: URLSession.shared),
         imageCache: ImageCacheProtocol = ImageCache()) {
        
        self.network = network
        self.imageCache = imageCache
    }
}
