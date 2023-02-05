//
//  NetworkDataFetcher.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import Foundation

protocol DataFetcher {
    func fetchGenericJSONData<T: Decodable>(filter: Filter, response: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    var networking: Networking
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func fetchGenericJSONData<T: Decodable>(filter: Filter, response: @escaping (T?) -> Void) {
        networking.request(filter: filter) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}

