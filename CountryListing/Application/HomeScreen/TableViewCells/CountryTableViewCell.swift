//
//  CountryTableViewCell.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import UIKit

final class CountryTableViewCell: UITableViewCell {
    
    // MARK: - Private IBOutlets
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet private weak var countryName: UILabel! {
        didSet {
            countryName.textColor = UIColor(named: "color_grey_text")
        }
    }
    @IBOutlet private weak var capitalLabel: UILabel! {
        didSet {
            capitalLabel.textColor = UIColor(named: "color_text_blue")
        }
    }
    @IBOutlet private weak var currencyLabel: UILabel! {
        didSet {
            currencyLabel.textColor = UIColor(named: "color_text_blue")
        }
    }
    @IBOutlet private weak var populationLabel: UILabel! {
        didSet {
            populationLabel.textColor = UIColor(named: "color_text_blue")
        }
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public/Internal Method
    
    func configureCell(model: CountryRealm?) {
        flagImageView.setImage(imageUrl: model?.media?.flag)
        countryName.text = model?.name
        capitalLabel.text = "Capital: \(model?.capital ?? "")"
        currencyLabel.text = "Currency: \(model?.currency ?? "")"
        populationLabel.text = "Population: \(model?.population ?? 0)"
    }
}
