//
//  HomeViewModel.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import Foundation
import Combine

// MARK: - HomeViewModelProtocol Protocol Declaration

protocol HomeViewModelProtocol {
    func onViewDidLoad()
    func getCurrentCountryList() -> AnyPublisher<[CountryRealm], Never>
    func getMoreCountryList()
    func filterCountryList(index: Int)
    func filterCountryList(name: String)
    func removeCountryNameFilter()
}

// MARK: - HomeViewModel

final class HomeViewModel {
    
    // MARK: - Publisher - Published Property
    
    @Published var countriesList: [CountryRealm] = []
    
    // MARK: - Private Properties
    private var tempCountryList: [CountryRealm] = []
    private var apiClient: APIClientProtocol
    private var databaseManager: DatabaseManager
    private var startIndex = -1
    private var batchSize = 10
    private var sortingIndex = -1
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(apiClient: APIClientProtocol, databaseManager: DatabaseManager) {
        self.apiClient = apiClient
        self.databaseManager = databaseManager
    }
    
    // MARK: - Private Methods
    
    private func saveCountriesInDatabase(countries: [CountryRealm]) {
        databaseManager.saveCountryObjects(countries)
    }
    
}

// MARK: - HomeViewModel Extensions
// MARK: - HomeViewModelProtocol Implementation

extension HomeViewModel: HomeViewModelProtocol {
    
    func onViewDidLoad() {
        Task { @MainActor in
            do {
                let model: [CountryRealm]? = try await apiClient.makeRequest(urlString: URLManager.countryList, method: .get)
                
                if let model = model {
                    saveCountriesInDatabase(countries: model)
                    
                    getMoreCountryList()
                }
                
            } catch (let error) {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getCurrentCountryList() -> AnyPublisher<[CountryRealm], Never> {
        $countriesList.eraseToAnyPublisher()
    }
    
    func getMoreCountryList() {
        
        startIndex += 1
        
        guard let newList = databaseManager.getCountryObjects(startIndex: startIndex,
                                                              batchSize: batchSize) else {
            return
        }
        
        switch sortingIndex {
        case 0:
            countriesList.append(contentsOf: newList.filter( { $0.population ?? 0 < 1000000 }))
        case 1:
            countriesList.append(contentsOf: newList.filter( { $0.population ?? 0 < 5000000 }))
        case 2:
            countriesList.append(contentsOf: newList.filter( { $0.population ?? 0 < 10000000 }))
        default:
            countriesList.append(contentsOf: newList)
            tempCountryList = countriesList
            startIndex += batchSize - 1
            break
        }
    }
    
    func filterCountryList(index: Int) {
        
        sortingIndex = index
        
        countriesList = tempCountryList
        
        switch index {
            
        case 0:
            startIndex = -1
            countriesList = countriesList.filter( { $0.population ?? 0 < 1000000 })
        case 1:
            startIndex = -1
            countriesList = countriesList.filter( { $0.population ?? 0 < 5000000 })
        case 2:
            startIndex = -1
            countriesList = countriesList.filter( { $0.population ?? 0 < 10000000 })
        default:
            startIndex = -1
            tempCountryList = []
            countriesList = []
            getMoreCountryList()
            break
        }
    }
    
    func filterCountryList(name: String) {
        
        guard let allCountries = databaseManager.getAllCountryObjects() else {
            return
        }
        
        countriesList = allCountries.filter { country in
            let options: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
            return country.name.range(of: name, options: options) != nil
        }
    }
    
    func removeCountryNameFilter() {
        startIndex = -1
        tempCountryList = []
        countriesList = []
        getMoreCountryList()
    }
}
