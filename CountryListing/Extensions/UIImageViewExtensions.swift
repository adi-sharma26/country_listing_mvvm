//
//  UIImageViewExtensions.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(imageUrl: String?) {
        self.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: UIImage(named: "placeholder"))
    }
    
}
