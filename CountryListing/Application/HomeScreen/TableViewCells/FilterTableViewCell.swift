//
//  FilterTableViewCell.swift
//  CountryListing
//
//  Created by Aditya Sharma on 16/02/24.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {
    
    // MARK: - Private IBOutlet
    
    @IBOutlet private weak var filterLabel: UILabel!
    
    // MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor(named: "color_filter_border")?.cgColor
    }
    
    // MARK: - Internal Method
    
    func configureCell(text: String, index: Int) {
        
        if index == 3 {
            filterLabel.font = .systemFont(ofSize: 18, weight: .bold)
            filterLabel.textAlignment = .center
        } else {
            filterLabel.font = .systemFont(ofSize: 14, weight: .regular)
            filterLabel.textAlignment = .left
        }
        
        filterLabel.text = text
    }
}
