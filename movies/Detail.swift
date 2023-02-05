//
//  Detail.swift
//  movies
//
//  Created by Oleksandr Khalypa on 04.02.2023.
//

import Foundation

// MARK: - Details
struct Detail: Codable {
    let backdropPath: String
    let genres: [Genre]
    let overview: String
    let title: String
    let posterPath: String
    let countries: [Countries]
    let releaseDate: String
    let voteAverage: Double
    let videos: Videos

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres, overview, title
        case posterPath = "poster_path"
        case countries = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case videos
    }
}

// MARK: - Countries
struct Countries: Codable {
    let name: String
}

// MARK: - Videos
struct Videos: Codable {
    let results: [Results]
}

// MARK: - Result
struct Results: Codable {
    let key: String
}
