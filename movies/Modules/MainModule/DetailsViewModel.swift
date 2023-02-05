//
//  DetailsViewModel.swift
//  movies
//
//  Created by Oleksandr Khalypa on 04.02.2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    var model: Dynamic<DetailModel?> { get set }
    var filter: Filter { get set }
    func fetchDetail(filter: Filter)
}

final class DetailsViewModel: DetailsViewModelProtocol, ViewModelProtocol {
    
    private let dataService: DataServiseProtocol
    var model: Dynamic<DetailModel?> = Dynamic(nil)
    
    var filter: Filter = Filter(typeRequest: .details, id: 0) {
        didSet {
            model.value = nil
            fetchDetail(filter: filter)
        }
    }
    
    init(dataService: DataServiseProtocol = DataFetcherService()) {
        self.dataService = dataService
    }
    
    func fetchDetail(filter: Filter) {
        dataService.fetchDetail(filter: filter) { [weak self] data in
            guard let self, let data else { return }
            DispatchQueue.main.async {
                self.model.value = DetailModel(backdropPath: data.backdropPath,
                                               genres: self.getGenres(genres: data.genres),
                                               overview: data.overview,
                                               title: data.title,
                                               posterPath: data.posterPath,
                                               countries: self.getCountries(countries: data.countries),
                                               releaseDate: self.getYear(date: data.releaseDate),
                                               voteAverage: String(data.voteAverage), youtubeID: self.getVideoID(videos: data.videos))
            }
        }
    }
    
    private func getVideoID(videos: Videos) -> String {
        return videos.results.first?.key ?? ""
    }
    
    private func getGenres(genres: [Genre]) -> String {
        let genresNames: [String] = genres.map { $0.name }
        return fillString(strings: genresNames)
    }
    
    private func getCountries(countries: [Countries]) -> String {
        let names: [String] = countries.map { $0.name }
        return fillString(strings: names)
    }
    
}
