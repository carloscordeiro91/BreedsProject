//
//  SearchCell.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 21/05/2023.
//

import UIKit

final class SearchCell: UITableViewCell {
    
    private enum Constants {
        
        static let stackViewHorizontalMargin: CGFloat = 16.0
        static let stackViewVerticalMargin: CGFloat = 4.0
        static let stringFoormat = "%@: %@"
    }
        
    private let verticalStackView: UIStackView = {
        
        let stackView = UIStackView().usingAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
                
        self.verticalStackView.subviews.forEach { view in
            
            view.removeFromSuperview()
        }
    }
}

extension SearchCell {
    
    func configure(with breedModel: BreedModel) {
                
        //Configure Breed Name
        let breedNameLabel = UILabel().usingAutoLayout()
        breedNameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        breedNameLabel.numberOfLines = 0
        breedNameLabel.text = breedModel.name
        
        self.verticalStackView.addArrangedSubview(breedNameLabel)
        
        //Configure Breed Group
        if let breedGroup = breedModel.breedGroup {
            
            let breedGroupLabel = UILabel().usingAutoLayout()
            breedGroupLabel.text = String(format: Constants.stringFoormat, "Group", breedGroup)
            breedGroupLabel.numberOfLines = 0
            
            self.verticalStackView.addArrangedSubview(breedGroupLabel)
        }
        
        //Configure Breed Origin
        if let breedOrigin = breedModel.origin {
            
            let breedOriginLabel = UILabel().usingAutoLayout()
            breedOriginLabel.text = String(format: Constants.stringFoormat, "Origin", breedOrigin)
            breedOriginLabel.numberOfLines = 0
            
            self.verticalStackView.addArrangedSubview(breedOriginLabel)
        }
    }
}

private extension SearchCell {
    
    func addSubviews() {
        
        self.addSubview(self.verticalStackView)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
           
            self.verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.stackViewVerticalMargin),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.stackViewHorizontalMargin),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.stackViewHorizontalMargin),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.stackViewVerticalMargin),
        ])
    }
}
