//
//  PokemonDetailResponseMapper.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 26.06.2024.
//

import Foundation

class PokemonDetailPageResponseMapper {
    
    func map(pokemonName: String, inValue: PokemonDetailPageResponse) -> PokemonDetailUiItem {
        let frontImage = inValue.sprites?.frontDefault
        let backImage = inValue.sprites?.backDefault
        var textItems: [PokemonDetailTextItem] = []
        
        // pokemon types
        mapItem(textItems: &textItems, headerTitle: "Types", items: inValue.types) { type in
            type.type.name.capitalizingFirstLetter()
        }
        
        // pokemon abilities
        mapItem(textItems: &textItems, headerTitle: "Abilities", items: inValue.abilities) { ability in
            if (ability.isHidden == true) {
                "\(ability.ability?.name.capitalizingFirstLetter() ?? "") (Hidden)"
            } else {
                "\(ability.ability?.name.capitalizingFirstLetter() ?? "")"
            }
        }
        
        // pokemon stats
        mapItem(textItems: &textItems, headerTitle: "Stats", items: inValue.stats) { stat in
            let statName = stat.stat.name.capitalizingFirstLetter()
            return "\(statName): \(stat.baseStat)"
        }
        
        return PokemonDetailUiItem(
            frontImage: frontImage,
            backImage: backImage,
            texts: textItems
        )
    }
    
    private func mapItem<T>(
        textItems: inout [PokemonDetailTextItem],
        headerTitle: String,
        items: [T]?,
        _ mapper: (T) -> String
    ) {
        if items != nil && !items!.isEmpty {
            textItems.append(PokemonDetailTextItem(type: .header, text: headerTitle))
            items!.forEach { item in
                textItems.append(PokemonDetailTextItem(type: .label, text: mapper(item)))
            }
        }
    }
}
