//
//  URLSessionMock.swift
//  BreedsProjectTests
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import Combine
@testable import BreedsProject

class URLSessionMock: URLSessionProtocol {
    
    var mockedData: Data?
    var mockedError: APIError?
    
    func dataTaskPublisher(with request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        
        if let error = self.mockedError {
            
            return Fail(error: error).eraseToAnyPublisher()
            
        } else if let data = self.mockedData,
                  let url = request.url,
                  let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
            
            return Just((data, response))
                .mapError(APIError.init)
                .eraseToAnyPublisher()
            
        } else {
            
            fatalError("We must set either mockedData or mockedError")
        }
    }
}
