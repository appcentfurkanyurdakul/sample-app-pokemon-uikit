//
//  DetailViewModel.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 25.06.2024.
//

import Foundation
import Combine

class DetailViewModel {
    
    let pokemonName: String
    
    @Published
    private(set) var apiResult: ApiResult<PokemonDetailUiItem> = .initial
    
    private let detailUrl: String
    
    private let mapper = PokemonDetailPageResponseMapper()
    
    init(pokemonName: String, detailUrl: String) {
        self.pokemonName = pokemonName
        self.detailUrl = detailUrl
        requestData()
    }
    
    func requestData() {
        Task {
            apiResult = .loading
            let result: ApiResult<PokemonDetailPageResponse> = await ApiManager.shared.makeRequest(
                url: detailUrl,
                method: .GET
            )
            apiResult = result.mapSuccess { data in
                self.mapper.map(pokemonName: self.pokemonName, inValue: data)
            }
        }
    }
}
