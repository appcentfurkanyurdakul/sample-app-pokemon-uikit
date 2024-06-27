//
//  PokemonHomePageResponse.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation

struct PokemonHomePageResponse: Codable {
    let count: Int
    let results: [PokemonHomePageItem]
}

struct PokemonHomePageItem: Codable {
    let name: String
    let url: String
}
