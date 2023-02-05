//
//  Movies.swift
//  movies
//
//  Created by Oleksandr Khalypa on 31.01.2023.
//

import Foundation

// MARK: - Movies
struct Movies: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let overview: String
    let posterPath: String?
    let releaseDate, title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}

