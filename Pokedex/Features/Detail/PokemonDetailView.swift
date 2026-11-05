//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemonDetail: PokemonDetail
    
    var body: some View {
        ForEach(pokemonDetail.stats, id: \.name) { stat in
            HStack {
                Text(stat.name.uppercased())
                    .font(.caption.monospaced())
                    .frame(width: 110, alignment: .leading)
                Text("\(stat.value)")
                    .monospacedDigit()
                    .frame(width: 36, alignment: .trailing)
            }
        }
    }
}
