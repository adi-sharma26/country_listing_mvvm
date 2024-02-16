//
//  SearchBarView.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import UIKit

protocol SearchBarViewDelegate: AnyObject {
    func filterButtonTapped()
    func filterCountryList(text: String)
    func countryNameFilterRemoved()
}

final class SearchBarView: UIView {
    
    // MARK: - Private IBOutlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var searchView: UIView! {
        didSet {
            searchView.layer.borderWidth = 1.0
            searchView.layer.borderColor = UIColor(named: "color_border")?.cgColor
            searchView.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.leftView = getLeftView()
            textField.leftViewMode = .always
            textField.clearButtonMode = .whileEditing
            textField.autocorrectionType = .no
        }
    }
    @IBOutlet private weak var filterButton: UIButton!
    
    // MARK: - Public/Internal Properties
    
    weak var delegate: SearchBarViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Private IBActions/Methods
    
    private func setupView() {
        
        Bundle.main.loadNibNamed(SearchBarView.className, owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func getLeftView() -> UIView {
        
        let padding: CGFloat = 8
        
        let leftView = UIView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.backgroundColor = UIColor.clear
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "search")
        
        leftView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: -padding),
            imageView.topAnchor.constraint(equalTo: leftView.topAnchor, constant: padding),
            imageView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor, constant: -padding),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return leftView
    }
    
    @IBAction private func didTapFilterButton(_ sender: UIButton) {
        delegate?.filterButtonTapped()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text != "" {
            delegate?.filterCountryList(text: text)
        } else {
            delegate?.countryNameFilterRemoved()
        }
    }
}

// MARK: - SearchBarView Extensions
// MARK: - UITextFieldDelegate Implementation

extension SearchBarView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
