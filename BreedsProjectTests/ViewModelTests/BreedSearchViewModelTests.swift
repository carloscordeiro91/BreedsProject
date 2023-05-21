//
//  BreedSearchViewModelTests.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import Combine
import XCTest
@testable import BreedsProject

class BreedSearchViewModelTests: XCTestCase {
    
    var viewModel: BreedsSearchViewModel!
    var mockService: NetworkManagerMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        
        super.setUp()
        
        self.mockService = NetworkManagerMock()
        self.viewModel = BreedsSearchViewModel(networkService: self.mockService)
        self.cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        
        self.mockService = nil
        self.viewModel = nil
        
        super.tearDown()
    }
    
    func testFetchBreedsWithSuccess() throws {
        
        let breedsResponse = [BreedModel(name: "Coton",
                                         breedGroup: nil,
                                         origin: nil,
                                         category: nil,
                                         temperament: nil,
                                         image: nil),
                              BreedModel(name: "Beagle",
                                         breedGroup: nil,
                                         origin: nil,
                                         category: nil,
                                         temperament: nil,
                                         image: nil)]
        
        self.mockService.breedsResponse = breedsResponse
        
        let expectation = self.expectation(description: "fetch breeds completes")
        
        self.viewModel.$isLoading.dropFirst().sink { isLoading in
            
            if !isLoading {
                
                XCTAssertEqual(self.viewModel.breeds.count, 2)
                XCTAssertNil(self.viewModel.error)
                expectation.fulfill()
            }
        }
        .store(in: &self.cancellables)
        
        self.viewModel.searchBreeds(with: "text")
        self.waitForExpectations(timeout: 5)
    }
    
    func testFetchBreedsWithFailure() throws {
        
        self.mockService.error = APIError.invalidURL
        
        let expectation = self.expectation(description: "fetch Breeds fails")
        
        self.viewModel.$error.dropFirst().sink { error in
            
            if let error = error {
                
                XCTAssertEqual(self.viewModel.breeds.count, 0)
                XCTAssertNotNil(error)
                
                expectation.fulfill()
            }
        }
        .store(in: &self.cancellables)
        
        self.viewModel.searchBreeds(with: "text")
        self.waitForExpectations(timeout: 5.0)
    }
}
