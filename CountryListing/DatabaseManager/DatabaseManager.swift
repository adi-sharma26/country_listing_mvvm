//
//  DatabaseManager.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    
    static let shared: DatabaseManager = {
        return DatabaseManager()
    }()
    
    private let realmQueue = DispatchQueue(label: "com.aditya.realm", qos: .background)
    private let lastFetchedIdKey = "LastFetchedIdKey"
    private var totalRecords = 0
    
    private init() { }
    
    func configureRealm() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previous version.
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Perform migration actions, if needed
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    func migrateRealm() {
        realmQueue.async {
            do {
                let _ = try Realm()
            } catch let error as NSError {
                fatalError("Error migrating Realm: \(error)")
            }
        }
    }
    
    // MARK: - Batch Fetching
    
    func getCountryObjects(startIndex: Int,
                           batchSize: Int) -> [CountryRealm]? {
        var batch: [CountryRealm]?
        
        realmQueue.sync {
            let realm = try! Realm()
            let results = realm.objects(CountryRealm.self).sorted(byKeyPath: "name")
            
            let endIndex = min(startIndex + batchSize, totalRecords)
            
            guard startIndex < totalRecords else {
                batch = nil
                return
            }
            
            batch = Array(results[startIndex..<endIndex])
            self.saveLastFetchedId(endIndex)
        }
        
        return batch
    }
    
    func getAllCountryObjects() -> [CountryRealm]? {
        var countryObjects: [CountryRealm]?
        
        realmQueue.sync {
            let realm = try! Realm()
            let results = realm.objects(CountryRealm.self)
            countryObjects = Array(results)
        }
        
        return countryObjects
    }
    
    // MARK: - Save Objects
    
    func saveCountryObjects(_ countries: [CountryRealm]) {
        
        totalRecords = countries.count
        
        realmQueue.async {
            do {
                let realm = try! Realm()
                try realm.write {
                    for country in countries {
                        let countryRealm = CountryRealm()
                        countryRealm.id = country.id
                        countryRealm.name = country.name
                        countryRealm.abbreviation = country.abbreviation
                        countryRealm.capital = country.capital
                        countryRealm.currency = country.currency
                        countryRealm.phone = country.phone
                        countryRealm.population = country.population
                        countryRealm.media = MediaRealm(flag: country.media?.flag,
                                                        emblem: country.media?.emblem,
                                                        orthographic: country.media?.orthographic)
                        realm.add(countryRealm, update: .modified)
                    }
                }
            } catch {
                print("Error saving country objects to Realm: \(error)")
            }
        }
    }
    
    private func getLastFetchedId() -> Int {
        return UserDefaults.standard.integer(forKey: lastFetchedIdKey)
    }
    
    private func saveLastFetchedId(_ id: Int) {
        UserDefaults.standard.set(id, forKey: lastFetchedIdKey)
    }
}

