//
//  KataPokemon.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import Foundation

struct KataPokemon: Equatable {
    let id: Int
    let name: String
    let types: [String]
    let stats: [Int]   // los 6 base stats
    let weight: Int
}

// Extract ID from URL without REGEX
// https://pokeapi.co/api/v2/pokemon/25/
// O(1)
func extractIDWithoutREGEX(url: URL) -> Int? {
    let urlString = url.absoluteString
    guard let idAsString = urlString.split(separator: "/").last else { return nil }
    return Int(idAsString)
}

// Count by type from major to minor
// [KataPokemon] → [(type: String, count: Int)]
// O(N^2)
func countByType(pokemons: [KataPokemon]) -> [(type: String, count: Int)] {
    // get a set of types
    var counts: [String: Int] = [:]
    pokemons.forEach { pokemon in
        pokemon.types.forEach { type in
            counts[type, default: 0] += 1
        }
    }
    
    return counts
        .map {
            (type: $0.key, count: $0.value)
        }
        .sorted {
            $0.count != $1.count ? $0.count > $1.count : $0.type < $1.type
        }
}

// Two pokemon weighting X
// O(n)
func pair(target: Int, pokemons: [KataPokemon]) -> (KataPokemon, KataPokemon)? {
    var seenByWeight: [Int: KataPokemon] = [:]
    
    for pokemon in pokemons {
        if let match = seenByWeight[target - pokemon.weight] {
            return (match, pokemon)
        }
        
        seenByWeight[pokemon.weight] = pokemon
    }
    
    return nil
}

func anagram(names: [KataPokemon]) -> [String: [String]] {
    var groups: [String: [String]] = [:]
    
    names.forEach {
        let key = String($0.name.lowercased().sorted())
        groups[key, default: []].append($0.name)
    }
    
    return groups
}
