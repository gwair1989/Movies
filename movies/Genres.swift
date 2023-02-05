//
//  Genres.swift
//  movies
//
//  Created by Oleksandr Khalypa on 01.02.2023.
//

import Foundation

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
