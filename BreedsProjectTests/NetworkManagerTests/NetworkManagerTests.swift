//
//  NetworkManagerTests.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import Combine
import XCTest
@testable import BreedsProject

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var urlSessionMock = URLSessionMock()
    
    override func setUp() {
        
        super.setUp()
        
        self.networkManager = NetworkManager(urlSession: self.urlSessionMock)
    }
    
    override func tearDown() {
        
        self.networkManager = nil
        
        super.tearDown()
    }
    
    func testGetBreedsValidData() throws {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let path = bundle.path(forResource: "Breeds", ofType: "json") else {
            
            XCTFail("Failed to find json file")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let expectedData = try Data(contentsOf: url)
        
        self.urlSessionMock.mockedData = expectedData
        
        let decoder = JSONDecoder()
        let model = try decoder.decode([BreedModel].self, from: expectedData)
        let result = try waitFor(publisher: self.networkManager.getData(.breeds(pageNumber: 1), ofType: [BreedModel].self))
        
        XCTAssertEqual(result, model)
    }
    
    func testSearchForBreedsValidData() throws {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let path = bundle.path(forResource: "Breeds", ofType: "json") else {
            
            XCTFail("Failed to find json file")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let expectedData = try Data(contentsOf: url)
        
        self.urlSessionMock.mockedData = expectedData
        
        let decoder = JSONDecoder()
        let model = try decoder.decode([BreedModel].self, from: expectedData)
        let result = try waitFor(publisher: self.networkManager.getData(.search(text: "Beagle"), ofType: [BreedModel].self))

        XCTAssertEqual(result, model)
    }

    func testGetDataWithInvalidURLReturnsURLError() throws {
        
        let expectedError = APIError.genericError
        self.urlSessionMock.mockedError = expectedError
        
        let publisher: AnyPublisher<[BreedModel], APIError> = self.networkManager.getData(.breeds(pageNumber: 1),
                                                                                          ofType: [BreedModel].self)
        let expectation = self.expectation(description: "Request should fail with URLError")
        
        let cancellables = publisher.sink(receiveCompletion: { completion in
            
            switch completion {
                
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
                
            case .finished:
                XCTFail("Request should fail")
            }
            
        }, receiveValue: { _ in
            XCTFail("Request should fail")
        })
        
        cancellables.cancel()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

extension NetworkManagerTests {
    
    private func waitFor<T>(publisher: AnyPublisher<T, APIError>) throws -> T {
        
        let expectation = XCTestExpectation(description: "Completion")
        var result: Result<T, Error>?
        
        let cancellable = publisher
            .sink(receiveCompletion: { completion in
                
                if case let .failure(error) = completion {
                    
                    result = .failure(error)
                }
                
                expectation.fulfill()
                
            }, receiveValue: { value in
                
                result = .success(value)
            })
        
        defer {
            
            cancellable.cancel()
        }
        wait(for: [expectation], timeout: 1)
        
        return try result!.get()
    }
}

extension NetworkManagerTests {
    
    private func buildBreeds() -> [BreedModel] {
        
        return [BreedModel(name: "Coton",
                           breedGroup: nil,
                           origin: nil,
                           category: nil,
                           temperament: nil,
                           image: nil),
                BreedModel(name: "Maltese",
                           breedGroup: nil,
                           origin: nil,
                           category: nil,
                           temperament: nil,
                           image: nil)
        ]
    }
}
