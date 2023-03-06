//
//  NetworkService.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import Foundation

protocol Networking {
    func request(filter: Filter, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
    
    func request(filter: Filter, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParaments(filter: filter)
        guard let url = self.url(filter: filter, params: parameters) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParaments(filter: Filter) -> [String: String] {
        var parameters = [String: String]()
        if filter.typeRequest != .preloader {
            parameters["api_key"] = "009d023b9ad4de2d6a5352b4a1b05b38"
            parameters["language"] = "en-US"
        }
        switch filter.typeRequest {
        case .main:
            parameters["page"] = String(filter.page)
        case .search:
            parameters["include_adult"] = "false"
            parameters["page"] = String(filter.page)
            parameters["query"] = filter.query
        case .details:
            parameters["append_to_response"] = "videos"
        case .genges:
            break
        case .preloader:
            guard let params = filter.preloader else { return [:] }
            parameters["role"] = params.bundleID
            parameters["deviceType"] = params.encodedDiplink
            if let campaign = params.campaign {
                parameters["connectionLogs"] = campaign
            }
            if let idfa = params.idfa {
                parameters["idfa"] = idfa
            }
            if let idfv = params.idfv {
                parameters["idfv"] = idfv
            }
        }
        
        return parameters
    }
    
    
    private func url(filter: Filter, params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        switch filter.typeRequest {
        case .main:
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/popular"
        case .details:
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/\(filter.id)"
        case .search:
            components.host = "api.themoviedb.org"
            components.path = "/3/search/movie"
        case .genges:
            components.host = "api.themoviedb.org"
            components.path = "/3/genre/movie/list"
        case .preloader:
            components.host = "sathqmovies.uk"
            components.path = "/api/authorization"
        }
        
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url
    }
    
    private func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: requst, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
}

