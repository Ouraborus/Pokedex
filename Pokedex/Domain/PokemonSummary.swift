//
//  PokemonSummary.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation

struct PokemonSummary: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    
    var displayName: String { name.capitalized }
    var number: String { String(format: "#%03d", id) }
    
    var imageUrl: URL {
        // Id is an Int, so URL is always valid
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")!
    }
}

extension PokemonSummary {
    init?(_ namedResource: NamedResource) {
        guard let id = Int(namedResource.url.lastPathComponent) else { return nil }
        
        self.init(id: id, name: namedResource.name)
    }
}

struct PokemonPage: Equatable, Sendable {
    let items: [PokemonSummary]
    let hasMore: Bool
}
