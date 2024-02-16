//
//  NSObjectExtensions.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

