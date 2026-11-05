//
//  PokemonListViewModelTests.swift
//  PokedexTests
//
//  Created by Ouraborus on 5/11/26.
//

import Testing
@testable import Pokedex

struct StubRepository: PokemonRepository {
    var pokemonPageResult: Result<PokemonPage, Error>
    
    func page(offset: Int, limit: Int) async throws -> Pokedex.PokemonPage {
        try pokemonPageResult.get()
    }
}
@MainActor
struct PokemonListViewModelTests {
    
    @Test func showLoadedItems() async {
        // Given
        let pokemonSummaryMock = [PokemonSummary(id: 25, name: "Pikachu")]
        let mock = PokemonPage(items: pokemonSummaryMock, hasMore: false)
        let stubRepository = StubRepository(pokemonPageResult: .success(mock))
        let viewModel = PokemonListViewModel(repository: stubRepository)
        
        // When
        await viewModel.load()
        
        // Then
        #expect(viewModel.state == .loaded(pokemonSummaryMock))
    }
    
    @Test func showEmptyState() async {
        // Given
        let mock = PokemonPage(items: [], hasMore: false)
        let stubRepository = StubRepository(pokemonPageResult: .success(mock))
        let viewModel = PokemonListViewModel(repository: stubRepository)
        
        // When
        await viewModel.load()
        
        // Then
        #expect(viewModel.state == .empty)
    }
}
