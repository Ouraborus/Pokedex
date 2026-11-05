//
//  DTOs.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation

struct NamedResource: Decodable, Sendable {
    let name: String
    let url: URL
}

struct PokemonListResponse: Decodable, Sendable {
    let count: Int
    let next: URL? // Last page is nil
    let results: [NamedResource]
}

nonisolated struct PokemonDetailDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeEntry]
    let stats: [StatEntry]
    let sprites: Sprite
    
    nonisolated struct TypeEntry: Decodable, Sendable {
        let slot: Int
        let type: NamedResource
    }
    
    nonisolated struct StatEntry: Decodable, Sendable {
        let baseStat: Int
        let stat: NamedResource
    }
    
    nonisolated struct Sprite: Decodable, Sendable {
        let other: Other
        
        nonisolated struct Other: Decodable, Sendable {
            let officialArtwork: ArtWork
            
            enum CodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
            }
        }
        
        nonisolated struct ArtWork: Decodable, Sendable {
            let frontDefault: URL?
        }
    }
}

nonisolated struct SpeciesDTO: Decodable, Sendable {
    let flavorTextEntries: [FlavorText]

    nonisolated struct FlavorText: Decodable, Sendable {
        let flavorText: String
        let language: NamedResource
    }

    var englishDescription: String {
        let raw = flavorTextEntries.first { $0.language.name == "en" }?.flavorText ?? ""
        return raw
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{0C}", with: " ")   // PokeAPI trae saltos de página
    }
}
