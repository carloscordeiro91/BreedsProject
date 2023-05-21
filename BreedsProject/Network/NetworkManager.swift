//
//  NetworkManager.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation
import Combine

protocol NetworkProtocol {
    
    func getData<T: Decodable>(_ dataType: NetworkManager.DataType,
                               ofType type: T.Type) -> AnyPublisher<T, APIError>
}

enum APIError: Error {
    
    case invalidResponse
    case invalidURL
    case networkError(Error)
}

class NetworkManager: NetworkProtocol {
    
    let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        
        self.urlSession = urlSession
    }
        
    func getData<T: Decodable>(_ dataType: DataType, ofType type: T.Type) -> AnyPublisher<T, APIError> {
        
        guard let url = dataType.url else {
            
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = dataType.queryItems
        
        guard let componentsURL = components?.url else {
            
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: componentsURL)
        request.addValue(Headers.apiKeyValue, forHTTPHeaderField: Headers.headerField)
        
        return self.urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError { error -> APIError in
                
                if let apiError = error as? APIError {
                    
                    return apiError
                    
                } else {
                    
                    return APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
