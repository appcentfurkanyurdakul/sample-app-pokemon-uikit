//
//  ApiError.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 25.06.2024.
//

import Foundation

enum ApiError {
    case noNetwork
    case httpCode(_ code: Int)
    case parseError
    case invalidResponse
    case unknownError
}
