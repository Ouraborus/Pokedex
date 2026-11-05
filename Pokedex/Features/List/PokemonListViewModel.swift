//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class PokemonListViewModel {
    private(set) var state: LoadState<[PokemonSummary]> = .idle
    private let repository: any PokemonRepository
    
    private(set) var items: [PokemonSummary] = []
    private(set) var hasMore: Bool = true
    private var nextOffset: Int = 0
    private var isLoadingPage: Bool = false
    private let pageSize: Int = 20
    
    init(repository: any PokemonRepository) {
        self.repository = repository
    }
    
    func loadNextPageIfNeeded(currentItem: PokemonSummary) async {
        guard currentItem.id == items.last?.id else { return }
        await loadNextPage()
    }
    
    func loadNextPage() async {
        guard hasMore, !isLoadingPage else { return }
        isLoadingPage = true
        defer { isLoadingPage = false }
        
        do {
            let nextPage = try await repository.page(offset: nextOffset, limit: pageSize)
            items.append(contentsOf: nextPage.items)
            nextOffset += nextPage.items.count
            hasMore = nextPage.hasMore
            state = items.isEmpty ? .empty : .loaded(items)
        } catch is CancellationError {
            // Cancellation is not an error
        } catch {
            state = .failed(Self.messageFor(error))
        }
    }
    
    private static func messageFor(_ error: any Error) -> String {
        switch error as? NetworkError {
        case .notConnectedToInternet: "You're offline. Check your connection and try again."
        default: "There was an error, please try again."
        }
    }
    
    func load() async {
        if case .loaded = state {
            state = .loading
        }
        
        items = []
        hasMore = true
        nextOffset = 0

        await loadNextPage()
    }
}
