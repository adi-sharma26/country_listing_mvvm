//
//  FilterViewController.swift
//  CountryListing
//
//  Created by Aditya Sharma on 16/02/24.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilterAt(index: Int)
}

final class FilterViewController: UIViewController {
    
    // MARK: - Private IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private var filterList = ["< 1 M", "< 5 M", "< 10 M", "Clear Filter"]
    
    // MARK: - Public/Internal Properties
    
    weak var delegate: FilterViewControllerDelegate?
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    // MARK: - Private Methods
    
    private func configureTableView() {
        
        let nib = UINib(nibName: FilterTableViewCell.className, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FilterTableViewCell.className)
        
        let headerView = FilterHeaderView(frame: CGRect(origin: tableView.frame.origin,
                                                        size: CGSize(width: tableView.frame.size.width,
                                                                     height: 64)))
        
        tableView.tableHeaderView = headerView
        tableView.estimatedRowHeight = 64
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - FilterViewController Extensions
// MARK: - UITableViewDataSource Implementation

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.className,for: indexPath) as! FilterTableViewCell
        cell.configureCell(text: filterList[indexPath.row], index: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate Implementation

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.didSelectFilterAt(index: indexPath.row)
        }
    }
}
