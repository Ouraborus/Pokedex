//
//  RootView.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies
    @State private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            PokemonListView(repository: dependencies.repository)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .detail(let id):
                        PokemonDetailView(id: id, repository: dependencies.repository)
                    }
                }
        }
        .environment(router)
        .onOpenURL { router.handle(url: $0) }
    }
}
