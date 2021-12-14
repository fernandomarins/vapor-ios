//
//  HTTPClient.swift
//  vapor-ios
//
//  Created by Fernando Marins on 13/12/21.
//

import Foundation

enum HTTPMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HTTPHeaders: String {
    case contentType = "Content-Type"
}

enum HTTPError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

class HTTPClient {
    private init() {}
    
    static let shared = HTTPClient()
    
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Checking if the response is 200
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HTTPError.badResponse
        }
        
        // Checking if we were able to decode data
        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HTTPError.errorDecodingData
        }
        
        return object
    }
    
    func sendData<T: Codable>(to url: URL, object: T, httpMethod: String) async throws {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
        
        request.httpBody = try? JSONEncoder().encode(object)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HTTPError.badResponse
        }
                
    }
    
    func delete(at id: UUID, url: URL) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.DELETE.rawValue
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HTTPError.badResponse
        }
    }
}
