//
//  GridCell.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 17/05/2023.
//

import UIKit
import Combine

final class GridCell: UICollectionViewCell {
    
    private enum Constants {
        
        static let imageViewSize: CGFloat = 48.0
        static let placeholderPhotoName = "photo"
    }
    
    var imageDownloader: ImageDownloadProtocol?
    var imageCancellable: AnyCancellable?
    
    private let breedImageView = UIImageView().usingAutoLayout()
    private let containerLabel = UIView().usingAutoLayout()
    private let breedNameLabel = UILabel().usingAutoLayout()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.configureSubviews()
        self.addSubviews()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.breedNameLabel.text = nil
        self.breedImageView.image = nil
    
        self.imageCancellable?.cancel()
    }
}

extension GridCell {
    
    func configure(with breedModel: BreedModel,
                   imageDownloader: ImageDownloadProtocol) {
        
        self.imageDownloader = imageDownloader
        
        // Configure Breed Image
        if let imageURLString = breedModel.image?.url,
           let imageUrl = URL(string: imageURLString) {
            
            self.imageCancellable = self.imageDownloader?.loadImage(from: imageUrl)
                .sink { [weak self] image in
                    
                    self?.breedImageView.image = image
                }
        } else {
            
            self.breedImageView.image = UIImage(systemName: Constants.placeholderPhotoName)
        }
        
        //Configure Breed Name
        self.breedNameLabel.text = breedModel.name
        self.breedNameLabel.adjustsFontSizeToFitWidth = true
    }
}

private extension GridCell {
    
    func configureSubviews() {
        
        self.containerLabel.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.breedNameLabel.textColor = .white
        self.breedNameLabel.textAlignment = .center
    }
    
    func addSubviews() {
        
        self.addSubview(self.breedImageView)
        self.breedImageView.addSubview(self.containerLabel)
        self.containerLabel.addSubview(self.breedNameLabel)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            self.breedImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.breedImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.breedImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.breedImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerLabel.leadingAnchor.constraint(equalTo: self.breedImageView.leadingAnchor),
            self.containerLabel.trailingAnchor.constraint(equalTo: self.breedImageView.trailingAnchor),
            self.containerLabel.bottomAnchor.constraint(equalTo: self.breedImageView.bottomAnchor),
            self.containerLabel.heightAnchor.constraint(equalToConstant: 30.0),
            self.breedNameLabel.leadingAnchor.constraint(equalTo: self.containerLabel.leadingAnchor),
            self.breedNameLabel.trailingAnchor.constraint(equalTo: self.containerLabel.trailingAnchor),
            self.breedNameLabel.centerYAnchor.constraint(equalTo: self.containerLabel.centerYAnchor)
        ])
    }
}
