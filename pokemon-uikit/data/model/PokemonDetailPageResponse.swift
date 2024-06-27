//
//  PokemonDetailPageResponse.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 26.06.2024.
//

import Foundation

struct PokemonDetailPageResponse: Codable {
    let abilities: [PokemonAbility]?
    let sprites: PokemonSprites?
    let types: [PokemonType]?
    let stats: [PokemonStats]?
}

struct PokemonAbility: Codable {
    let ability: PokemonAbilityItem?
    let isHidden: Bool?
}

struct PokemonAbilityItem: Codable {
    let name: String
}

struct PokemonSprites: Codable {
    let frontDefault: String?
    let backDefault: String?
}

struct PokemonType: Codable {
    let type: PokemonTypeItem
}

struct PokemonTypeItem: Codable {
    let name: String
}

struct PokemonStats: Codable {
    let baseStat: Int
    let effort: Int
    let stat: PokemonStatItem
}

struct PokemonStatItem: Codable {
    let name: String
}
