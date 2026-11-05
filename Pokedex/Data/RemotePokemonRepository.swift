//
//  RemotePokemonRepository.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation

struct RemotePokemonRepository: PokemonRepository {
    let client: any APIClient
    
    func page(offset: Int, limit: Int) async throws -> PokemonPage {
        // Call the pokemon list
        let response: PokemonListResponse = try await client.send(.pokemonList(limit: limit, offset: offset))
        
        // map the Items only keeping the non nil values
        let items = response.results.compactMap { PokemonSummary($0) }
        
        // Return the pokemon page
        return PokemonPage(items: items, hasMore: response.next != nil)
    }
    
    func detail(id: Int) async throws -> PokemonDetail {
        async let pokemonDetail: PokemonDetailDTO = client.send(.pokemon(id: id))
        async let species: SpeciesDTO = client.send(.species(id: id))
        
        return try await PokemonDetail(pokemonDetail: pokemonDetail, species: species)
    }
}
