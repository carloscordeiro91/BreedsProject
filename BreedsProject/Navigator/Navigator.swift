//
//  Navigator.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import Foundation
import UIKit

final class Navigator {
    
    private weak var tabBarController: UITabBarController?
    private let viewControllersFactory: ViewControllersFactory
    
    init(coreDependencies: HasCoreDependencies) {

        self.viewControllersFactory = ViewControllersFactory(coreDependencies: coreDependencies)
    }
}

extension Navigator: BreedDetailsNavigationProtocol  {
    
    @discardableResult
    func navigateToTabViewController() -> UITabBarController {
        
        let viewController = self.viewControllersFactory.makeTabBarViewController(navigator: self)
        
        self.tabBarController = viewController
        
        return viewController
    }
    
    @discardableResult
    func navigateToBreedDetailsViewController(with breedModel: BreedModel) -> UIViewController? {
        
        let detailsViewController = self.viewControllersFactory.makeBreedDetailsViewController(breedModel: breedModel)
        
        guard let navigationController = self.tabBarController?.selectedViewController as? UINavigationController else {
            
            return nil
        }
        
        navigationController.pushViewController(detailsViewController, animated: true)
        
        return detailsViewController
    }
}

extension Navigator: ActionSheetNavigationProtocol {
    
    func navigateToErrorAlert(completion: @escaping () -> ()) -> UIAlertController? {
        
        let errorAlertViewController = UIAlertController(title: "Error",
                                                         message: "There is an error fetching tthe data. Please retry",
                                                         preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                
            completion()
        }
        
        errorAlertViewController.addAction(retryAction)
        
        guard let navigationController = self.tabBarController?.selectedViewController as? UINavigationController else {
            
            return nil
        }
        
        navigationController.topViewController?.present(errorAlertViewController, animated: true)
        
        return errorAlertViewController
    }
}
