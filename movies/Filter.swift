//
//  Filter.swift
//  movies
//
//  Created by Oleksandr Khalypa on 01.02.2023.
//

import Foundation
protocol TypeRequestProtocol {
    var typeRequest: TypeRequest { get set }
}


struct Filter: TypeRequestProtocol {
    var typeRequest: TypeRequest
    var page: Int = 1
    var query: String = ""
    var id: Int = 0
    var preloader: PreloaderParameters?
}


struct PreloaderParameters {
    let bundleID = "com.sat.hqmovies"
    var encodedDiplink: String?
    var campaign: String?
    var idfa: String?
    var idfv: String?
}
