//
//  UIView+AutoLayout.swift
//  BreedsProject
//
//  Created by Carlos Cordeiro on 17/05/2023.
//

import UIKit

extension UIView {
    
    @discardableResult
    func usingAutoLayout() -> Self {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        return self
    }
}
