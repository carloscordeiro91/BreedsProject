//
//  ImageDownloaderTests.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import XCTest
import Combine
@testable import BreedsProject

class ImageDownloaderTests: XCTestCase {
    
    var imageCache: ImageCacheMock!
    var manager: ImageDownloadManager!
    
    override func setUp() {
        
        super.setUp()
        
        self.imageCache = ImageCacheMock()
        self.manager = ImageDownloadManager(imageCache: self.imageCache)
    }
    
    override func tearDown() {
        
        self.imageCache = nil
        self.manager = nil
        
        super.tearDown()
    }
    
    func testLoadImageFromCache() throws {
        
        let url = try XCTUnwrap(URL(string: "https://example.com/image.png"))
        let image = UIImage(systemName: "star")
        self.imageCache.images[url] = image
        
        let expectation = self.expectation(description: "Load image from cache")
        
        let cancellables = self.manager.loadImage(from: url)
            .sink { result in
                XCTAssertEqual(result, image)
                expectation.fulfill()
            }
            
        cancellables.cancel()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoadImageFromNetwork() throws {
        
        let url = try XCTUnwrap(URL(string: "https://example.com/image.png"))

        let cancellables = self.manager.loadImage(from: url)
            .sink { image in
                
                XCTAssertNotNil(image)
                XCTAssertNotNil(self.imageCache.image(for: url))
            }
        
        cancellables.cancel()
    }
    
    func testRemoveImage() throws {
        
        let url = try XCTUnwrap(URL(string: "https://example.com/image.png"))
        let image = UIImage(systemName: "star")
        self.imageCache.images[url] = image
        
        self.imageCache.removeImage(for: url)
        
        XCTAssertNil(self.imageCache.images[url])
    }
}
