//
//  ImageCacheTests.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import XCTest
@testable import BreedsProject

class ImageCacheTests: XCTestCase {
    
    var imageCache: ImageCache?
    var url: URL?
    
    override func setUp() {
        
        super.setUp()
        
        self.imageCache = ImageCache()
        self.url = URL(string: "https://swordhealth.com")
    }
    
    override func tearDown() {
        
        super.tearDown()
        
        self.imageCache?.removeImage(for: self.url)
        self.imageCache = nil
        self.url = nil
    }
    
    func testAddAndRemoveImageFromCache() {
        
        let image = UIImage(systemName: "heart")
        XCTAssertNil(self.imageCache?.image(for: url))
        
        self.imageCache?.saveImage(image, for: self.url)
        XCTAssertNotNil(self.imageCache?.image(for: self.url))
        
        self.imageCache?.removeImage(for: self.url)
        XCTAssertNil(self.imageCache?.image(for: self.url))
    }
    
    func testRemoveImageInvalidUrl() {
        
        let image = UIImage(systemName: "heart")
        XCTAssertNil(self.imageCache?.image(for: url))
        
        self.imageCache?.saveImage(image, for: self.url)
        XCTAssertNotNil(self.imageCache?.image(for: self.url))
        
        self.imageCache?.removeImage(for: nil)
        XCTAssertNotNil(self.imageCache?.image(for: self.url))
    }
}
