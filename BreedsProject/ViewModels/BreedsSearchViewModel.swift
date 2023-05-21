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
    
    private var cancellables = Set<AnyCancellable>()

    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol) {
        
        self.networkService = networkService
    }
    
    func searchBreeds(with searchText: String) {
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let encodedText = trimmedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        self.networkService.getData(.search(text: encodedText), ofType: [BreedModel].self)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(
                receiveCompletion: { _ in

                },
                receiveValue: { [weak self] breeds in
                    
                    self?.breeds = breeds
                }
            )
            .store(in: &self.cancellables)
    }
}
