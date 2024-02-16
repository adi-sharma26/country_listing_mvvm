//
//  FilterHeaderView.swift
//  CountryListing
//
//  Created by Aditya Sharma on 16/02/24.
//

import UIKit

final class FilterHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Private IBOutlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 4.0
            mainView.layer.borderWidth = 1.0
            mainView.layer.borderColor = UIColor(named: "color_filter_border")?.cgColor
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Population"
        }
    }
    
    // MARK: - Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        
        Bundle.main.loadNibNamed(FilterHeaderView.className, owner: self, options: nil)
        
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(containerView)
    }
}
