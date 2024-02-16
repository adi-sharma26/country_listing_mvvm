//
//  APIClient.swift
//  CountryListing
//
//  Created by Aditya Sharma on 15/02/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(String)
}

protocol APIClientProtocol {
    func makeRequest<T: Decodable>(urlString: String, method: HTTPMethod) async throws -> T
}

final class APIClient: APIClientProtocol {
    
    func makeRequest<T: Decodable>(urlString: String, method: HTTPMethod) async throws -> T {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = (response as? HTTPURLResponse), response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        switch response.statusCode {
        case 200:
            return try JSONDecoder().decode(T.self, from: data)
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError("Server error with error code - \(response.statusCode)")
        default:
            throw NetworkError.invalidResponse
        }
        
    }
    
}
