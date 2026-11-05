//
//  AppDependencies.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import Foundation

struct AppDependencies: Sendable {
    let repository: any PokemonRepository
    
    static func live() -> AppDependencies {
        AppDependencies(repository: RemotePokemonRepository(client: URLSessionAPIClient()))
    }
}
