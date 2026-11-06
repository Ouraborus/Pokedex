//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import SwiftUI

struct PokemonDetailView: View {
    @State private var viewModel: PokemonDetailViewModel
    
    init(id: Int, repository: any PokemonRepository) {
        _viewModel = State(initialValue: PokemonDetailViewModel(id: id, repository: repository))
    }
    
    var body: some View {
        content
            .navigationTitle("Pokemon Details")
            .task { await viewModel.load() }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let detail):
            ForEach(detail.stats, id: \.name) { stat in
                HStack {
                    Text(stat.name.uppercased())
                        .font(.caption.monospaced())
                        .frame(width: 110, alignment: .leading)
                    Text("\(stat.value)")
                        .monospacedDigit()
                        .frame(width: 36, alignment: .trailing)
                }
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
