//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class PokemonDetailViewModel {
    private(set) var state: LoadState<PokemonDetail> = .idle
    private let repository: any PokemonRepository

    private(set) var id: Int = 0
    
    init(id: Int, repository: any PokemonRepository) {
        self.id = id
        self.repository = repository
    }
    
    func load() async {
        if case .loaded = state {
            state = .loading
        }
        
        do {
            let detail = try await repository.detail(id: self.id)
            state = .loaded(detail)
            
        } catch is CancellationError {
            // Cancellation is not an error
        }
        catch {
            state = .failed(Self.messageFor(error))
        }
    }
    
    private static func messageFor(_ error: any Error) -> String {
        switch error as? NetworkError {
        case .notConnectedToInternet: "You're offline. Check your connection and try again."
        default: "There was an error, please try again."
        }
    }
}
