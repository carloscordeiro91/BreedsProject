//
//  ImageDownloadManager.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 17/05/2023.
//

import UIKit
import Combine

protocol ImageDownloadProtocol {
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class ImageDownloadManager {
    
    private let imageCache: ImageCacheProtocol?
    private var cancellables = [URL: AnyCancellable]()
    
    init(imageCache: ImageCacheProtocol?) {
        
        self.imageCache = imageCache
    }
}

extension ImageDownloadManager: ImageDownloadProtocol {
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        
        if let cachedImage = self.imageCache?.image(for: url) {
                        
            return Just(cachedImage)
                .eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let publisher = session.dataTaskPublisher(for: request)
            .map { UIImage(data: $0.data) }
            .catch { error -> Just<UIImage?> in
                
                return Just(nil)
            }
            .handleEvents(receiveOutput: { [weak self] image in
                
                if let image = image {
                    
                    self?.imageCache?.saveImage(image, for: url)
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        self.cancellables[url] = publisher.sink { [weak self] _ in
            self?.cancellables.removeValue(forKey: url)
        }
        
        return publisher
    }
}
