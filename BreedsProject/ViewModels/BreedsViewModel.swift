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
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var isLoading = false
    @Published var error: APIError?
    @Published var isGridMode: Bool = false
    @Published private(set) var breeds: [BreedModel] = []
    
    private var currentPage = 0

    init(networkService: NetworkProtocol) {
        
        self.networkService = networkService
    }
    
    func fetchBreeds() {
        
        self.isLoading = true
        
        self.networkService.getData(.breeds(pageNumber: self.currentPage), ofType: [BreedModel].self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                self.isLoading = false
                
                switch completion {
                    
                case .finished:
                    print("fetch breeds finished successfully")
                    
                case .failure(let error):
                    self.error = error
                }
                
            }, receiveValue: { [weak self] breeds in
                
                self?.breeds.append(contentsOf: breeds)
                self?.currentPage += 1
            })
            .store(in: &self.cancellables)
    }
    
    func isGridModeToggleWasPressed() {
        
        self.isGridMode.toggle()
    }
}
