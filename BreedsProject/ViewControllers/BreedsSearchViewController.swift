//
//  BreedsSearchViewController.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit

class BreedsSearchViewController: UITableViewController {
    
    //MARK: Constants
    
    private enum Constants {}

    //MARK: Properties
        
    private unowned let navigator: BreedDetailsNavigationProtocol
    private let viewModel: BreedsSearchViewModel
    
    //MARK: Initializer
    
    init(viewModel: BreedsSearchViewModel,
         navigator: BreedDetailsNavigationProtocol) {
        
        self.viewModel  = viewModel
        self.navigator = navigator
                
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        self.view.backgroundColor = .blue

    }
}
