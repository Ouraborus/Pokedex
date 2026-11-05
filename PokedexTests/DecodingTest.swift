//
//  DecodingTest.swift
//  PokedexTests
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation
import Testing
@testable import Pokedex

private final class BundleToken {}

enum Fixture {
    static func data(_ name: String) throws -> Data {
        let url = try #require(Bundle(for: BundleToken.self).url(forResource: name, withExtension: "json"))
        return try Data(contentsOf: url)
    }
}

@MainActor
struct DecodingTest {
    @Test func decodePikachu() throws {
        let dto = try JSONDecoder.pokeAPI.decode(PokemonDetailDTO.self, from: Fixture.data("Pikachu"))
        #expect(dto.id == 25)
        #expect(dto.types.first?.type.name == "electric")
        #expect(dto.stats.count == 6)
        #expect(dto.sprites.other.officialArtwork.frontDefault != nil)
    }
    
    @Test func extractsIDFromResourceURL() throws {
        let resource = NamedResource(name: "pikachu", url: URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!)
        #expect(PokemonSummary(resource)?.id == 25)
    }
}
