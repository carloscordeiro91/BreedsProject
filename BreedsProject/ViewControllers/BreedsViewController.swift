//
//  BreedsViewController.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 16/05/2023.
//

import UIKit

class BreedsViewController: UIViewController {
    
    // Data
    var items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

    // Views
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var barButtonItem = UIBarButtonItem()
    
    // State
    var isGridMode = false {
        
        didSet {
            
            self.configureFlowLayout()
            self.updateBarButtonImage()
            self.configureDataSource()
            self.applySnapshot()
        }
    }
    
    // Data Source
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, String>?

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
    private let viewModel: BreedsViewModel
    
    //MARK: Initializer
    
    init(viewModel: BreedsViewModel,
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
        
        self.configureViews()
        
        self.configureDataSource()
        
        self.applySnapshot()
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

        self.barButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.squareGridImage),
                                             style: .plain,
                                             target: self,
                                             action: #selector(self.toggleLayout))
        
        self.navigationItem.rightBarButtonItem = self.barButtonItem
    }
    
    func updateBarButtonImage() {
        
        let imageName = self.isGridMode ? Constants.listBulletImage : Constants.squareGridImage
        self.barButtonItem.image = UIImage(systemName: imageName)
    }
    
    func configureCollectionView() {
        
        self.collectionView.frame = self.view.bounds
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(GridCell.self, forCellWithReuseIdentifier: Constants.gridCellIdentifier)
        self.collectionView.register(ListCell.self, forCellWithReuseIdentifier: Constants.listCellIdentifier)
    }
    
    func configureFlowLayout() {
        
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        if self.isGridMode {
            
            layout.itemSize = CGSize(width: (self.collectionView.frame.width - 10) / 2,
                                     height: (self.collectionView.frame.width - 10) / 2)
            
        } else {
            
            layout.itemSize = CGSize(width: self.collectionView.frame.width, height: 60)
        }
    }
    
    func addSubviews() {
        
        self.view.addSubview(self.collectionView)
    }
}

//MARK: User Interaction

private extension BreedsViewController {
    
    @objc func toggleLayout() {
        
        self.isGridMode.toggle()
     }
}

//MARK: Data Source Configuration

private extension BreedsViewController {
    
    func configureDataSource() {
        
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: self.collectionView) { collectionView, indexPath, item in
            
            if self.isGridMode {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gridCellIdentifier,
                                                                    for: indexPath) as? GridCell else {
                    
                    return UICollectionViewCell()
                }
                
                cell.textLabel.text = item
                
                return cell
                
            } else {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.listCellIdentifier,
                                                                    for: indexPath) as? ListCell else {
                    
                    return UICollectionViewCell()
                }
                
                cell.textLabel.text = item
                
                return cell
            }
        }
    }
    
    private func applySnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.breeds])
        snapshot.appendItems(self.items, toSection: .breeds)
        self.diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// Dummy Cells for layout testing purposes - it will be deleted

class GridCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ListCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
