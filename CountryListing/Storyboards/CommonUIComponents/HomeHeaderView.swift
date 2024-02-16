//
//  HomeHeaderView.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import UIKit

protocol HomeHeaderViewDelegate: AnyObject {
    func profileButtonTapped()
}

final class HomeHeaderView: UIView {
    
    // MARK: - Private IBOutlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "WrkSpot"
            titleLabel.textColor = UIColor(named: "color_text_grey")
        }
    }
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = Utility.formattedCurrentDate()
            dateLabel.textColor = UIColor(named: "color_text_grey")
        }
    }
    @IBOutlet private weak var profileButton: UIButton!
    
    // MARK: - Public/Internal Properties
    
    weak var delegate: HomeHeaderViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Private Methods/IBActions
    
    private func setupView() {
        Bundle.main.loadNibNamed(HomeHeaderView.className,
                                 owner: self,
                                 options: nil)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction private func didTapProfileButton(_ sender: UIButton) {
        delegate?.profileButtonTapped()
    }
}
