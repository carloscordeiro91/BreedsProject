//
//  BreedsViewModel.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation

class BreedsViewModel {
    
    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol) {
        
        self.networkService = networkService
    }
}
