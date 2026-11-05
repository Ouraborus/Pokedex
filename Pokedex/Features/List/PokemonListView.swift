//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import SwiftUI

struct PokemonListView: View {
    @State private var viewModel: PokemonListViewModel
    
    init(repository: any PokemonRepository) {
        _viewModel = State(initialValue: PokemonListViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokedex")
        }
        .task {
            await viewModel.load()
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let pokemons):
            List {
                ForEach(pokemons) { item in
                    NavigationLink(value: 1) {
                        PokemonRowView(pokemon: item)
                    }
                    .onAppear {
                        Task { await viewModel.loadNextPageIfNeeded(currentItem: item)}
                    }
                }
            }
           
            if viewModel.hasMore {
                ProgressView().frame(maxWidth: .infinity)
            }
        case .empty:
            ContentUnavailableView("Content Unavailable", systemImage: "wifi.exclamationmark")
        case .failed(let string):
            ContentUnavailableView(
                "Content Unavailable",
                systemImage: "wifi.exclamationmark",
                description: Text(string)
            )
        }
    }
}

struct PokemonRowView: View {
    let pokemon: PokemonSummary
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: pokemon.imageUrl) {
                $0.resizable().scaledToFit()
            } placeholder: {
                RoundedRectangle(cornerRadius: 8).fill(.quaternary)
            }
            .frame(width: 56, height: 56)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(pokemon.number)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                Text(pokemon.displayName)
                    .font(.headline)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
