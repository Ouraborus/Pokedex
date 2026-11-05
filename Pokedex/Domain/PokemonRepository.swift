//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation

protocol PokemonRepository: Sendable {
    func page(offset: Int, limit: Int) async throws -> PokemonPage
    func detail(id: Int) async throws -> PokemonDetail
}
