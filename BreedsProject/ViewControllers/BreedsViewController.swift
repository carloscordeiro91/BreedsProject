//
//  BreedsViewController.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit

class BreedsViewController: UIViewController {
    
    // Views
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var layoutButtonItem: UIBarButtonItem?

    // State
    var isGridMode = false {
        
        didSet {
            
            self.configureFlowLayout()
            self.updateLayoutButtonImage()
            self.configureDataSource()
            self.applySnapshot()
        }
    }
    
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
        
    private unowned let navigator: BreedDetailsNavigationProtocol
    private let imageDownloader: ImageDownloadProtocol
    private let viewModel: BreedsViewModel
    
    //MARK: Initializer
    
    init(viewModel: BreedsViewModel,
         imageDownloader: ImageDownloadProtocol,
         navigator: BreedDetailsNavigationProtocol) {
        
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
        
        self.configureDataSource()
        
        self.bindViewModel()
        
        self.viewModel.fetchBreeds()
    }
}

//MARK: UI Configuration

private extension BreedsViewController {
    
    func configureViews() {
                
        self.configureNavBar()
        self.configureCollectionView()
        self.configureFlowLayout()
        self.addSubviews()
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
    
    func updateLayoutButtonImage() {
        
        let imageName = self.isGridMode ? Constants.listBulletImage : Constants.squareGridImage
        self.layoutButtonItem?.image = UIImage(systemName: imageName)
    }
    
    func configureCollectionView() {
        
        self.collectionView.frame = self.view.bounds
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(GridCell.self, forCellWithReuseIdentifier: Constants.gridCellIdentifier)
        self.collectionView.register(ListCell.self, forCellWithReuseIdentifier: Constants.listCellIdentifier)
        self.collectionView.delegate = self
    }
    
    func configureFlowLayout() {
        
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        if self.isGridMode {
            
            layout.itemSize = CGSize(width: (self.collectionView.frame.width - 10) / 2,
                                     height: (self.collectionView.frame.width - 10) / 2)
            
        } else {
            
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 56)
        }
    }
    
    func addSubviews() {
        
        self.view.addSubview(self.collectionView)
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
            .store(in: &self.viewModel.cancellables)
    }
}

//MARK: User Interaction

private extension BreedsViewController {
    
    @objc
    func didPressLayoutButton() {
        
        self.isGridMode.toggle()
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
    
    func configureDataSource() {
        
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, BreedModel>(collectionView: self.collectionView) { collectionView, indexPath, item in
            
            if self.isGridMode {
                
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
