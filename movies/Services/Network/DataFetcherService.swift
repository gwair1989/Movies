//
//  DataFetcherService.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//


import Foundation

protocol DataServiseProtocol {
    func fetchData(filter: Filter, completion: @escaping (Movies?) -> Void)
    func fetchDetail(filter: Filter, completion: @escaping (Detail?) -> Void)
    func fetchGenres(filter: Filter, completion: @escaping (Genres?) -> Void)
    func fetchPreloader(filter: Filter, completion: @escaping (PreloaderModel?) -> Void)
}

class DataFetcherService: DataServiseProtocol {
    
    var networkDataFetcher: DataFetcher
    
    init(networkDataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    func fetchData(filter: Filter, completion: @escaping (Movies?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(filter: filter, response: completion)
    }
    
    func fetchGenres(filter: Filter, completion: @escaping (Genres?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(filter: filter, response: completion)
    }
    
    func fetchDetail(filter: Filter, completion: @escaping (Detail?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(filter: filter, response: completion)
    }
    
    func fetchPreloader(filter: Filter, completion: @escaping (PreloaderModel?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(filter: filter, response: completion)
    }

}


