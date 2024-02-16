//
//  Country.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import Foundation
import RealmSwift
import Realm

// MARK: - CountryRealm

class CountryRealm: Object, Decodable {
    
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var abbreviation: String
    @Persisted var capital: String
    @Persisted var currency: String
    @Persisted var phone: String
    @Persisted var population: Int?
    @Persisted var media: MediaRealm?
    
    enum CodingKeys: String, CodingKey {
        case id, name, abbreviation, capital, currency, phone, population, media
    }
    
    // MARK: - Initializers
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, name: String, abbreviation: String, capital: String, currency: String, phone: String, population: Int?, media: MediaRealm?) {
        self.init()
        self.id = id
        self.name = name
        self.abbreviation = abbreviation
        self.capital = capital
        self.currency = currency
        self.phone = phone
        self.population = population
        self.media = media
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        abbreviation = try container.decode(String.self, forKey: .abbreviation)
        capital = try container.decode(String.self, forKey: .capital)
        currency = try container.decode(String.self, forKey: .currency)
        phone = try container.decode(String.self, forKey: .phone)
        population = try container.decodeIfPresent(Int.self, forKey: .population)
        media = try container.decodeIfPresent(MediaRealm.self, forKey: .media)
        
    }
    
}

// MARK: - MediaRealm

class MediaRealm: Object, Decodable {
    
    @Persisted var flag: String?
    @Persisted var emblem: String?
    @Persisted var orthographic: String?
    
    convenience init(flag: String?, emblem: String?, orthographic: String?) {
        self.init()
        self.flag = flag
        self.emblem = emblem
        self.orthographic = orthographic
    }
}
