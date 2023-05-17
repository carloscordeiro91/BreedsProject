//
//  NetworkManager+Resources.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 17/05/2023.
//

import Foundation

extension NetworkManager {
    
    enum APIError: Error {
        
        case invalidResponse
        case invalidURL
        case networkError(Error)
    }
    
    enum DataType {
        
        case search(text: String)
        case breed(breedId: Int)
        case breeds(pageNumber: Int)
        
        var url: URL? {
            
            var path: String
            
            switch self {
                
            case .search:
                path = Paths.search
                
            case .breed:
                path = Paths.breedId
                
            case .breeds:
                path = Paths.breeds
            }
            
            return BaseURL.baseURL?.appending(path: path)
        }
        
        var queryItems: [URLQueryItem] {
            
            switch self {
                
            case .search:
                return []
                
            case .breed:
                return []
                
            case .breeds(pageNumber: let pageNumber):
                return [
                    URLQueryItem(name: "limit", value: String(20)),
                    URLQueryItem(name: "page", value: String(pageNumber))
                ]
            }
        }
    }
    
    enum BaseURL {
        
        static  let baseURL = URL(string: "https://api.thedogapi.com/v1/")
    }
    
    enum Paths {
        
        static let breeds = "breeds"
        static let search = ""
        static let breedId = ""
    }
    
    enum Headers {
        
        static let apiKeyValue = "live_tx8uUBBDbdbWxEak179oWYzaQVQyMj9COYcxDKuLaZ1XyfwfaAKlZWFwjrH4dWA2"
        static let headerField = "x-api-key"
    }
}
