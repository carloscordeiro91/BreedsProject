//
//  ModelTests.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import XCTest
@testable import BreedsProject

class ModelTests: XCTestCase {
    
    func testBreedModel() {
        
        let breedModel = BreedModel(name: "Maltese",
                                    breedGroup: "Toy",
                                    origin: "Malta",
                                    category: "Lap dog",
                                    temperament: "fun",
                                    image: nil)
        
        XCTAssertEqual(breedModel.name, "Maltese")
        XCTAssertEqual(breedModel.breedGroup, "Toy")
        XCTAssertEqual(breedModel.origin, "Malta")
        XCTAssertEqual(breedModel.category, "Lap dog")
        XCTAssertEqual(breedModel.temperament, "fun")
    }
    
    func testImageModel() {
        
        let imageModel = ImageModel(id: "123",
                                    url: "url")
        
        XCTAssertEqual(imageModel.id, "123")
        XCTAssertEqual(imageModel.url, "url")
    }
}
