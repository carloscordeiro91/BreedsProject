//
//  BreedModel.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 17/05/2023.
//

import Foundation

struct BreedModel: Hashable, Codable {
    
    let name: String
    let breedGroup: String?
    let origin: String?
    let category: String?
    let temperament: String?
    let image: ImageModel
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case breedGroup = "breed_group"
        case origin
        case category = "bred_for"
        case temperament
        case image
    }
}
