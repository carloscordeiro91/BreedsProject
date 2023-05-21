//
//  NavigatorTests.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import XCTest
@testable import BreedsProject

class NavigatorTests: XCTestCase {
    
    var navigator: Navigator?
    
    override func setUp() {
        
        super.setUp()
        
        self.navigator = Navigator(coreDependencies: CoreDependencies())
        let _ = self.navigator?.navigateToTabViewController()
    }
    
    override func tearDown() {
        
        super.tearDown()
        
        self.navigator = nil
    }
    
    func testNavigateToBreedsDetailsViewController() throws {
                
        let breedModel = BreedModel(name: "Coton",
                                    breedGroup: nil,
                                    origin: nil,
                                    category: nil,
                                    temperament: nil,
                                    image: nil)
                
        let viewController = self.navigator?.navigateToBreedDetailsViewController(with: breedModel)
        
        XCTAssertNotNil(viewController)
    }
    
    func testNavigateToErrorAlert() throws {
                

        let viewController = self.navigator?.navigateToErrorAlert {}
        
        XCTAssertNotNil(viewController)
    }
}
