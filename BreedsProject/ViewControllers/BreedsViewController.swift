//
//  BreedsViewController.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit
import Combine

typealias BreedsNavigationProtocol = BreedDetailsNavigationProtocol & ActionSheetNavigationProtocol

class BreedsViewController: UIViewController {
    
    // Views
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView(style: .medium).usingAutoLayout()
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    private var layoutButtonItem: UIBarButtonItem?
    
    // Data Source
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, BreedModel>?

    private enum Section {
        
        case breeds
    }
    
    //MARK: Constants
    
    private enum Constants {
        
        static let squareGridImage = "square.grid.2x2"
        static let listBulletImage = "list.bullet"
        
        static let gridCellIdentifier = "GridCell"
        static let listCellIdentifier = "ListCell"
    }

    //MARK: Properties
        
    private unowned let navigator: BreedsNavigationProtocol
    private let imageDownloader: ImageDownloadProtocol
    private let viewModel: BreedsViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: Initializer
    
    init(viewModel: BreedsViewModel,
         imageDownloader: ImageDownloadProtocol,
         navigator: BreedsNavigationProtocol) {
        
        self.viewModel  = viewModel
        self.imageDownloader = imageDownloader
        self.navigator = navigator
                
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureViews()
        
        self.configureDataSource(isGridMode: false)
        
        self.bindViewModel()
        
        self.viewModel.fetchBreeds()
    }
}

//MARK: UI Configuration

private extension BreedsViewController {
    
    func configureViews() {
                
        self.configureNavBar()
        self.configureCollectionView()
        self.configureFlowLayout(isGridMode: false)
        self.addSubviews()
        self.configureAutoLayout()
    }
    
    func configureNavBar() {
        
        self.title = "Breeds"

        self.layoutButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.squareGridImage),
                                                style: .plain,
                                                target: self,
                                                action: #selector(self.didPressLayoutButton))
        
        guard let layoutButtonItem = self.layoutButtonItem else { return }
        
        self.navigationItem.rightBarButtonItems = [layoutButtonItem]
    }
    
    func updateLayoutButtonImage(isGridMode: Bool) {
        
        let imageName = isGridMode ? Constants.listBulletImage : Constants.squareGridImage
        self.layoutButtonItem?.image = UIImage(systemName: imageName)
    }
    
    func configureCollectionView() {
        
        self.collectionView.frame = self.view.bounds
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(GridCell.self, forCellWithReuseIdentifier: Constants.gridCellIdentifier)
        self.collectionView.register(ListCell.self, forCellWithReuseIdentifier: Constants.listCellIdentifier)
        self.collectionView.delegate = self
    }
    
    func configureFlowLayout(isGridMode: Bool) {
        
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        if isGridMode {
            
            layout.itemSize = CGSize(width: (self.collectionView.frame.width - 10) / 2,
                                     height: (self.collectionView.frame.width - 10) / 2)
            
        } else {
            
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 56)
        }
    }
    
    func addSubviews() {
        
        self.view.addSubview(self.collectionView)
        self.collectionView.addSubview(self.activityIndicator)
    }
    
    func configureAutoLayout() {
        
        NSLayoutConstraint.activate([
        
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.collectionView.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

//MARK: ViewModel Binding

extension BreedsViewController {
    
    func bindViewModel () {
        
        self.viewModel.$breeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                self?.applySnapshot()
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                                
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .store(in: &self.cancellables)
        
        self.viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                
                if error != nil {
                    
                    self?.navigator.navigateToErrorAlert {
                        
                        self?.viewModel.fetchBreeds()
                    }
                }
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$isGridMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isGridMode in
                
                self?.configureFlowLayout(isGridMode: isGridMode)
                self?.updateLayoutButtonImage(isGridMode: isGridMode)
                self?.configureDataSource(isGridMode: isGridMode)
                self?.applySnapshot()
            }
            .store(in: &self.cancellables)
    }
}

//MARK: User Interaction

private extension BreedsViewController {
    
    @objc
    func didPressLayoutButton() {
        
        self.viewModel.isGridModeToggleWasPressed()
    }
}

extension BreedsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let breedModel = self.diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        
        self.navigator.navigateToBreedDetailsViewController(with: breedModel)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let lastIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if indexPath.item == lastIndex {

            self.viewModel.fetchBreeds()
        }
    }
}

//MARK: Data Source Configuration

private extension BreedsViewController {
    
    func configureDataSource(isGridMode: Bool) {
        
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, BreedModel>(collectionView: self.collectionView) { collectionView, indexPath, item in
            
            if isGridMode {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gridCellIdentifier,
                                                                    for: indexPath) as? GridCell else {
                    
                    return UICollectionViewCell()
                }
                
                cell.configure(with: item, imageDownloader: self.imageDownloader)
                
                return cell
                
            } else {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.listCellIdentifier,
                                                                    for: indexPath) as? ListCell else {
                    
                    return UICollectionViewCell()
                }
                
                cell.configure(with: item, imageDownloader: self.imageDownloader)
                
                return cell
            }
        }
    }
    
    private func applySnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, BreedModel>()
        snapshot.appendSections([.breeds])
        snapshot.appendItems(self.viewModel.breeds, toSection: .breeds)
        self.diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
