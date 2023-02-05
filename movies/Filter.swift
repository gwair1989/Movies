//
//  Filter.swift
//  movies
//
//  Created by Oleksandr Khalypa on 01.02.2023.
//

import Foundation

struct Filter {
    var typeRequest: TypeRequest
    var page: Int = 1
    var query: String = ""
    var id: Int = 0
}
