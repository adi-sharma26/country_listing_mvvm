//
//  HomeViewController.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    // MARK: - Private IBOutlets
    
    @IBOutlet private weak var searchView: SearchBarView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.color = .gray
            activityIndicator.backgroundColor = .white
            activityIndicator.tintColor = .black
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: - Private Properties
    
    private var cancellables: Set<AnyCancellable> = []
    private var headerView: HomeHeaderView!

    // MARK: - Public/Internal Properties
    
    var viewModel: HomeViewModel!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
    }
    
    // MARK: - Private Methods
    
    private func configureUserInterface() {
        
        searchView.delegate = self
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
                
        addCustomHeaderView()
        setupObservers()
        viewModel.onViewDidLoad()
        configureTableView()
    }
    
    private func addCustomHeaderView() {
        headerView = HomeHeaderView(frame: navigationController?.navigationBar.bounds ?? CGRect.zero)
        navigationController?.navigationBar.topItem?.titleView = headerView
    }
    
    private func setupObservers() {
        viewModel.$countriesList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countriesList in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        
        registerTableViewCells()
        
        tableView.estimatedRowHeight = 100
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerTableViewCells() {
        tableView.register(UINib(nibName: CountryTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: CountryTableViewCell.className)
    }
    
}

// MARK: - HomeViewController Extensions
// MARK: - UITableViewDataSource Implementation

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.className,
                                                       for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(model: viewModel.countriesList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITableViewDelegate Implementation

extension HomeViewController: UITableViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight {
            viewModel.getMoreCountryList()
        }
    }
}

// MARK: - SearchBarViewDelegate Implementation

extension HomeViewController: SearchBarViewDelegate {
    
    func filterButtonTapped() {
        let filterVC = FilterViewController(nibName: FilterViewController.className, bundle: nil)
        filterVC.modalPresentationStyle = .popover
        filterVC.delegate = self
        self.navigationController?.present(filterVC, animated: true)
    }
    
    func filterCountryList(text: String) {
        viewModel.filterCountryList(name: text)
    }
    
    func countryNameFilterRemoved() {
        viewModel.removeCountryNameFilter()
    }
}

// MARK: - HomeHeaderViewDelegate Implementation

extension HomeViewController: HomeHeaderViewDelegate {
    
    func profileButtonTapped() {
        print("Profile Button Tapped")
    }
    
}

// MARK: - FilterViewControllerDelegate Implementation

extension HomeViewController: FilterViewControllerDelegate {
    func didSelectFilterAt(index: Int) {
        viewModel.filterCountryList(index: index)
    }
}
