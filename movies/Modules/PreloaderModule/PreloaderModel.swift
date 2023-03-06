//
//  PreloaderModel.swift
//  movies
//
//  Created by Oleksandr Khalypa on 01.03.2023.
//

import Foundation

// MARK: - User
struct PreloaderModel: Codable {
    let access: String
    
    let connection: String?
    let sessionID: String
    let statusCode: Int
    let storageBucket: String
    let statusMessage: String?
    

    enum CodingKeys: String, CodingKey {
        case access, connection, sessionID
        case statusCode = "status_code"
        case storageBucket = "storage_bucket"
        case statusMessage = "status_message"
    }
}
