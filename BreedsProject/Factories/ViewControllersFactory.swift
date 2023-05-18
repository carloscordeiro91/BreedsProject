//
//  ViewControllersFactory.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit

final class ViewControllersFactory {
    
    private let coreDependencies: HasCoreDependencies
    
    init(coreDependencies: HasCoreDependencies) {
        
        self.coreDependencies = coreDependencies
    }
    
    func makeTabBarViewController(navigator: BreedDetailsNavigationProtocol) -> UITabBarController {
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemBackground
        
        let breedsController = UINavigationController(rootViewController: self.makeBreedsViewController(navigator: navigator))
        breedsController.title = "Breeds"
        let breedsSearchController = UINavigationController(rootViewController: self.makeBreedsSearchViewController(navigator: navigator))
        breedsSearchController.title = "Search"
        
        tabBarController.setViewControllers([breedsController, breedsSearchController], animated: false)
        
        if let items = tabBarController.tabBar.items {
            
            let images = ["house", "magnifyingglass"]
            
            for x in 0..<items.count {
                
                items[x].image = UIImage(systemName: images[x])
            }
        }
        
        return tabBarController
    }
    
    func makeBreedsViewController(navigator: BreedDetailsNavigationProtocol) -> UIViewController {
        
        let viewModel = BreedsViewModel(networkService: self.coreDependencies.network)
        let imageDownloader = ImageDownloadManager(imageCache: self.coreDependencies.imageCache)

        return BreedsViewController(viewModel: viewModel,
                                    imageDownloader: imageDownloader,
                                    navigator: navigator)
    }
    
    func makeBreedsSearchViewController(navigator: BreedDetailsNavigationProtocol) -> UIViewController {
        
        let viewModel = BreedsSearchViewModel(networkService: self.coreDependencies.network)
        
        return BreedsSearchViewController(viewModel: viewModel,
                                          navigator: navigator)
    }
    
    func makeBreedDetailsViewController(breedModel: BreedModel) -> UIViewController {
        
        return BreedDetailsViewController(breedModel: breedModel)
    }
}
