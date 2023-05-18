//
//  NavigationProtocols.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit

protocol BreedDetailsNavigationProtocol: AnyObject {
    
    @discardableResult
    func navigateToBreedDetailsViewController(with breedModel: BreedModel) -> UIViewController?
}
