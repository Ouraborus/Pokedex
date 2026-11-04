//
//  DTOs.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation

struct NamedResource: Decodable, Sendable {
    let name: String?
    let url: URL
}

struct PokemonListResponse: Decodable, Sendable {
    let count: Int
    let next: URL? // Last page is nil
    let results: [NamedResource]
}

struct PokemonDetailDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeEntry]
    let stats: [StatEntry]
    let sprites: Sprite
    
    struct TypeEntry: Decodable, Sendable {
        let slot: Int
        let type: NamedResource
    }
    
    struct StatEntry: Decodable, Sendable {
        let baseStat: Int
        let stat: NamedResource
    }
    
    struct Sprite: Decodable, Sendable {
        let other: Other
        
        struct Other: Decodable, Sendable {
            let officialArtwork: ArtWork
            
            enum CodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
            }
        }
        
        struct ArtWork: Decodable, Sendable {
            let frontDefault: URL?
        }
    }
}
