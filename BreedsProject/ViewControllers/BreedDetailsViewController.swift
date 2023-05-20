//
//  BreedDetailsViewController.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 18/05/2023.
//

import UIKit
import Combine

class BreedDetailsViewController: UIViewController {
    
    //MARK: Views
    
    private let verticalStackView: UIStackView = {
        
        let stackView = UIStackView().usingAutoLayout()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    //MARK: Properties
        
    private let breedModel: BreedModel
    private let imageDownloader: ImageDownloadProtocol
    
    var imageCancellable: AnyCancellable?
    
    //MARK: Initializer
    
    init(breedModel: BreedModel,
         imageDownloader: ImageDownloadProtocol) {
        
        self.breedModel = breedModel
        self.imageDownloader = imageDownloader
                
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureSubviews()
    }
}

//MARK: UI configuration

private extension BreedDetailsViewController {
    
    func configureSubviews() {
        
        self.view.backgroundColor = .systemBackground
        self.title = self.breedModel.name
        
        self.addSubviews()
        self.configureAutoLayout()
        
        // Configure Subviews
        self.configureImageView()
        self.configureDetailsInfoView()
    }
    
    func addSubviews() {
        
        self.view.addSubview(self.verticalStackView)
    }
    
    func configureImageView() {
        
        if let imageURL = URL(string: self.breedModel.image.url) {
            
            let breedImage = UIImageView().usingAutoLayout()
            
            self.imageCancellable = self.imageDownloader.loadImage(from: imageURL)
                .sink { image in
                    
                    breedImage.image = image
                }
            
            breedImage.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
            breedImage.heightAnchor.constraint(equalTo: breedImage.widthAnchor).isActive = true
            
            let labelView = BreedDetailsViewsFactory.makeBreedNameView(with: self.breedModel.name)
            breedImage.addSubview(labelView)
            
            self.verticalStackView.addArrangedSubview(breedImage)
            
            labelView.leadingAnchor.constraint(equalTo: breedImage.leadingAnchor).isActive = true
            labelView.trailingAnchor.constraint(equalTo: breedImage.trailingAnchor).isActive =  true
            labelView.bottomAnchor.constraint(equalTo: breedImage.bottomAnchor).isActive = true
            labelView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        }
    }
    
    func configureDetailsInfoView() {
        
        if let origin = self.breedModel.origin, !origin.isEmpty {
                        
            let originView = BreedDetailsViewsFactory.makeDetailsInfoView(with: "Origin", caption: origin)
            self.verticalStackView.addArrangedSubview(originView)
        }
        
        if let group = self.breedModel.breedGroup, !group.isEmpty {
            
            let groupView = BreedDetailsViewsFactory.makeDetailsInfoView(with: "Group", caption: group)
            self.verticalStackView.addArrangedSubview(groupView)
        }
        
        if let category = self.breedModel.category, !category.isEmpty {
            
            let categoryView = BreedDetailsViewsFactory.makeDetailsInfoView(with: "Category", caption: category)
            self.verticalStackView.addArrangedSubview(categoryView)
        }
    }
    
    func configureAutoLayout() {
        
        NSLayoutConstraint.activate([
            
            self.verticalStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
