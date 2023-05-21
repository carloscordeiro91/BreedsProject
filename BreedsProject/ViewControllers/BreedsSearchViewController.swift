//
//  BreedsSearchViewController.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit
import Combine

class BreedsSearchViewController: UITableViewController {
    
    //MARK: Constants
    
    private enum Constants {
        
        static let searchCellIdentifier = "SearchCell"
    }
    
    // Data Source
    private var diffableDataSource: UITableViewDiffableDataSource<Section, BreedModel>?

    private enum Section {
        
        case breeds
    }

    //MARK: Properties
        
    private unowned let navigator: BreedDetailsNavigationProtocol
    private let viewModel: BreedsSearchViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var cancellables = Set<AnyCancellable>()
    
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
        
        self.configureTableView()
        self.configureGestureRecognizer()
        self.configureSearchController()
        self.configureDataSource()

        self.bindViewModel()
    }
}

private extension BreedsSearchViewController {
    
    func configureTableView() {
        
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: Constants.searchCellIdentifier)
    }
    
    func configureGestureRecognizer() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func configureSearchController() {
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Breeds"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func bindViewModel() {
        
        self.viewModel.$breeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                self?.applySnapshot()
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func handleTapGesture() {
        
        self.searchController.searchBar.resignFirstResponder()
    }
}

//MARK: UISearchResultsUpdating

extension BreedsSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        
        self.viewModel.searchBreeds(with: searchText)
    }
}

//MARK: UITableViewDelegate

extension BreedsSearchViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let breedModel = self.diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        
        self.navigator.navigateToBreedDetailsViewController(with: breedModel)
    }
}

//MARK: Data Source Configuration

private extension BreedsSearchViewController {
    
    func configureDataSource() {
        
        self.diffableDataSource = UITableViewDiffableDataSource<Section, BreedModel>(tableView: tableView) { tableView, indexPath, breed in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchCellIdentifier,
                                                           for: indexPath) as? SearchCell else {
                
                fatalError("Unable to dequeue BreedTableViewCell")
            }
            
            cell.configure(with: breed)
            
            return cell
        }
    }
    
    private func applySnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, BreedModel>()
        snapshot.appendSections([.breeds])
        snapshot.appendItems(self.viewModel.breeds, toSection: .breeds)
        self.diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
