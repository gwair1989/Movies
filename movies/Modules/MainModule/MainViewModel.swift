//
//  MainViewModel.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import Foundation

protocol MainViewModelProtocol {
    var model: Dynamic<[MainModel]> { get set }
    var filter: Filter { get set }
    var query: String { get set }
    func fetchMovies(filter: Filter)
}

final class MainViewModel: MainViewModelProtocol, ViewModelProtocol {
    var model: Dynamic<[MainModel]> = Dynamic([MainModel]())
    private let dataService: DataServiseProtocol
    private var genres: [Int:String] = [:]
    
    var filter: Filter = Filter(typeRequest: .main, page: 1) {
        didSet {
            if oldValue.typeRequest == filter.typeRequest {
                if filter.page >= oldValue.page {
                    model.value = []
                    fetchMovies(filter: filter)
                }
            } else {
                model.value = []
                fetchMovies(filter: filter)
            }
        }
    }
    private var totalPages = 1
    
    var query: String = "" {
        didSet {
            filter = Filter(typeRequest: .search, page: 1, query: query)
        }
    }
    
    
    init(dataService: DataServiseProtocol = DataFetcherService()) {
        self.dataService = dataService
        self.fetchGenres()
        self.fetchMovies(filter: filter)
    }
    
    
    
    func fetchMovies(filter: Filter) {
        if filter.page <= totalPages {
            dataService.fetchData(filter: filter) { [weak self] results in
                guard let self, let results else { return }
                self.totalPages = results.totalPages
                var movies = [MainModel]()
                for i in results.results {
                    if i.posterPath != nil && i.backdropPath != nil {
                    movies.append(MainModel(id: i.id,
                                            title: i.title,
                                            year: self.getYear(date: i.releaseDate),
                                            posterPath: i.posterPath ?? "", backdropPath: i.posterPath ?? "",
                                            genres: self.getGenres(ids: i.genreIDS),
                                            rating: String(i.voteAverage)))
                }
                }
                self.model.value = movies
                
            }
        }
        }
    
    private func getGenres(ids: [Int]) -> String {
        let genre = ids.map { genres[$0] ?? "Genre not found" }
        return fillString(strings: genre)
    }
    
//    private func fillString(strings: [String]) -> String {
//        return strings.joined(separator: ", ")
//    }
//
//    private func getYear(date: String) -> String {
//        let year = date.prefix(4)
//        return String(year)
//    }
//
    
   private func fetchGenres() {
       dataService.fetchGenres(filter: Filter(typeRequest: .genges, page: 1)) { [weak self] reslts in
            guard let self, let reslts else { return }
            var localGenres: [Int:String] = [:]
            for i in reslts.genres {
                localGenres[i.id] = i.name
            }
            self.genres = localGenres
        }
    }
    
    
}
