//
//  Protocol.swift
//  movies
//
//  Created by Oleksandr Khalypa on 06.02.2023.
//

import Foundation

protocol ViewModelProtocol {
    func fillString(strings: [String]) -> String
    func getYear(date: String) -> String
}

extension ViewModelProtocol {
    func fillString(strings: [String]) -> String {
        return strings.joined(separator: ", ")
    }
    
    func getYear(date: String) -> String {
        let year = date.prefix(4)
        return String(year)
    }
}
