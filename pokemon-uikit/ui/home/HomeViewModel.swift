//
//  HomeViewModel.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation
import Combine

class HomeViewModel {
    
    private(set) var apiResult = PassthroughSubject<ApiResult<PokemonHomePageResponse>, Never>()
    private(set) var items: [PokemonHomePageItem] = []
    
    private let limit = 50
    private var isRequesting = false
    private var currentOffset = 0
    private var reachedToTheEnd = false
    
    func requestMore() {
        if isRequesting || reachedToTheEnd {
            return
        }
        isRequesting = true
        Task {
            apiResult.send(.loading)
            let result: ApiResult<PokemonHomePageResponse> = await ApiManager.shared.makeRequest(
                endpoint: "pokemon",
                method: .GET,
                requestModel: PokemonHomePageRequest(
                    limit: limit,
                    offset: currentOffset
                )
            )
            result.onSuccess { [weak self] data in
                guard let self = self else { return }
                self.items.append(contentsOf: data.results.map { item in
                    PokemonHomePageItem(name: item.name.capitalizingFirstLetter(), url: item.url)
                })
                self.currentOffset += data.results.count
                if self.currentOffset >= data.count {
                    reachedToTheEnd = true
                }
            }
            apiResult.send(result)
            isRequesting = false
        }
    }
}
