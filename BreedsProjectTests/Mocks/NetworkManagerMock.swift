//
//  NetworkManagerMock.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import Combine
import XCTest
@testable import BreedsProject

class NetworkManagerMock: NetworkProtocol {
    
    var error: APIError?
    var breedsResponse: [BreedModel]?
    
    func getData<T>(_ dataType: NetworkManager.DataType, ofType type: T.Type) -> AnyPublisher<T, APIError> where T : Decodable {
        
        if let error = self.error {
            
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let breedsResponse = self.breedsResponse as? T {
            
            return Just(breedsResponse).setFailureType(to: APIError.self).eraseToAnyPublisher()
        }
        
        return Fail(error: APIError.genericError).eraseToAnyPublisher()
    }
}
