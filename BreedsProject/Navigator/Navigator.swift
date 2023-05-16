//
//  Navigator.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation
import UIKit

final class Navigator {
    
    weak var navigationController: UINavigationController?
    let viewControllersFactory: ViewControllersFactory
    
    init(coreDependencies: HasCoreDependencies) {

        self.viewControllersFactory = ViewControllersFactory(coreDependencies: coreDependencies)
    }
}

extension Navigator: BreedDetailsNavigationProtocol  {
    
    @discardableResult
    func navigateToBreedDetailsViewController() -> UIViewController? {
        
        return UIViewController()
    }
}
