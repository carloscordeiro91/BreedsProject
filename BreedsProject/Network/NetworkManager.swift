//
//  NetworkManager.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation
import Combine

protocol NetworkProtocol {
    
}

class NetworkManager: NetworkProtocol {
    
    let urlSession: URLSession

    init(urlSession: URLSession) {
        
        self.urlSession = urlSession
    }
}
