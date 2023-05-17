//
//  BreedsViewModel.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation
import Combine

class BreedsViewModel {
    
    private let networkService: NetworkProtocol
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published private(set) var breeds: [BreedModel] = []
    
    private var currentPage = 0

    init(networkService: NetworkProtocol) {
        
        self.networkService = networkService
    }
    
    func fetchBreeds() {
        
        self.networkService.getData(.breeds(pageNumber: self.currentPage), ofType: [BreedModel].self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                // TODO: Handle completion 
            }, receiveValue: { [weak self] breeds in
                
                self?.breeds.append(contentsOf: breeds)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
}
