//
//  Endpoint.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation

enum HTTPMethod: String, Sendable {
    case get = "GET"
}

struct Endpoint: Sendable {
    var path: String
    var method: HTTPMethod = .get
    var queryParams: [URLQueryItem] = []
}

extension Endpoint {
    static func pokemonList(limit: Int, offset: Int) -> Endpoint {
        Endpoint(
            path: "/pokemon",
            queryParams: [
                .init(name: "limit", value: String(limit)),
                .init(name: "offset", value: String(offset))
            ])
    }
    
    static func pokemon(id: Int) -> Endpoint {
        return Endpoint(path: "/pokemon/\(id)")
    }
    
    static func species(id: Int) -> Endpoint {
        return Endpoint(path: "/pokemon-species/\(id)")
    }
}
