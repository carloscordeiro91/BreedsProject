//
//  ListCell.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 17/05/2023.
//

import UIKit
import Combine

final class ListCell: UICollectionViewCell {
    
    private enum Constants {
        
        static let imageViewSize: CGFloat = 48.0
        static let placeholderPhotoName = "photo"
        static let stackViewHorizontalMargin: CGFloat = 16.0
        static let stackViewVerticalMargin: CGFloat = 4.0
    }
    
    var imageDownloader: ImageDownloadProtocol?
    var imageCancellable: AnyCancellable?
    
    private let horizontalStackView = UIStackView().usingAutoLayout()
    private let breedImageView = UIImageView().usingAutoLayout()
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

extension ListCell {
    
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
        
    }
}

private extension ListCell {
    
    func configureSubviews() {
        
        self.horizontalStackView.distribution = .fillProportionally
        self.horizontalStackView.alignment = .center
        self.horizontalStackView.spacing = 16.0
    }
    
    func addSubviews() {
        
        self.addSubview(self.horizontalStackView)
        self.horizontalStackView.addArrangedSubview(self.breedImageView)
        self.horizontalStackView.addArrangedSubview(self.breedNameLabel)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            self.horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.stackViewVerticalMargin),
            self.horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.stackViewHorizontalMargin),
            self.horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.stackViewHorizontalMargin),
            self.horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.stackViewVerticalMargin),
            self.breedImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),
            self.breedImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize)
        ])
    }
}
