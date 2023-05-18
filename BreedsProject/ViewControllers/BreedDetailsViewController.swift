//
//  BreedDetailsViewController.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 18/05/2023.
//

import UIKit

class BreedDetailsViewController: UIViewController {
    
    //MARK: Properties
        
    private let breedModel: BreedModel
    
    //MARK: Initializer
    
    init(breedModel: BreedModel) {
        
        self.breedModel = breedModel
                
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.title = self.breedModel.name
    }
    
}
