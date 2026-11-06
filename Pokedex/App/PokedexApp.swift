//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import SwiftUI

@main
struct PokedexApp: App {
    private let dependencies = AppDependencies.live()

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: .live())
        }
    }
}
