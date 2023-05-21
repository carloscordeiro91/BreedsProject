//
//  BreedsSearchViewModel.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation
import Combine

class BreedsSearchViewModel {
    
    @Published var breeds: [BreedModel] = []
    @Published var isLoading = false
    @Published var error: APIError?
    
    private var cancellables = Set<AnyCancellable>()

    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol) {
        
        self.networkService = networkService
    }
    
    func searchBreeds(with searchText: String) {
        
        self.isLoading = true
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let encodedText = trimmedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        self.networkService.getData(.search(text: encodedText), ofType: [BreedModel].self)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(
                receiveCompletion: { completion in

                    self.isLoading = false
                    
                    switch completion {
                        
                    case .finished:
                        print("fetch breeds finished successfully")
                        
                    case .failure(let error):
                        self.error = error
                    }
                },
                receiveValue: { [weak self] breeds in
                    
                    self?.breeds = breeds
                }
            )
            .store(in: &self.cancellables)
    }
}
