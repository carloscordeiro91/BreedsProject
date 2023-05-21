//
//  URLSession+URLSessionProtocol.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    
    func dataTaskPublisher(with request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), APIError>
}

extension URLSession: URLSessionProtocol {
    
    func dataTaskPublisher(with request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        
        return dataTaskPublisher(for: request)
            .tryMap { data, response in
                
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    
                    throw APIError.genericError
                }
                return (data, response)
            }
            .mapError(APIError.init)
            .eraseToAnyPublisher()
    }
}
