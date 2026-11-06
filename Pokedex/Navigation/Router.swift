//
//  Router.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import Foundation

enum Route: Hashable {
    case detail(id: Int)
}

@MainActor
@Observable
final class Router {
    var path: [Route] = []
    
    func show(_ route: Route) { path.append(route) }
    func popToRoot() { path.removeAll() }
    
    func handle(url: URL) {
        guard url.scheme == "pokedex", url.host == "pokemon", let id = Int(url.lastPathComponent) else { return }
        path = [.detail(id: id)]
    }
}
