//
//  BreedDetailsViewsFactory.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 19/05/2023.
//

import UIKit

enum BreedDetailsViewsFactory {
    
    enum Constants {
        
        static let horizontalMargins: CGFloat = 16.0
    }
    
    static func makeBreedImageView(with image: UIImage?) -> UIImageView {
        
        let imageView = UIImageView(image: image).usingAutoLayout()
        
        return imageView
    }
    
    static func makeBreedNameView(with name: String) -> UIView {
        
        let containerView = UIView().usingAutoLayout()
        containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        let label = UILabel().usingAutoLayout()
        label.text = name
        label.textColor = .white
        label.textAlignment = .center
        
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView        
    }
    
    static func makeDetailsInfoView(with title: String, caption: String) -> UIView {
        
        let view = UIView().usingAutoLayout()
        
        let label = UILabel().usingAutoLayout()
        label.numberOfLines = 0
        label.text = String(format: "%@: %@", title, caption)
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
        
        return view
    }
}
