//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import Foundation

struct PokemonDetail: Equatable, Sendable {
    struct Stat: Equatable, Sendable {
        let name: String
        let value: Int
    }
    
    let id: Int
    let name: String
    let heightInMeters: Double
    let weightInKilograms: Double
    let types: [String]
    let stats: [Stat]
    let imageURL: URL?
    let flavorText: String
}

extension PokemonDetail {
    init(pokemonDetail: PokemonDetailDTO, species: SpeciesDTO) {
        self.init(
            id: pokemonDetail.id,
            name: pokemonDetail.name,
            heightInMeters: Double(pokemonDetail.height) / 10,     // decímetros → metros
            weightInKilograms: Double(pokemonDetail.weight) / 10,
            types: pokemonDetail.types.sorted { $0.slot < $1.slot }.map(\.type.name),
            stats: pokemonDetail.stats.map { Stat(name: $0.stat.name, value: $0.baseStat) },
            imageURL: pokemonDetail.sprites.other.officialArtwork.frontDefault,
            flavorText: species.englishDescription
        )
    }
}
