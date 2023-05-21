//
//  ViewControllersFactoryTests.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import XCTest
@testable import BreedsProject

class ViewControllerFactoryTests: XCTestCase {
    
    var navigator: Navigator?
    var viewControllersFactory: ViewControllersFactory?
    
    override func setUp() {
        
        super.setUp()
        
        self.navigator = Navigator(coreDependencies: CoreDependencies())
        self.viewControllersFactory = ViewControllersFactory(coreDependencies: CoreDependencies())
    }
    
    override func tearDown() {
        
        super.tearDown()
        
        self.navigator = nil
        self.viewControllersFactory = nil
    }
    
    func testBreedsTabController() throws {
        
        let navigator = try XCTUnwrap(self.navigator)
        let viewControllersFactory = try XCTUnwrap(self.viewControllersFactory)
        
        let viewController = viewControllersFactory.makeTabBarViewController(navigator: navigator)
        
        XCTAssertNotNil(viewController)
    }
    
    func testBreedsViewController() throws {
        
        let navigator = try XCTUnwrap(self.navigator)
        let viewControllersFactory = try XCTUnwrap(self.viewControllersFactory)
        
        let viewController = viewControllersFactory.makeBreedsViewController(navigator: navigator)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is BreedsViewController)
    }
    
    func testBreedsSearchViewController() throws {
        
        let navigator = try XCTUnwrap(self.navigator)
        let viewControllersFactory = try XCTUnwrap(self.viewControllersFactory)
        
        let viewController = viewControllersFactory.makeBreedsSearchViewController(navigator: navigator)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is BreedsSearchViewController)
    }
    
    func testBreedDetailsViewController() throws {
        
        let viewControllersFactory = try XCTUnwrap(self.viewControllersFactory)
        let breedModel = BreedModel(name: "Coton",
                                    breedGroup: nil,
                                    origin: nil,
                                    category: nil,
                                    temperament: nil,
                                    image: nil)
        
        let viewController = viewControllersFactory.makeBreedDetailsViewController(breedModel: breedModel)
        
        XCTAssertNotNil(viewController)
        XCTAssert(viewController is BreedDetailsViewController)
    }
}
